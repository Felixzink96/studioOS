# 🎨 Design System - Kursplattform

## Design-Philosophie

### Kernprinzipien
- **Klarheit:** Jedes Element hat einen klaren Zweck, keine überflüssigen Verzierungen
- **Konsistenz:** Einheitliche Patterns, Abstände und Farben durch die gesamte Anwendung
- **Hierarchie:** Wichtige Aktionen sind prominent, sekundäre Funktionen zurückhaltend
- **Vertrauen:** Professionelles Design für Zahlungsprozesse und Geschäftstransaktionen
- **Zugänglichkeit:** Hohe Kontraste, große Touch-Targets, barrierefreie Navigation

### Zielgruppen-orientiertes Design
- **Studios:** Professionell, vertrauenswürdig, business-tauglich
- **Teilnehmer:** Einfach, intuitiv, mobile-optimiert
- **Trainer:** Funktional, übersichtlich, schnell bedienbar

## Innovative Farbpalette

### Primärfarben
```css
:root {
  /* Signature Colors */
  --ocean-blue: #0066FF;      /* Primär-Blau für Hauptaktionen */
  --electric-purple: #6366F1; /* Indigo für sekundäre Elemente */
  --emerald-green: #10B981;   /* Grün für Erfolg, "Gebucht" */
  --amber-orange: #F59E0B;    /* Orange für "Fast voll" */
  --coral-red: #EF4444;       /* Rot für "Ausgebucht", Fehler */
  --soft-violet: #8B5CF6;     /* Akzent für Premium-Features */
  
  /* Neutrale Töne */
  --cloud-white: #FEFEFE;     /* Reines Weiß */
  --mist-gray: #F8FAFC;       /* App-Hintergrund */
  --pearl-gray: #F1F5F9;      /* Card-Hintergrund */
  --silver-gray: #E2E8F0;     /* Border-Farbe */
  --slate-gray: #CBD5E1;      /* Input-Border */
  --steel-gray: #94A3B8;      /* Placeholder */
  --charcoal-gray: #64748B;   /* Sekundärtext */
  --graphite-gray: #475569;   /* Metadaten */
  --dark-gray: #334155;       /* Wichtiger Text */
  --deep-gray: #1E293B;       /* Überschriften */
  --ink-black: #0F172A;       /* Haupttext */
}
```

### Tailwind Custom Config
```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        // Primary palette
        ocean: '#0066FF',
        electric: '#6366F1',
        emerald: '#10B981',
        amber: '#F59E0B',
        coral: '#EF4444',
        violet: '#8B5CF6',
        
        // Gray scale
        cloud: '#FEFEFE',
        mist: '#F8FAFC',
        pearl: '#F1F5F9',
        silver: '#E2E8F0',
        slate: '#CBD5E1',
        steel: '#94A3B8',
        charcoal: '#64748B',
        graphite: '#475569',
        'dark-gray': '#334155',
        'deep-gray': '#1E293B',
        'ink-black': '#0F172A',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      boxShadow: {
        'soft': '0 1px 3px rgba(0, 0, 0, 0.04), 0 1px 2px rgba(0, 0, 0, 0.06)',
        'medium': '0 4px 6px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.06)',
        'large': '0 10px 15px rgba(0, 0, 0, 0.08), 0 4px 6px rgba(0, 0, 0, 0.05)',
        'glow': '0 0 20px rgba(102, 102, 241, 0.15)',
      },
      backdropBlur: {
        'glass': '20px',
      }
    }
  }
}
```

### Semantische Farbanwendung
| Status | Farbe | Tailwind-Klasse | Verwendung |
|--------|-------|----------------|------------|
| **Verfügbar** | Emerald Green | `bg-emerald text-white` | Kurs buchbar, positive Aktionen |
| **Fast voll** | Amber Orange | `bg-amber text-white` | Warnung, Aufmerksamkeit |
| **Ausgebucht** | Coral Red | `bg-coral text-white` | Fehler, Stornierung |
| **Warteliste** | Electric Purple | `bg-electric text-white` | Information, sekundäre Zustände |

## Typografie mit Inter

### Font-Setup
```html
<!-- Google Fonts Import -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
```

### Typografie-Klassen (Tailwind)
| Element | Tailwind-Klassen | Verwendung |
|---------|------------------|------------|
| **H1** | `text-5xl font-bold text-ink-black leading-tight` | Seitentitel, Hero |
| **H2** | `text-3xl font-semibold text-deep-gray leading-tight` | Sektionsüberschriften |
| **H3** | `text-xl font-medium text-dark-gray leading-snug` | Komponentenüberschriften |
| **H4** | `text-lg font-medium text-dark-gray` | Card-Titel |
| **Body** | `text-base text-charcoal leading-relaxed` | Standardtext |
| **Small** | `text-sm text-graphite` | Sekundärtext |
| **Caption** | `text-xs font-medium text-steel uppercase tracking-wide` | Labels, Metadaten |

