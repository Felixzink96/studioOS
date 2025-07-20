# 🛠️ Development Setup Guide

Schritt-für-Schritt Anleitung zum Aufsetzen der Entwicklungsumgebung für die Kursplattform.

## 📋 Voraussetzungen

### System-Requirements
- **Node.js:** Version 18+ ([Download](https://nodejs.org))
- **Git:** Für Versionskontrolle
- **VS Code:** Empfohlener Editor
- **Browser:** Chrome/Firefox für Testing

### Accounts erstellen
1. **Supabase:** [supabase.com](https://supabase.com) (kostenlos)
2. **Vercel:** [vercel.com](https://vercel.com) (kostenlos)
3. **Stripe:** [stripe.com](https://stripe.com) (kostenlos für Entwicklung)
4. **All-Inkl:** [all-inkl.com](https://all-inkl.com) (Domain, ca. 2€/Monat)

## 🚀 Projekt-Setup

### 1. Next.js Projekt erstellen
```bash
# Neues Next.js Projekt mit TypeScript
npx create-next-app@latest kursplattform --typescript --tailwind --app --use-npm

cd kursplattform

# Projektabhängigkeiten installieren
npm install @supabase/supabase-js @stripe/stripe-js lucide-react
npm install -D @types/node
```

### 2. Supabase Setup
```bash
# Supabase CLI installieren
npm install -g supabase

# Supabase Projekt initialisieren
supabase init

# Mit deinem Supabase-Projekt verbinden
supabase link --project-ref DEIN_PROJEKT_REF
```

#### Supabase Konfiguration
1. Gehe zu [supabase.com/dashboard](https://supabase.com/dashboard)
2. Erstelle neues Projekt: `kursplattform-dev`
3. Region wählen: **Frankfurt (EU)** für DSGVO
4. Notiere dir:
   - `Project URL`
   - `anon public API key`
   - `service_role secret key`

### 3. Environment Variables
Erstelle `.env.local` im Projekt-Root:
```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://deinprojekt.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=dein_anon_key
SUPABASE_SERVICE_ROLE_KEY=dein_service_key

# Stripe (Entwicklung)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# App Settings
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### 4. Datenbank-Schema einrichten
```bash
# Schema-Datei erstellen
supabase/migrations/20240101000000_initial_schema.sql

# Migration ausführen
supabase db push
```

### 5. Supabase Client konfigurieren
Erstelle `lib/supabase.ts`:
```typescript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
```

## 🎨 Design-System Setup

### Tailwind Konfiguration
Erweitere `tailwind.config.js`:
```javascript
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: '#007AFF',
        secondary: '#5856D6',
        success: '#34C759',
        warning: '#FF9500',
        danger: '#FF3B30',
      },
      fontFamily: {
        sans: ['-apple-system', 'BlinkMacSystemFont', 'SF Pro Display', 'Inter', 'sans-serif'],
      },
      boxShadow: {
        'soft': '0 1px 3px rgba(0, 0, 0, 0.04), 0 1px 2px rgba(0, 0, 0, 0.06)',
        'medium': '0 4px 6px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.06)',
        'large': '0 10px 15px rgba(0, 0, 0, 0.08), 0 4px 6px rgba(0, 0, 0, 0.05)',
      },
    },
  },
  plugins: [],
}
```

## 🔧 Development Workflow

### 1. Lokale Entwicklung starten
```bash
# Development Server
npm run dev

# Supabase lokal starten (optional)
supabase start

# TypeScript checking
npm run type-check
```

### 2. Git Workflow
```bash
# Feature entwickeln
git checkout -b feature/kursbuchung
git add .
git commit -m "feat: add course booking functionality"
git push origin feature/kursbuchung

# Pull Request erstellen auf GitHub
# Nach Review: merge in main
```

### 3. Deployment auf Vercel
```bash
# Vercel CLI installieren
npm install -g vercel

# Erstes Deployment
vercel

# Environment Variables in Vercel setzen:
# - NEXT_PUBLIC_SUPABASE_URL
# - NEXT_PUBLIC_SUPABASE_ANON_KEY
# - STRIPE_SECRET_KEY
# etc.
```

## 🧪 Testing Setup

### Testing Libraries installieren
```bash
npm install -D @testing-library/react @testing-library/jest-dom jest jest-environment-jsdom
```

### Jest Konfiguration (`jest.config.js`)
```javascript
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/$1',
  },
}
```

### Beispiel Test
```typescript
// __tests__/components/KursCard.test.tsx
import { render, screen } from '@testing-library/react'
import KursCard from '@/components/KursCard'

test('renders course title', () => {
  render(<KursCard title="Yoga Flow" />)
  expect(screen.getByText('Yoga Flow')).toBeInTheDocument()
})
```

## 🔍 Debug & Monitoring

### Development Tools
- **React DevTools:** Browser-Extension
- **Supabase Dashboard:** Datenbank-Monitoring
- **Vercel Analytics:** Performance-Tracking
- **Stripe Dashboard:** Payment-Testing

### Logging Setup
```typescript
// lib/logger.ts
export const logger = {
  info: (message: string, data?: any) => {
    console.log(`[INFO] ${message}`, data)
  },
  error: (message: string, error?: any) => {
    console.error(`[ERROR] ${message}`, error)
  }
}
```

## 🚨 Troubleshooting

### Häufige Probleme

**1. Supabase Connection Failed**
```bash
# Check Environment Variables
echo $NEXT_PUBLIC_SUPABASE_URL

# Verify Project Settings in Supabase Dashboard
# Authentication > Settings > Site URL: http://localhost:3000
```

**2. Tailwind Styles nicht geladen**
```bash
# Check Tailwind Config
# Verify content paths in tailwind.config.js
# Restart development server
npm run dev
```

**3. TypeScript Errors**
```bash
# Clear Next.js cache
rm -rf .next
npm run dev

# Check TypeScript version
npx tsc --version
```

## 📚 Nützliche Commands

```bash
# Projekt-Status
npm run build          # Production Build testen
npm run lint           # ESLint check
npm run type-check     # TypeScript check

# Supabase
supabase status        # Service Status
supabase db reset      # Datenbank zurücksetzen
supabase gen types typescript --local  # TypeScript Types generieren

# Deployment
vercel --prod          # Production Deployment
vercel logs            # Deployment Logs
```

## ✅ Setup Verification

Nach dem Setup solltest du:
- ✅ `npm run dev` erfolgreich starten können
- ✅ http://localhost:3000 im Browser öffnen können
- ✅ Supabase Dashboard erreichen können
- ✅ Environment Variables korrekt gesetzt haben
- ✅ Git Repository verbunden haben

**Nächster Schritt:** Beginne mit der Entwicklung der ersten Komponenten! 🚀