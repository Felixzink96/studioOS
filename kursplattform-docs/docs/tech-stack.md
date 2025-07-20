# 🧱 TECH STACK - Kursplattform

## Architektur-Überblick

### Moderne Cloud-Native Architektur
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Frontend      │    │     Backend      │    │   Integrationen │
│   (Next.js)     │◄──►│   (Supabase)     │◄──►│   (Stripe, etc) │
│                 │    │                  │    │                 │
│ • React/TypeScript  │    │ • PostgreSQL     │    │ • Payment       │
│ • Tailwind CSS     │    │ • Authentication │    │ • E-Mail        │
│ • Progressive App   │    │ • Realtime APIs  │    │ • Analytics     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Frontend-Stack

### Core Framework
| Technologie | Version | Begründung |
|-------------|---------|------------|
| **Next.js** | 14+ | Server-Side Rendering, App Router, optimierte Performance |
| **TypeScript** | 5+ | Typsicherheit, bessere Developer Experience |
| **React** | 18+ | Komponentenbasiert, große Community, mature |

### UI & Styling
| Technologie | Begründung |
|-------------|------------|
| **Tailwind CSS** | Utility-first, konsistente Designsprache, mobile-first |
| **CSS Variables** | Theme-System, Dark-Mode-Unterstützung |
| **Lucide Icons** | Moderne, konsistente Icon-Library |

### State Management & Forms
| Use Case | Technologie | Warum |
|----------|-------------|-------|
| **Global State** | Zustand | Leichtgewichtig, TypeScript-first |
| **Server State** | Supabase Client | Realtime, Caching, Optimistic Updates |
| **Forms** | React Hook Form | Performance, Validation, minimale Re-renders |
| **Validation** | Zod | Runtime Validation, TypeScript Integration |

## Backend-Stack

### Database & Backend-as-a-Service
| Service | Rolle | Features |
|---------|-------|----------|
| **Supabase** | Primary Backend | PostgreSQL, Auth, Realtime, Edge Functions |
| **PostgreSQL** | Database | ACID-compliant, Row Level Security, Triggers |
| **Edge Functions** | Serverless Logic | TypeScript, Global Distribution, Auto-scaling |

### Authentication & Security
```typescript
// Supabase Auth Konfiguration
const authConfig = {
  providers: ['email', 'magic_link'],
  emailRedirectTo: 'https://app.kursplattform.de/auth/callback',
  detectSessionInUrl: true,
  persistSession: true,
  autoRefreshToken: true
}

// Row Level Security Beispiel
CREATE POLICY "Users can only see their studio data" ON kurse
FOR SELECT USING (
  studio_id = auth.jwt() ->> 'studio_id'
);
```

### API-Design
- **REST APIs** via Supabase Auto-Generated
- **Realtime Subscriptions** für Live-Updates
- **Edge Functions** für Custom Business Logic
- **Webhooks** für externe Integrationen

## Hosting & Infrastructure

### Deployment Strategy
| Service | Rolle | Kosten |
|---------|-------|--------|
| **Vercel** | Frontend Hosting | Free Tier → $20/Mon |
| **Supabase** | Backend & Database | Free Tier → $25/Mon |
| **All-Inkl** | Domain & DNS | ~2€/Mon |

### Performance Optimierung
```javascript
// Next.js Performance Features
const nextConfig = {
  images: {
    domains: ['supabase.storage'],
    formats: ['image/webp', 'image/avif']
  },
  experimental: {
    optimizeCss: true,
    scrollRestoration: true
  },
  compress: true
}
```

### CDN & Edge Computing
- **Vercel Edge Network** für globale Performance
- **Supabase Edge Functions** für serverseitige Logik
- **Image Optimization** via Next.js + Vercel
- **Static Generation** für öffentliche Seiten

## Externe Integrationen

### Payment Processing
```typescript
// Stripe Integration
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY, {
  apiVersion: '2023-10-16',
  typescript: true
});

// Add-on Subscription Management
const createSubscription = async (customerId: string, priceId: string) => {
  return await stripe.subscriptions.create({
    customer: customerId,
    items: [{ price: priceId }],
    payment_behavior: 'default_incomplete',
    payment_settings: { save_default_payment_method: 'on_subscription' },
    expand: ['latest_invoice.payment_intent']
  });
};
```

### E-Mail Services
| Provider | Use Case | Features |
|----------|----------|----------|
| **Postmark** | Transactional | Hohe Zustellrate, Templates, Analytics |
| **Mailgun** | Alternative | EU-Server, DSGVO-konform |

### Communication
```typescript
// Supabase Realtime für Chat
const chatChannel = supabase
  .channel('chat-room')
  .on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'chat_nachrichten',
    filter: `studio_id=eq.${studioId}`
  }, (payload) => {
    setMessages(prev => [...prev, payload.new]);
  })
  .subscribe();
```

## Development Tools