### Responsive Typografie
```html
<!-- Responsive Headlines -->
<h1 class="text-4xl md:text-5xl lg:text-6xl font-bold text-ink-black">
<h2 class="text-2xl md:text-3xl lg:text-4xl font-semibold text-deep-gray">
```

## Komponenten-Bibliothek (Tailwind)

### Buttons

#### Primär-Button
```html
<button class="bg-ocean hover:bg-ocean/90 text-white px-6 py-3 rounded-xl font-medium transition-all duration-200 shadow-soft hover:shadow-medium hover:-translate-y-0.5 active:translate-y-0">
  Kurs buchen
</button>
```

#### Sekundär-Button
```html
<button class="bg-pearl hover:bg-silver text-charcoal px-6 py-3 rounded-xl font-medium transition-all duration-200">
  Mehr erfahren
</button>
```

#### Ghost-Button
```html
<button class="text-ocean hover:bg-mist px-6 py-3 rounded-xl font-medium transition-all duration-200">
  Abbrechen
</button>
```

#### Danger-Button
```html
<button class="bg-coral hover:bg-coral/90 text-white px-6 py-3 rounded-xl font-medium transition-all duration-200">
  Stornieren
</button>
```

### Cards

#### Standard-Card
```html
<div class="bg-white rounded-2xl p-6 shadow-soft hover:shadow-large transition-all duration-300 border border-silver/50 hover:-translate-y-1">
  <!-- Card Content -->
</div>
```

#### Glassmorphism-Card
```html
<div class="bg-white/70 backdrop-blur-glass rounded-2xl p-6 border border-white/20 shadow-large">
  <!-- Card Content -->
</div>
```

#### Premium-Card (mit Glow)
```html
<div class="bg-gradient-to-br from-electric to-violet rounded-2xl p-6 text-white shadow-glow">
  <!-- Card Content -->
</div>
```

### Status-Badges
```html
<!-- Verfügbar -->
<span class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-medium bg-emerald/10 text-emerald">
  <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
    <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
  </svg>
  Verfügbar
</span>

<!-- Fast voll -->
<span class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-medium bg-amber/10 text-amber">
  <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
    <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
  </svg>
  Fast voll
</span>

<!-- Ausgebucht -->
<span class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-medium bg-coral/10 text-coral">
  <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
  </svg>
  Ausgebucht
</span>
```

## Toast-Benachrichtigungen

### Toast-Container
```html
<div class="fixed top-4 right-4 z-50 space-y-2" id="toast-container">
  <!-- Toasts werden hier eingefügt -->
</div>
```

### Erfolgs-Toast
```html
<div class="flex items-center gap-3 bg-white border-l-4 border-emerald rounded-lg shadow-large p-4 max-w-sm">
  <div class="flex-shrink-0">
    <svg class="w-5 h-5 text-emerald" fill="currentColor" viewBox="0 0 20 20">
      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
    </svg>
  </div>
  <div class="flex-1">
    <p class="text-sm font-medium text-deep-gray">Kurs erfolgreich gebucht!</p>
    <p class="text-xs text-charcoal">Du erhältst eine Bestätigungs-E-Mail</p>
  </div>
  <button class="text-steel hover:text-charcoal">
    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
      <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
    </svg>
  </button>
</div>
```

### Warnung-Toast
```html
<div class="flex items-center gap-3 bg-white border-l-4 border-amber rounded-lg shadow-large p-4 max-w-sm">
  <div class="flex-shrink-0">
    <svg class="w-5 h-5 text-amber" fill="currentColor" viewBox="0 0 20 20">
      <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
    </svg>
  </div>
  <div class="flex-1">
    <p class="text-sm font-medium text-deep-gray">Kurs fast voll!</p>
    <p class="text-xs text-charcoal">Nur noch 2 Plätze verfügbar</p>
  </div>
</div>
```

### Fehler-Toast
```html
<div class="flex items-center gap-3 bg-white border-l-4 border-coral rounded-lg shadow-large p-4 max-w-sm">
  <div class="flex-shrink-0">
    <svg class="w-5 h-5 text-coral" fill="currentColor" viewBox="0 0 20 20">
      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
    </svg>
  </div>
  <div class="flex-1">
    <p class="text-sm font-medium text-deep-gray">Buchung fehlgeschlagen</p>
    <p class="text-xs text-charcoal">Kurs ist bereits ausgebucht</p>
  </div>
</div>
```

## Forms

### Input-Felder
```html
<div class="space-y-2">
  <label class="block text-sm font-medium text-deep-gray">E-Mail-Adresse</label>
  <input 
    type="email" 
    class="w-full px-4 py-3 border border-slate rounded-xl focus:outline-none focus:ring-2 focus:ring-ocean/20 focus:border-ocean transition-all duration-200"
    placeholder="name@beispiel.de"
  >
</div>
```

