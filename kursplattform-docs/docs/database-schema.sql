-- =================================================================
-- KURSPLATTFORM - COMPLETE DATABASE SCHEMA
-- =================================================================
-- Modern course booking platform database structure
-- Alternative to Eversports with free tier and modular add-ons
-- =================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =================================================================
-- CORE TABLES: Studios, Users, Authentication
-- =================================================================

-- Studios (Multi-tenant architecture)
CREATE TABLE studios (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    tarif TEXT CHECK (tarif IN ('free', 'starter', 'pro', 'custom')) DEFAULT 'free',
    logo_url TEXT,
    website_url TEXT,
    
    -- Branding & Customization
    branding JSONB DEFAULT '{}', -- {colors: {primary: "#007AFF"}, fonts: {}}
    
    -- Business Settings
    einstellungen JSONB DEFAULT '{}', -- {stornofrist_stunden: 24, reminder_aktiv: true}
    
    -- Contact & Address
    email TEXT,
    telefon TEXT,
    adresse TEXT,
    
    -- Billing
    stripe_customer_id TEXT,
    billing_email TEXT,
    
    -- Status
    aktiv BOOLEAN DEFAULT true,
    verified BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Users with role-based access
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    name TEXT,
    telefon TEXT,
    
    -- Role-based access control
    rolle TEXT CHECK (rolle IN ('admin', 'trainer', 'teilnehmer')) NOT NULL,
    studio_id UUID REFERENCES studios(id) ON DELETE CASCADE,
    
    -- Profile
    profilbild_url TEXT,
    beschreibung TEXT,
    
    -- Settings
    sprache TEXT DEFAULT 'de',
    benachrichtigungen JSONB DEFAULT '{"email": true, "push": false}',
    
    -- Status
    aktiv BOOLEAN DEFAULT true,
    email_verified BOOLEAN DEFAULT false,
    letzter_login TIMESTAMP WITH TIME ZONE,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =================================================================
-- LOCATION & INFRASTRUCTURE
-- =================================================================

-- Standorte (Multiple locations per studio)
CREATE TABLE standorte (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    studio_id UUID REFERENCES studios(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    adresse TEXT NOT NULL,
    
    -- Location details
    beschreibung TEXT,
    ausstattung TEXT[],
    kapazitaet INTEGER,
    
    -- Coordinates for maps
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    
    -- Operating hours
    oeffnungszeiten JSONB, -- {"mo": {"open": "08:00", "close": "22:00"}}
    
    -- Status
    aktiv BOOLEAN DEFAULT true,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Räume (Rooms within locations)
CREATE TABLE raeume (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    standort_id UUID REFERENCES standorte(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    max_kapazitaet INTEGER NOT NULL,
    ausstattung TEXT[],
    beschreibung TEXT,
    aktiv BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =================================================================
-- TRAINER MANAGEMENT
-- =================================================================

-- Trainer profiles
CREATE TABLE trainer (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    studio_id UUID REFERENCES studios(id) ON DELETE CASCADE,
    
    -- Professional info
    qualifikationen TEXT[],
    spezialisierungen TEXT[],
    erfahrung_jahre INTEGER,
    
    -- Availability
    verfuegbarkeit JSONB, -- Weekly schedule
    stundensatz DECIMAL(8,2),
    
    -- Profile
    bio TEXT,
    social_links JSONB, -- {instagram: "@trainer", website: "..."}
    
    -- Status
    aktiv BOOLEAN DEFAULT true,
    verified BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =================================================================
-- COURSE MANAGEMENT
-- =================================================================

-- Kurse (Main course entity)
CREATE TABLE kurse (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    studio_id UUID REFERENCES studios(id) ON DELETE CASCADE,
    trainer_id UUID REFERENCES trainer(id) ON DELETE SET NULL,
    standort_id UUID REFERENCES standorte(id) ON DELETE SET NULL,
    raum_id UUID REFERENCES raeume(id) ON DELETE SET NULL,
    
    -- Course details
    titel TEXT NOT NULL,
    beschreibung TEXT,
    kategorie TEXT, -- "yoga", "pilates", "fitness", "dance"
    schwierigkeitsgrad TEXT CHECK (schwierigkeitsgrad IN ('anfaenger', 'mittelstufe', 'fortgeschritten', 'alle')),
    
    -- Scheduling
    startzeit TIMESTAMP WITH TIME ZONE NOT NULL,
    endzeit TIMESTAMP WITH TIME ZONE,
    dauer_minuten INTEGER DEFAULT 60,
    
    -- Capacity & Pricing
    max_teilnehmer INTEGER NOT NULL,
    preis DECIMAL(8,2),
    credits_kosten INTEGER,
    
    -- Online course support
    online_kurs BOOLEAN DEFAULT false,
    online_link TEXT,
    online_plattform TEXT, -- "zoom", "teams", "custom"
    
    -- Recurring courses
    wiederholung JSONB, -- {type: "weekly", interval: 1, end_date: "..."}
    parent_series_id UUID REFERENCES kurse(id),
    
    -- Course materials
    materialien TEXT[],
    voraussetzungen TEXT,
    mitbringen TEXT,
    
    -- Booking rules
    stornofrist_stunden INTEGER,
    warteliste_aktiv BOOLEAN DEFAULT true,
    auto_confirm BOOLEAN DEFAULT true,
    
    -- Status
    aktiv BOOLEAN DEFAULT true,
    abgesagt BOOLEAN DEFAULT false,
    absage_grund TEXT,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =================================================================
-- BOOKING SYSTEM
-- =================================================================

-- Buchungen (Main booking entity)
CREATE TABLE buchungen (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    kurs_id UUID REFERENCES kurse(id) ON DELETE CASCADE,
    
    -- Booking status
    status TEXT CHECK (status IN ('gebucht', 'warteliste', 'storniert', 'abgeschlossen')) NOT NULL,
    
    -- Payment info
    bezahlmethode TEXT CHECK (bezahlmethode IN ('cash', 'credits', 'stripe', 'free')),
    preis DECIMAL(8,2),
    credits_verwendet INTEGER DEFAULT 0,
    stripe_payment_intent_id TEXT,
    
    -- Attendance
    anwesend BOOLEAN,
    check_in_zeit TIMESTAMP WITH TIME ZONE,
    check_out_zeit TIMESTAMP WITH TIME ZONE,
    
    -- Notes
    notizen TEXT,
    storno_grund TEXT,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    storniert_am TIMESTAMP WITH TIME ZONE
);

-- Warteliste (Separate table for better management)
CREATE TABLE warteliste (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    kurs_id UUID REFERENCES kurse(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    position INTEGER NOT NULL,
    benachrichtigt BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(kurs_id, user_id),
    UNIQUE(kurs_id, position)
);

-- =================================================================
-- PAYMENT & CREDITS SYSTEM
-- =================================================================

-- User credits (10er-Karten, Guthaben)
CREATE TABLE user_credits (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    studio_id UUID REFERENCES studios(id) ON DELETE CASCADE,
    
    -- Credit details
    credits_aktuell INTEGER NOT NULL DEFAULT 0,
    credits_gekauft INTEGER NOT NULL,
    credits_verwendet INTEGER DEFAULT 0,
    
    -- Validity
    gekauft_am TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ablauf_datum DATE,
    
    -- Payment
    preis_pro_credit DECIMAL(8,2),
    gesamt_preis DECIMAL(8,2),
    stripe_payment_intent_id TEXT,
    
    -- Status
    aktiv BOOLEAN DEFAULT true,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Rechnungen & Belege
CREATE TABLE rechnungen (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    studio_id UUID REFERENCES studios(id) ON DELETE CASCADE,
    buchung_id UUID REFERENCES buchungen(id) ON DELETE SET NULL,
    
    -- Invoice details
    rechnungsnummer TEXT UNIQUE NOT NULL,
    typ TEXT CHECK (typ IN ('kurs', 'credits', 'abo')) NOT NULL,
    betrag DECIMAL(8,2) NOT NULL,
    steuer_prozent DECIMAL(5,2) DEFAULT 19.00,
    steuer_betrag DECIMAL(8,2),
    
    -- Payment
    stripe_payment_intent_id TEXT,
    bezahlt BOOLEAN DEFAULT false,
    bezahlt_am TIMESTAMP WITH TIME ZONE,
    
    -- PDF
    pdf_url TEXT,
    pdf_generiert BOOLEAN DEFAULT false,
    
    -- Status
    storniert BOOLEAN DEFAULT false,
    storno_grund TEXT,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    faellig_am DATE,
    verschickt_am TIMESTAMP WITH TIME ZONE
);

-- =================================================================
-- FEATURE MANAGEMENT (Add-ons)
-- =================================================================

-- Features enabled per studio
CREATE TABLE features_enabled (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    studio_id UUID REFERENCES studios(id) ON DELETE CASCADE,
    
    -- Feature identification
    feature_key TEXT NOT NULL, -- 'chat', 'branding', 'warteliste', 'qr_checkin'
    feature_name TEXT,
    
    -- Status
    aktiv BOOLEAN DEFAULT true,
    aktiv_bis TIMESTAMP WITH TIME ZONE,
    
    -- Billing
    preis_monatlich DECIMAL(8,2),
    stripe_subscription_id TEXT,
    naechste_abrechnung DATE,
    
    -- Usage tracking
    usage_count INTEGER DEFAULT 0,
    usage_limit INTEGER,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(studio_id, feature_key)
);

-- =================================================================
-- COMMUNICATION SYSTEM
-- =================================================================

-- Chat messages
CREATE TABLE chat_nachrichten (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    empfaenger_id UUID REFERENCES users(id) ON DELETE CASCADE,
    studio_id UUID REFERENCES studios(id) ON DELETE CASCADE,
    kurs_id UUID REFERENCES kurse(id) ON DELETE SET NULL,
    
    -- Message content
    nachricht TEXT NOT NULL,
    typ TEXT CHECK (typ IN ('text', 'system', 'booking', 'reminder')) DEFAULT 'text',
    
    -- Message status
    gelesen BOOLEAN DEFAULT false,
    gelesen_am TIMESTAMP WITH TIME ZONE,
    
    -- Thread support
    thread_id UUID,
    antwort_auf UUID REFERENCES chat_nachrichten(id),
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Feedback & Reviews
CREATE TABLE feedback (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    kurs_id UUID REFERENCES kurse(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    trainer_id UUID REFERENCES trainer(id) ON DELETE SET NULL,
    
    -- Rating & Review
    bewertung INTEGER CHECK (bewertung >= 1 AND bewertung <= 5),
    kommentar TEXT,
    
    -- Categories
    kategorie_bewertungen JSONB, -- {instruction: 5, atmosphere: 4, difficulty: 3}
    
    -- Moderation
    oeffentlich BOOLEAN DEFAULT true,
    moderiert BOOLEAN DEFAULT false,
    moderator_notiz TEXT,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =================================================================
-- LOGGING & AUDIT SYSTEM
-- =================================================================

-- Activity logs for debugging and support
CREATE TABLE activity_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    studio_id UUID REFERENCES studios(id) ON DELETE CASCADE,
    
    -- Action details
    action_type TEXT NOT NULL, -- 'buchung', 'zahlung', 'storno', 'login', 'feature_toggle'
    action_description TEXT,
    action_context JSONB, -- Flexible additional data
    
    -- Request context
    ip_address INET,
    user_agent TEXT,
    session_id TEXT,
    
    -- Admin flags
    admin_viewed BOOLEAN DEFAULT false,
    wichtig BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =================================================================
-- TRIGGERS & FUNCTIONS
-- =================================================================

-- Auto-update timestamp trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply to relevant tables
CREATE TRIGGER update_studios_updated_at BEFORE UPDATE ON studios FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_kurse_updated_at BEFORE UPDATE ON kurse FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_buchungen_updated_at BEFORE UPDATE ON buchungen FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =================================================================
-- BOOKING LOGIC WITH WAITLIST
-- =================================================================

-- Function to handle course booking with automatic waitlist
CREATE OR REPLACE FUNCTION handle_buchung_limiter()
RETURNS TRIGGER AS $$
DECLARE
    count_buchungen INTEGER;
    kurs_kapazitaet INTEGER;
    warteliste_position INTEGER;
    studio_id_var UUID;
BEGIN
    -- Get current bookings count
    SELECT COUNT(*) INTO count_buchungen
    FROM buchungen
    WHERE kurs_id = NEW.kurs_id AND status = 'gebucht';

    -- Get course capacity
    SELECT max_teilnehmer, studio_id INTO kurs_kapazitaet, studio_id_var
    FROM kurse WHERE id = NEW.kurs_id;

    -- Decide: direct booking or waitlist
    IF count_buchungen < kurs_kapazitaet THEN
        NEW.status := 'gebucht';
    ELSE
        NEW.status := 'warteliste';
        
        -- Calculate waitlist position
        SELECT COALESCE(MAX(position), 0) + 1 INTO warteliste_position
        FROM warteliste WHERE kurs_id = NEW.kurs_id;
        
        -- Add to waitlist
        INSERT INTO warteliste (kurs_id, user_id, position)
        VALUES (NEW.kurs_id, NEW.user_id, warteliste_position);
    END IF;

    -- Log the action
    INSERT INTO activity_logs (user_id, studio_id, action_type, action_description, action_context)
    VALUES (
        NEW.user_id,
        studio_id_var,
        'buchung',
        CASE 
            WHEN NEW.status = 'gebucht' THEN 'Kurs erfolgreich gebucht'
            ELSE 'Auf Warteliste gesetzt'
        END,
        jsonb_build_object(
            'kurs_id', NEW.kurs_id,
            'status', NEW.status,
            'warteliste_position', CASE WHEN NEW.status = 'warteliste' THEN warteliste_position END
        )
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply booking trigger
CREATE TRIGGER check_kurs_kapazitaet
    BEFORE INSERT ON buchungen
    FOR EACH ROW
    EXECUTE FUNCTION handle_buchung_limiter();

-- =================================================================
-- WAITLIST MANAGEMENT
-- =================================================================

-- Function to move waitlist users when booking is cancelled
CREATE OR REPLACE FUNCTION handle_waitlist_promotion()
RETURNS TRIGGER AS $$
DECLARE
    next_user_id UUID;
    kurs_kapazitaet INTEGER;
    current_bookings INTEGER;
BEGIN
    -- Only process if booking was cancelled/removed
    IF OLD.status = 'gebucht' AND (NEW.status = 'storniert' OR TG_OP = 'DELETE') THEN
        
        -- Check if course has capacity for waitlist promotion
        SELECT max_teilnehmer INTO kurs_kapazitaet
        FROM kurse WHERE id = OLD.kurs_id;
        
        SELECT COUNT(*) INTO current_bookings
        FROM buchungen WHERE kurs_id = OLD.kurs_id AND status = 'gebucht';
        
        -- If there's space and people waiting
        IF current_bookings < kurs_kapazitaet THEN
            -- Get next person from waitlist
            SELECT user_id INTO next_user_id
            FROM warteliste 
            WHERE kurs_id = OLD.kurs_id
            ORDER BY position ASC
            LIMIT 1;
            
            IF next_user_id IS NOT NULL THEN
                -- Create new booking
                INSERT INTO buchungen (user_id, kurs_id, status, bezahlmethode)
                VALUES (next_user_id, OLD.kurs_id, 'gebucht', 'pending');
                
                -- Remove from waitlist
                DELETE FROM warteliste 
                WHERE kurs_id = OLD.kurs_id AND user_id = next_user_id;
                
                -- Reorder remaining waitlist
                UPDATE warteliste 
                SET position = position - 1
                WHERE kurs_id = OLD.kurs_id;
                
                -- Log promotion
                INSERT INTO activity_logs (user_id, studio_id, action_type, action_description, action_context)
                VALUES (
                    next_user_id,
                    (SELECT studio_id FROM kurse WHERE id = OLD.kurs_id),
                    'warteliste_promotion',
                    'Von Warteliste nachgerückt',
                    jsonb_build_object('kurs_id', OLD.kurs_id, 'promoted_from_position', 1)
                );
            END IF;
        END IF;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Apply waitlist promotion trigger
CREATE TRIGGER promote_from_waitlist
    AFTER UPDATE OR DELETE ON buchungen
    FOR EACH ROW
    EXECUTE FUNCTION handle_waitlist_promotion();

-- =================================================================
-- INDEXES FOR PERFORMANCE
-- =================================================================

-- Core lookup indexes
CREATE INDEX idx_users_studio_id ON users(studio_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_kurse_studio_id ON kurse(studio_id);
CREATE INDEX idx_kurse_startzeit ON kurse(startzeit);
CREATE INDEX idx_kurse_trainer_id ON kurse(trainer_id);
CREATE INDEX idx_buchungen_user_id ON buchungen(user_id);
CREATE INDEX idx_buchungen_kurs_id ON buchungen(kurs_id);
CREATE INDEX idx_buchungen_status ON buchungen(status);

-- Waitlist management
CREATE INDEX idx_warteliste_kurs_id ON warteliste(kurs_id);
CREATE INDEX idx_warteliste_position ON warteliste(kurs_id, position);

-- Feature management
CREATE INDEX idx_features_studio_id ON features_enabled(studio_id);
CREATE INDEX idx_features_active ON features_enabled(studio_id, aktiv) WHERE aktiv = true;

-- Activity logs
CREATE INDEX idx_activity_logs_studio_id ON activity_logs(studio_id);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at);
CREATE INDEX idx_activity_logs_action_type ON activity_logs(action_type);

-- Chat system
CREATE INDEX idx_chat_participants ON chat_nachrichten(sender_id, empfaenger_id);
CREATE INDEX idx_chat_studio_id ON chat_nachrichten(studio_id);
CREATE INDEX idx_chat_created_at ON chat_nachrichten(created_at);

-- =================================================================
-- ROW LEVEL SECURITY (RLS)
-- =================================================================

-- Enable RLS on all sensitive tables
ALTER TABLE studios ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE kurse ENABLE ROW LEVEL SECURITY;
ALTER TABLE buchungen ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_logs ENABLE ROW LEVEL SECURITY;

-- Studio isolation policy
CREATE POLICY "Studios can only access their own data" ON kurse
    FOR ALL USING (studio_id = (auth.jwt() ->> 'studio_id')::UUID);

CREATE POLICY "Users can only access their studio's data" ON buchungen
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM kurse 
            WHERE kurse.id = buchungen.kurs_id 
            AND kurse.studio_id = (auth.jwt() ->> 'studio_id')::UUID
        )
    );

-- User role-based access
CREATE POLICY "Admins can access all studio data" ON activity_logs
    FOR ALL USING (
        studio_id = (auth.jwt() ->> 'studio_id')::UUID
        AND (auth.jwt() ->> 'role') = 'admin'
    );

-- =================================================================
-- SAMPLE DATA (Development only)
-- =================================================================

-- Insert sample studio
INSERT INTO studios (name, slug, tarif, email) VALUES 
('Demo Yoga Studio', 'demo-yoga', 'pro', 'demo@example.com');

-- Insert sample admin user
INSERT INTO users (email, name, rolle, studio_id) VALUES 
('admin@demo-yoga.com', 'Max Mustermann', 'admin', 
 (SELECT id FROM studios WHERE slug = 'demo-yoga'));

-- =================================================================
-- FUNCTIONS FOR APPLICATION USE
-- =================================================================

-- Function to check if feature is enabled for studio
CREATE OR REPLACE FUNCTION is_feature_enabled(studio_uuid UUID, feature_name TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM features_enabled 
        WHERE studio_id = studio_uuid 
        AND feature_key = feature_name 
        AND aktiv = true 
        AND (aktiv_bis IS NULL OR aktiv_bis > NOW())
    );
END;
$$ LANGUAGE plpgsql;

-- Function to get waitlist position
CREATE OR REPLACE FUNCTION get_waitlist_position(kurs_uuid UUID, user_uuid UUID)
RETURNS INTEGER AS $$
DECLARE
    pos INTEGER;
BEGIN
    SELECT position INTO pos
    FROM warteliste 
    WHERE kurs_id = kurs_uuid AND user_id = user_uuid;
    
    RETURN COALESCE(pos, 0);
END;
$$ LANGUAGE plpgsql;

-- =================================================================
-- END OF SCHEMA
-- =================================================================