### Code Quality & Testing
| Tool | Purpose | Configuration |
|------|---------|---------------|
| **ESLint** | Linting | Next.js + TypeScript rules |
| **Prettier** | Formatting | Consistent code style |
| **Husky** | Git Hooks | Pre-commit linting |
| **Jest** | Unit Testing | React Testing Library |
| **Playwright** | E2E Testing | Critical user flows |

### Development Workflow
```json
// package.json scripts
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint --fix",
    "test": "jest --watch",
    "test:e2e": "playwright test",
    "type-check": "tsc --noEmit"
  }
}
```

## Monitoring & Analytics

### Application Monitoring
| Service | Purpose | Integration |
|---------|---------|-------------|
| **Vercel Analytics** | Core Web Vitals | Built-in |
| **Sentry** | Error Tracking | React Error Boundaries |
| **PostHog** | Product Analytics | Event Tracking |

### Business Intelligence
```typescript
// Custom Analytics Events
const trackEvent = (event: string, properties: Record<string, any>) => {
  if (typeof window !== 'undefined') {
    posthog.capture(event, {
      ...properties,
      studio_id: user?.studio_id,
      user_role: user?.role,
      timestamp: new Date().toISOString()
    });
  }
};

// Beispiel-Events
trackEvent('course_booked', { course_id, payment_method });
trackEvent('addon_purchased', { addon_type, price });
```

## Security Architecture

### Data Protection
- **TLS 1.3** für alle Client-Server-Kommunikation
- **Row Level Security** auf Datenbankebene
- **CSRF Protection** via Next.js
- **Content Security Policy** Headers
- **Rate Limiting** auf API-Ebene

### DSGVO Compliance
```sql
-- Daten-Anonymisierung nach Account-Löschung
CREATE OR REPLACE FUNCTION anonymize_user_data(user_uuid UUID)
RETURNS void AS $$
BEGIN
  UPDATE users SET 
    email = 'deleted-' || generate_random_uuid() || '@deleted.local',
    name = 'Deleted User',
    phone = null
  WHERE id = user_uuid;
  
  -- Buchungsdaten für 7 Jahre aufbewahren (anonymisiert)
  UPDATE buchungen SET user_id = null WHERE user_id = user_uuid;
END;
$$ LANGUAGE plpgsql;
```

## Scalability Considerations

### Database Optimization
- **Connection Pooling** via Supabase
- **Read Replicas** für Analytics-Queries
- **Proper Indexing** auf häufige Abfragen
- **Query Optimization** mit EXPLAIN ANALYZE

### Caching Strategy
```typescript
// Next.js Caching
export const revalidate = 3600; // ISR - 1 hour

// Supabase Query Caching
const { data, error } = await supabase
  .from('kurse')
  .select('*')
  .eq('studio_id', studioId)
  .cache(300); // 5 minutes
```

### Performance Targets
| Metric | Target | Measurement |
|--------|--------|-------------|
| **First Contentful Paint** | <1.5s | Lighthouse |
| **Largest Contentful Paint** | <2.5s | Core Web Vitals |
| **API Response Time** | <500ms | Supabase Dashboard |
| **Database Query Time** | <100ms | PostgreSQL logs |

## Future Technology Considerations

### Mobile Strategy
- **Progressive Web App** (PWA) mit Offline-Support
- **Push Notifications** via Web Push API
- **Native App** (React Native/Expo) bei Bedarf

### AI/ML Integration
```typescript
// OpenAI Integration für Zukunfts-Features
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

// KI-Kursempfehlungen
const generateCourseRecommendations = async (userPreferences: string) => {
  const completion = await openai.chat.completions.create({
    model: "gpt-4",
    messages: [{
      role: "system",
      content: "Du bist ein Fitness-Experte und empfiehlst passende Kurse."
    }, {
      role: "user", 
      content: userPreferences
    }]
  });
  return completion.choices[0].message.content;
};
```

### Microservices Evolution
**Aktuelle Architektur:** Monolith (MVP-geeignet)  
**Zukünftige Aufteilung (bei 10k+ Studios):**
- User Service (Auth, Profile)
- Booking Service (Kurse, Buchungen)
- Payment Service (Stripe, Billing)
- Communication Service (Chat, E-Mail)
- Analytics Service (Reporting, KPIs)

## Documentation & Knowledge Management

### API Documentation
- **Automatisch generiert** via Supabase
- **Postman Collections** für externe Entwickler
- **OpenAPI Spec** für Custom-Tarif Kunden

### Code Documentation
```typescript
/**
 * Bucht einen Kurs für einen Teilnehmer
 * Prüft automatisch Kapazität und setzt auf Warteliste falls voll
 * 
 * @param userId - UUID des Teilnehmers
 * @param courseId - UUID des Kurses
 * @returns Promise<BookingResult>
 */
export async function bookCourse(
  userId: string, 
  courseId: string
): Promise<BookingResult> {
  // Implementation...
}
```

---

*Letzte Aktualisierung: Juli 2025*