### Select-Felder
```html
<div class="space-y-2">
  <label class="block text-sm font-medium text-deep-gray">Kursauswahl</label>
  <select class="w-full px-4 py-3 border border-slate rounded-xl focus:outline-none focus:ring-2 focus:ring-ocean/20 focus:border-ocean transition-all duration-200">
    <option>Wähle einen Kurs...</option>
    <option>Yoga Flow - Mo 18:00</option>
    <option>Pilates Core - Di 19:00</option>
  </select>
</div>
```

### Toggle-Switch
```html
<label class="flex items-center gap-3 cursor-pointer">
  <span class="text-sm font-medium text-deep-gray">E-Mail-Benachrichtigungen</span>
  <div class="relative">
    <input type="checkbox" class="sr-only peer" checked>
    <div class="w-11 h-6 bg-slate rounded-full peer peer-checked:bg-emerald transition-all duration-300"></div>
    <div class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full transition-all duration-300 peer-checked:translate-x-5 shadow-soft"></div>
  </div>
</label>
```

## Layout-System

### Navigation (Glassmorphism)
```html
<nav class="sticky top-0 z-50 bg-white/70 backdrop-blur-glass border-b border-silver/50">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between items-center h-16">
      <div class="text-xl font-bold text-ink-black">KursHub</div>
      <div class="hidden md:flex space-x-8">
        <a href="#" class="text-charcoal hover:text-ocean transition-colors">Kurse</a>
        <a href="#" class="text-charcoal hover:text-ocean transition-colors">Meine Buchungen</a>
        <a href="#" class="text-charcoal hover:text-ocean transition-colors">Kontakt</a>
      </div>
    </div>
  </div>
</nav>
```

### Dashboard-Layout
```html
<div class="flex min-h-screen bg-mist">
  <!-- Sidebar -->
  <aside class="w-64 bg-white/60 backdrop-blur-glass border-r border-silver/50 p-6">
    <nav class="space-y-2">
      <a href="#" class="flex items-center gap-3 px-3 py-2 rounded-lg bg-ocean text-white">
        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
          <path d="M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z"/>
        </svg>
        Übersicht
      </a>
      <a href="#" class="flex items-center gap-3 px-3 py-2 rounded-lg text-charcoal hover:bg-pearl transition-colors">
        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd"/>
        </svg>
        Kurse
      </a>
    </nav>
  </aside>
  
  <!-- Main Content -->
  <main class="flex-1 p-8">
    <!-- Content here -->
  </main>
</div>
```

## Responsive Design

### Breakpoints (Tailwind Standard)
- **sm:** 640px (Tablet Portrait)
- **md:** 768px (Tablet Landscape)
- **lg:** 1024px (Desktop)
- **xl:** 1280px (Large Desktop)

### Mobile-Optimierte Komponenten
```html
<!-- Responsive Card Grid -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  <!-- Cards -->
</div>

<!-- Responsive Dashboard -->
<div class="lg:grid lg:grid-cols-4 lg:gap-8 space-y-8 lg:space-y-0">
  <aside class="lg:col-span-1"><!-- Sidebar --></aside>
  <main class="lg:col-span-3"><!-- Content --></main>
</div>
```

## Iconografie

### SVG-Icon-System
Wir verwenden Heroicons (MIT-lizenziert) für konsistente Iconografie:

```html
<!-- Check Icon (Erfolg) -->
<svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
</svg>

<!-- Warning Icon -->
<svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
  <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
</svg>

<!-- X Icon (Fehler/Schließen) -->
<svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
  <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
</svg>
```

## Animation & Transitions

### Standard-Transitions
```html
<!-- Hover-Effekte -->
<div class="transition-all duration-200 hover:-translate-y-1 hover:shadow-large">

<!-- Loading-States -->
<div class="animate-pulse bg-pearl rounded-lg h-4 w-24">

<!-- Fade-In -->
<div class="animate-fade-in opacity-0" style="animation: fade-in 0.3s ease-out forwards;">
```

### Custom Animations
```css
@keyframes fade-in {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes slide-up {
  from { transform: translateY(100%); }
  to { transform: translateY(0); }
}
```

## Accessibility

### WCAG 2.1 Compliance
- **Kontrast:** Mindestens 4.5:1 für normalen Text
- **Touch-Targets:** Mindestens 44px für interaktive Elemente
- **Fokus-Indikatoren:** Deutlich sichtbare Focus-Ringe
- **Screen-Reader:** Semantische HTML-Struktur

### Focus-Management
```html
<!-- Custom Focus-Ring -->
<button class="focus:outline-none focus:ring-2 focus:ring-ocean/20 focus:ring-offset-2">
  <!-- Button Content -->
</button>
```

## Dark Mode (Future)

### Vorbereitung für Dark Mode
```html
<!-- Theme-aware Klassen -->
<div class="bg-white dark:bg-deep-gray text-ink-black dark:text-cloud">
  <!-- Content -->
</div>
```

Diese Design-System-Dokumentation bildet die Grundlage für alle UI-Komponenten der Kursplattform und gewährleistet ein konsistentes, professionelles und zugängliches Benutzererlebnis.