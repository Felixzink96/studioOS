# 💬 Claude Development Prompts

Sammlung bewährter Prompts für die Entwicklung der Kursplattform mit Claude als Code-Partner.

## 🎯 Basis-Prompts für neuen Chat

### Projekt-Kontext setzen
```
Ich entwickle eine Kursplattform als Eversports-Alternative mit:

- **Tech Stack:** Next.js 14 + TypeScript + Tailwind CSS + Supabase
- **Ziel:** Free-Tier + modulare Add-ons, moderne UX
- **Features:** Kursbuchung, Wartelisten, Chat, QR-Check-in
- **Design:** Moderne, saubere UI (keine explizite Marken-Inspiration)

Hilf mir beim schrittweisen Aufbau der Plattform.
```

### Technische Basis vermitteln
```
Mein Setup:
- Frontend: Next.js 14 mit App Router + TypeScript
- Backend: Supabase (PostgreSQL + Auth + Realtime)
- Styling: Tailwind CSS mit Custom Design System
- Farben: Primary #007AFF, Success #34C759, Warning #FF9500, Danger #FF3B30

Schreibe sauberen, wartbaren Code mit TypeScript und modernen React Patterns.
```

## 🧱 Komponenten-Entwicklung

### UI-Komponente erstellen
```
Erstelle eine React-Komponente [KOMPONENTEN_NAME] mit:

**Anforderungen:**
- TypeScript mit Props-Interface
- Tailwind CSS für Styling
- Moderne, saubere Optik
- Responsive Design
- [Spezifische Funktionalität]

**Props:**
- [Liste der benötigten Props]

**Styling:**
- Primary Color: #007AFF
- Rounded corners: rounded-lg
- Shadows: shadow-soft bis shadow-large
- Hover-Effekte einbauen

Bitte zeige auch ein Verwendungsbeispiel.
```

### Formular-Komponente
```
Baue ein Formular für [ZWECK] mit:

- React Hook Form für State-Management
- TypeScript für Typsicherheit
- Tailwind für Styling
- Validation mit Fehlermeldungen
- Submit-Handler mit Loading-State

Felder: [Liste der Felder mit Typen]

Verwende unser Design-System (Primary: #007AFF, Schatten: shadow-soft).
```

## 🗃️ Supabase & Database

### Datenbank-Schema
```
Erstelle ein Supabase SQL-Schema für [FEATURE]:

**Tabellen benötigt:**
- [Tabelle 1]: [Felder]
- [Tabelle 2]: [Felder]

**Anforderungen:**
- UUID als Primary Keys
- Timestamps (created_at, updated_at)
- Row Level Security (RLS)
- Foreign Key Constraints
- Indizes für Performance

Zeige auch die RLS-Policies und erkläre die Beziehungen.
```

### Supabase Edge Function
```
Schreibe eine Supabase Edge Function für [ZWECK]:

**Funktion:** [Beschreibung]
**Input:** [Parameter]
**Output:** [Rückgabe]
**Logik:** [Geschäftslogik]

Verwende TypeScript und inkludiere Error-Handling und Logging.
```

### Database Query mit TypeScript
```
Schreibe eine TypeScript-Funktion für folgende Supabase-Abfrage:

**Ziel:** [Was soll abgefragt werden]
**Tabellen:** [Beteiligte Tabellen]
**Filter:** [Bedingungen]
**Joins:** [Falls nötig]

Inkludiere TypeScript-Types und Error-Handling.
```

## 🎨 Styling & Design

### Tailwind-Komponente stylen
```
Style diese React-Komponente mit Tailwind CSS:

**Design-Anforderungen:**
- Moderne, saubere Optik
- Primary Color: #007AFF
- Responsive für Mobile + Desktop
- Hover-Effekte und Transitions
- Schatten: shadow-soft für Cards
- Rounded corners: rounded-lg

[Komponenten-Code einfügen]
```

### Design-System-Komponente
```
Erstelle eine [KOMPONENTEN-TYP] nach unserem Design-System:

**Farben:**
- Primary: #007AFF (für Hauptaktionen)
- Success: #34C759 (für positive Aktionen)
- Warning: #FF9500 (für Warnungen)
- Danger: #FF3B30 (für negative Aktionen)

**Größen:** sm, md, lg mit entsprechenden Paddings
**Varianten:** primary, secondary, ghost
**States:** default, hover, disabled

Zeige alle Varianten als Komponente mit Props.
```

## 🔧 Features implementieren

### Kursbuchung-Feature
```
Implementiere die Kursbuchung-Funktionalität:

**Flow:** User wählt Kurs → Plätze prüfen → Buchung oder Warteliste
**Komponenten:** KursCard, BuchungsModal, Warteliste-Anzeige
**Backend:** Supabase Trigger für automatische Warteliste
**UI:** Loading-States, Success-Messages, Error-Handling

Verwende unser Tech-Stack: Next.js + Supabase + Tailwind.
```

### Chat-System
```
Baue ein Chat-System zwischen Studio und Teilnehmern:

**Features:**
- Realtime-Chat mit Supabase Realtime
- Nachrichten-Historie
- Online-Status anzeigen
- Mobile-optimiert

**Komponenten:**
- ChatWindow, MessageList, MessageInput
- TypeScript für Message-Types
- Tailwind für moderne Chat-UI
```

### QR-Check-in
```
Implementiere QR-Code Check-in für Kurse:

**Flow:** 
1. Admin generiert QR-Code für Kurs
2. Teilnehmer scannt QR-Code
3. Automatisches Check-in in Datenbank

**Technisch:**
- QR-Code Generierung (qrcode library)
- QR-Scanner (qr-scanner library)
- Supabase für Check-in-Daten
- Mobile-optimierte UI
```

## 🧪 Testing & Debugging

### Component Testing
```
Schreibe Tests für die [KOMPONENTEN_NAME] Komponente:

**Test-Cases:**
- Rendering mit verschiedenen Props
- User-Interaktionen (Klicks, Input)
- Error-States
- Loading-States

Verwende @testing-library/react und jest. Zeige auch Mocks für Supabase-Calls.
```

### API-Testing
```
Teste die [API_FUNKTION]:

**Szenarien:**
- Erfolgreicher Aufruf
- Error-Handling
- Edge-Cases
- Performance-Test

Verwende Jest und Mock-Daten für Supabase.
```

## 🚀 Deployment & Production

### Production-optimierter Code
```
Optimiere diesen Code für Production:

[Code einfügen]

**Fokus auf:**
- Performance-Optimierung
- Error-Handling
- TypeScript-Strenge
- Security-Best-Practices
- Loading-States
- Accessibility
```

### Vercel Deployment
```
Hilf mir beim Deployment auf Vercel:

**Setup:**
- Environment Variables konfigurieren
- Build-Optimierung
- Static Export für bessere Performance
- Domain-Konfiguration

Zeige mir die notwendigen Schritte und mögliche Probleme.
```

## 🔍 Debugging-Prompts

### Error-Analyse
```
Ich habe folgenden Fehler:

[Fehlermeldung einfügen]

**Code-Kontext:**
[Relevanter Code]

**Was ich versucht habe:**
[Lösungsversuche]

Hilf mir beim Debugging und zeige die korrigierte Version.
```

### Performance-Problem
```
Diese Komponente ist langsam:

[Komponenten-Code]

**Problem:** [Beschreibung]
**Kontext:** [Wann tritt es auf]

Optimiere die Performance mit React-Best-Practices (useMemo, useCallback, etc.).
```

## 📋 Code-Review

### Code-Review-Prompt
```
Reviewe diesen Code auf:

**Qualität:**
- Clean Code Prinzipien
- TypeScript-Best-Practices
- React-Patterns
- Performance-Optimierung

**Security:**
- Input-Validation
- XSS-Schutz
- Supabase RLS

[Code einfügen]

Gib konstruktives Feedback und Verbesserungsvorschläge.
```

## 🎯 Spezielle Feature-Prompts

### Add-on-System implementieren
```
Implementiere das modulare Add-on-System:

**Features:**
- Feature-Flags in Supabase
- Stripe-Integration für Add-on-Käufe
- UI für "Feature freischalten"
- Webhook-Handling

**Flow:** User klickt "Freischalten" → Stripe Checkout → Webhook → Feature aktiviert

Zeige komplette Implementation mit TypeScript.
```

### Wartelisten-Trigger
```
Erstelle den PostgreSQL-Trigger für automatische Wartelisten:

**Logik:**
- Bei Buchung: Plätze prüfen
- Wenn voll: auf Warteliste setzen
- Bei Storno: nächsten von Warteliste nachrücken

Inkludiere auch die TypeScript-Types für die Datenbank-Operationen.
```

---

## 💡 Tipps für effektive Claude-Zusammenarbeit

### ✅ Do's
- **Konkrete Anforderungen** stellen
- **Bestehenden Code** zeigen
- **Gewünschte Technologien** nennen
- **Error-Messages** komplett kopieren
- **Schritt-für-Schritt** vorgehen

### ❌ Don'ts
- Zu vage Anfragen ("Baue mir eine App")
- Mehrere Features gleichzeitig
- Ohne Kontext fragen
- Veraltete Technologien verwenden

### 🎯 Optimal für iterative Entwicklung
1. **Klein anfangen** (eine Komponente)
2. **Feedback geben** ("Das ist gut, aber...")
3. **Erweitern** ("Jetzt füge Feature X hinzu")
4. **Testen lassen** ("Schreibe Tests dafür")
5. **Optimieren** ("Verbessere Performance")

**Verwende diese Prompts als Basis und passe sie an deine spezifischen Bedürfnisse an!** 🚀