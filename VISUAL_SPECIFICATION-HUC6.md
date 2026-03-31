# ERG V3 — Visual Specification for Replication

**Purpose**: This document provides exact implementation details extracted from the working ERG V3 prototype. Use this as the source of truth when applying this visual system to other projects.

---

## 1. Technology Stack

```json
{
  "framework": "Next.js 14 App Router",
  "styling": "Tailwind CSS (utility-first)",
  "language": "TypeScript + React",
  "darkMode": "class-based (toggle via <html> class)",
  "fontLoading": "next/font/google"
}
```

**next.config.mjs**:
```js
output: "export"  // Static export
```

**tailwind.config.ts**:
```ts
darkMode: "class"
fontFamily: {
  sans: ["var(--font-plus-jakarta-sans)", "system-ui", "sans-serif"]
}
```

---

## 2. Typography System

### Font Family
**Plus Jakarta Sans** — Geometric sans-serif
- Weights: `300` (light), `400` (normal), `600` (semibold)
- **Never use `700` (bold)** — `600` is the maximum weight

```tsx
import { Plus_Jakarta_Sans } from "next/font/google";

const plusJakartaSans = Plus_Jakarta_Sans({
  subsets: ["latin"],
  weight: ["300", "400", "600"],
  variable: "--font-plus-jakarta-sans",
  display: "swap",
});

// Apply to body
<body className="font-sans antialiased">
```

### Type Scale (Actual Implementation)

All sizes use arbitrary values `text-[Npx]`, not semantic classes:

| Element | Size | Weight | Line Height | Letter Spacing | Example |
|---------|------|--------|-------------|----------------|---------|
| **Hero headline** | `text-[2.5rem]` (40px) | `font-light` (300) | `leading-[1.15]` | `tracking-[-0.02em]` | "Risks detected that may need disclosure." |
| **Index hero** | `text-[2rem]` (32px) | `font-light` | `leading-[1.2]` | `tracking-[-0.02em]` | "Prototype Index" |
| **Modal title** | `text-[22px]` | `font-semibold` (600) | default | none | "Initializing agents" |
| **Card title** | `text-[16px]` | `font-semibold` (600) | `leading-[1.35]` | none | Risk card names |
| **Step title** | `text-[14px]` | `font-semibold` | default | none | Index step links |
| **Button text** | `text-[14px]` | `font-normal` (400) | default | none | Primary CTAs |
| **Body text** | `text-[13px]` | `font-normal` | `leading-relaxed` | none | Descriptions, paragraphs |
| **Secondary/meta** | `text-[12px]` | `font-normal` | default | none | Timestamps, meta info |
| **Badge/pill** | `text-[11px]` | `font-semibold` | default | none | Status badges |
| **Section label** | `text-[11px]` | `font-semibold` | default | `uppercase tracking-wide` | "DETECTED RISKS" |
| **Micro label** | `text-[10px]` | `font-semibold` | default | `uppercase tracking-[0.18em]` | "AI-SUGGESTED OWNER" |
| **Fallback** | `text-xs` (12px) | `font-semibold` | default | `tracking-tight` | Nav app name |

**Key principle**: Intentionally smaller than defaults. Dense, refined aesthetic.

---

## 3. Color System

### CSS Custom Properties (globals.css)

```css
:root {
  --background: #f0f0f1;   /* Warm off-white page background */
  --foreground: #171717;   /* Near-black text */
  --card: #f5f5f5;         /* Not used in favor of white */
  --border: #e5e5e5;       /* Not used in favor of transparent black */
  --muted: #737373;        /* Not used in favor of slate-400 */
}

.dark {
  --background: #09090b;   /* zinc-950 */
  --foreground: #fafafa;   /* zinc-50 */
  --card: #18181b;         /* zinc-900 */
  --border: #27272a;       /* zinc-800 */
  --muted: #a1a1aa;        /* zinc-400 */
}
```

### Actual Color Usage (from component code)

#### Page Structure
```tsx
// Page background
bg-[#f0f0f1] dark:bg-zinc-950

// Cards/panels
bg-white dark:bg-zinc-900

// Inset areas (footer strips, side panels)
bg-slate-50/50 dark:bg-zinc-800/30
bg-slate-50 dark:bg-zinc-800
```

#### Borders
```tsx
// Standard card borders
border-black/[0.09] dark:border-zinc-700

// Subtle dividers
border-black/[0.05] dark:border-zinc-800

// Hover state
hover:border-slate-200 dark:hover:border-zinc-600

// Status-specific borders
border-red-200 dark:border-red-800          // Critical
border-emerald-200 dark:border-emerald-800  // Success
border-amber-200 dark:border-amber-800      // Warning
border-blue-200/60 dark:border-blue-900/30  // Info (Moody's)
```

#### Text Colors
```tsx
// Primary text
text-slate-800 dark:text-zinc-100

// Secondary text
text-slate-500 dark:text-zinc-400

// Muted/meta text
text-slate-400 dark:text-zinc-500

// Very muted (disabled)
text-slate-300 dark:text-zinc-600

// Hover states
hover:text-slate-600 dark:hover:text-zinc-300
```

#### Semantic Status Colors

**Critical/High severity**:
```tsx
// Badge
bg-red-50 border-red-200 text-red-700
dark:bg-red-950/40 dark:border-red-800 dark:text-red-400

// Glow gradient (inline style)
rgba(239,68,68,0.04)  // light mode
```

**High/Warning**:
```tsx
// Badge
bg-amber-50 border-amber-200 text-amber-700
dark:bg-amber-950/40 dark:border-amber-800 dark:text-amber-400

// Active step indicator
bg-amber-400 dark:bg-amber-500
text-amber-600 dark:text-amber-400
ring-4 ring-amber-100 dark:ring-amber-900/30
```

**Success/Done**:
```tsx
// Badge
bg-emerald-50 border-emerald-200 text-emerald-700
dark:bg-emerald-950/40 dark:border-emerald-800 dark:text-emerald-400

// Status pill
bg-emerald-500 (dot)
text-emerald-700 dark:text-emerald-400

// Glow gradient
rgba(16,185,129,0.05)  // light mode
```

**Info (Moody's Intelligence)**:
```tsx
// Inset card
border-blue-200/60 dark:border-blue-900/30
bg-blue-50/40 dark:bg-blue-950/10
text-blue-500/70 dark:text-blue-400/60  // Label
text-slate-600 dark:text-zinc-400        // Body
```

**Neutral/Low**:
```tsx
// Badge
bg-slate-100 border-slate-300 text-slate-600
dark:bg-zinc-800 dark:border-zinc-600 dark:text-zinc-400
```

---

## 4. Spacing System

### Container & Layout
```tsx
// Page wrapper
<div className="min-h-screen bg-[#f0f0f1] dark:bg-zinc-950">

// Content container (most pages)
<div className="mx-auto w-full max-w-6xl px-6 pb-6 space-y-6">

// Hero container (centered, narrower)
<div className="relative mx-auto max-w-2xl px-6 pt-12 pb-10 text-center">

// Index page container
<div className="mx-auto max-w-3xl px-6 pb-10 space-y-6">
```

**Key values**:
- Max width: `max-w-6xl` (1152px) for dashboard content
- Max width: `max-w-2xl` (672px) for hero sections
- Max width: `max-w-3xl` (768px) for index/narrow pages
- Horizontal padding: `px-6` (24px)
- Section spacing: `space-y-6` (24px between sections)

### Card Padding

**Standard card**:
```tsx
p-[22px_24px]  // 22px top/bottom, 24px left/right
```

**Compact card**:
```tsx
p-[18px_20px]  // Pick up where you left off cards
```

**Modal padding**:
```tsx
// Body
p-6  // 24px all sides

// Footer
px-6 py-4  // 24px horizontal, 16px vertical
```

**Nav bar**:
```tsx
px-6 py-3.5  // 24px horizontal, 14px vertical
```

**Side panel (owner section)**:
```tsx
p-5  // 20px all sides
```

### Gaps Between Elements

```tsx
// Section heading to content
mb-3          // 12px
mb-4          // 16px (when CTA is present)

// Cards in a list
space-y-3     // 12px between cards

// Horizontal button group
gap-1.5       // 6px between Assign/Skip buttons
gap-2         // 8px between elements
gap-3         // 12px in nav, modals
gap-4         // 16px in larger layouts

// Metric boxes
gap-3         // 12px between metric boxes

// Pick up cards grid
grid grid-cols-2 gap-3
```

---

## 5. Border Radius System

**Actual values from code**:

| Element | Class | Value |
|---------|-------|-------|
| **Action cards** | `rounded-[20px]` | 20px (custom) |
| **Modals** | `rounded-3xl` | 24px |
| **Modal items** | `rounded-xl` | 12px |
| **Buttons (primary)** | `rounded-xl` | 12px |
| **Buttons (small)** | `rounded-lg` | 8px |
| **Inset cards** | `rounded-xl` | 12px |
| **Floating prompt** | `rounded-2xl` | 16px |
| **Ticker strip** | `rounded-2xl` | 16px |
| **Badges/pills** | `rounded-full` | 9999px |
| **Icon containers** | `rounded-lg` | 8px |
| **Avatar images** | `rounded-full` | 9999px |
| **Metric boxes** | `rounded-xl` | 12px |
| **Status indicators** | `rounded-full` | 9999px (dots/pills) |

---

## 6. Component Patterns

### Nav Bar

```tsx
<nav className="border-b border-slate-200 dark:border-zinc-800 bg-white dark:bg-zinc-900">
  <div className="mx-auto flex w-full max-w-6xl items-center justify-between px-6 py-3.5">
    {/* Left: Logo + name */}
    <div className="flex items-center gap-2.5">
      <DiligentLogoFull />
      <span className="text-xs font-semibold tracking-tight text-slate-800 dark:text-zinc-100">
        GRC Command Center
      </span>
    </div>
    {/* Right: Actions + user */}
    <div className="flex items-center gap-3">
      {/* Icon buttons */}
      <button className="flex h-8 w-8 items-center justify-center rounded-lg border border-slate-200 dark:border-zinc-700 bg-slate-50 dark:bg-zinc-800 text-slate-500 dark:text-zinc-400 hover:bg-slate-100 dark:hover:bg-zinc-700 transition-colors">
        {/* Icon SVG */}
      </button>
      {/* Divider */}
      <div className="h-5 w-px bg-slate-200 dark:bg-zinc-700" />
      {/* Avatar + info */}
    </div>
  </div>
</nav>
```

### Hero Banner (Open Layout)

```tsx
<div className="relative overflow-hidden">
  {/* Radial glow overlay */}
  <div
    className="absolute inset-0 pointer-events-none"
    style={{ background: "radial-gradient(ellipse 90% 100% at 50% 0%, rgba(16,185,129,0.05) 0%, transparent 100%)" }}
  />

  {/* Content */}
  <div className="relative mx-auto max-w-2xl px-6 pt-12 pb-10 text-center">
    {/* Status pill */}
    <div className="inline-flex items-center gap-2 rounded-full border border-emerald-200 dark:border-emerald-800 bg-white dark:bg-zinc-900 px-4 py-1.5 mb-6">
      <span className="w-2 h-2 rounded-full bg-emerald-500" />
      <span className="text-[13px] font-semibold text-emerald-700 dark:text-emerald-400">
        Risk Owners Notified
      </span>
    </div>

    {/* Headline */}
    <h1 className="text-[2.5rem] font-light tracking-[-0.02em] text-slate-800 dark:text-zinc-100 leading-[1.15] mb-4">
      All owners notified — assessments underway.
    </h1>

    {/* Subtitle */}
    <p className="text-[13px] text-slate-500 dark:text-zinc-400 leading-relaxed max-w-xl mx-auto">
      Description text goes here.
    </p>

    {/* Metric boxes */}
    <div className="flex items-center justify-center gap-3 mt-8">
      <div className="w-28 h-20 rounded-xl border border-black/[0.09] dark:border-zinc-700 bg-white dark:bg-zinc-900 flex flex-col items-center justify-center">
        <span className="text-[22px] font-semibold text-slate-800 dark:text-zinc-100">3</span>
        <span className="text-[11px] text-slate-400 dark:text-zinc-500">Risks Assigned</span>
      </div>
    </div>
  </div>
</div>
```

**Glow colors by state**:
- Success/calm: `rgba(16,185,129,0.05)`
- Warning/busy: `rgba(239,68,68,0.04)` or amber variant
- Critical: `rgba(239,68,68,0.04)` with higher opacity

### Action Card (Risk Card)

```tsx
<div
  className="suggestion-card rounded-[20px] border border-black/[0.09] dark:border-zinc-700 bg-white dark:bg-zinc-900 overflow-hidden transition-all duration-[250ms] ease-out hover:border-slate-200 dark:hover:border-zinc-600 hover:shadow-[0_8px_28px_rgba(0,0,0,0.06)] [will-change:transform] [backface-visibility:hidden]"
  style={{ animationDelay: `${i * 120}ms` }}
>
  <div className="flex">
    {/* Left: Risk detail */}
    <div className="flex-1 min-w-0 p-[22px_24px]">
      {/* Badge + source */}
      <div className="flex items-center gap-2 mb-1.5">
        <SeverityBadge severity="Critical" />
        <span className="text-[11px] text-slate-400 dark:text-zinc-500">Risk Intelligence</span>
      </div>

      {/* Title */}
      <p className="text-[16px] font-semibold leading-[1.35] text-slate-800 dark:text-zinc-100">
        Taiwan Strait Geopolitical Tensions
      </p>

      {/* Description */}
      <p className="text-[13px] text-slate-500 dark:text-zinc-400 leading-relaxed mt-1">
        Escalating tensions could disrupt semiconductor supply chain.
      </p>

      {/* Moody's Intelligence inset */}
      <div className="mt-3 rounded-xl border border-blue-200/60 dark:border-blue-900/30 bg-blue-50/40 dark:bg-blue-950/10 px-3.5 py-2.5">
        <p className="text-[10px] font-semibold uppercase tracking-[0.12em] text-blue-500/70 dark:text-blue-400/60 mb-0.5">
          Moody's Intelligence
        </p>
        <p className="text-[12px] text-slate-600 dark:text-zinc-400 leading-relaxed">
          Sector stress index 78/100. 3 of 5 key suppliers on negative credit watch.
        </p>
      </div>
    </div>

    {/* Right: Suggested owner panel */}
    <div className="flex-shrink-0 w-[200px] border-l border-black/[0.05] dark:border-zinc-800 bg-slate-50/50 dark:bg-zinc-800/30 p-5 flex flex-col items-center justify-center text-center">
      <p className="text-[10px] font-semibold uppercase tracking-[0.12em] text-slate-400 dark:text-zinc-500 mb-3">
        AI-Suggested Owner
      </p>
      <img src={avatarUrl} className="h-12 w-12 rounded-full object-cover mb-2" />
      <p className="text-[13px] font-semibold text-slate-800 dark:text-zinc-100">Diana Reyes</p>
      <p className="text-[11px] text-slate-400 dark:text-zinc-500 mb-3">VP, Supply Chain</p>

      {/* Button group */}
      <div className="flex items-center gap-1.5 w-full">
        <button className="flex-1 text-[11px] font-semibold text-white dark:text-zinc-900 bg-slate-800 dark:bg-zinc-100 rounded-lg py-1.5 hover:bg-slate-900 dark:hover:bg-white transition-colors">
          Assign
        </button>
        <button className="flex-1 text-[11px] font-semibold text-slate-400 dark:text-zinc-500 bg-white dark:bg-zinc-800 border border-black/[0.09] dark:border-zinc-700 rounded-lg py-1.5 hover:text-slate-600 dark:hover:text-zinc-300 hover:border-slate-300 dark:hover:border-zinc-600 transition-colors">
          Skip
        </button>
      </div>
    </div>
  </div>
</div>
```

### Severity Badge

```tsx
function SeverityBadge({ severity }: { severity: "Critical" | "High" }) {
  const classes = severity === "Critical"
    ? "bg-red-50 border-red-200 text-red-700 dark:bg-red-950/40 dark:border-red-800 dark:text-red-400"
    : "bg-amber-50 border-amber-200 text-amber-700 dark:bg-amber-950/40 dark:border-amber-800 dark:text-amber-400";

  return (
    <span className={cn("inline-flex items-center rounded-full border px-2.5 py-0.5 text-[11px] font-semibold", classes)}>
      {severity}
    </span>
  );
}
```

### Button Styles

**Primary CTA**:
```tsx
className="flex-1 text-[14px] font-normal bg-slate-800 dark:bg-zinc-100 text-white dark:text-zinc-900 rounded-xl py-[11px] px-4 hover:bg-slate-900 dark:hover:bg-white active:bg-slate-950 transition-colors"
```

**Secondary/Outline**:
```tsx
className="text-[13px] font-normal text-slate-500 dark:text-zinc-400 bg-white dark:bg-zinc-800 border border-black/[0.09] dark:border-zinc-700 rounded-xl py-[7px] px-3 hover:bg-slate-50 dark:hover:bg-zinc-700 hover:border-slate-200 dark:hover:border-zinc-600 transition-colors"
```

**Small button (in owner panel)**:
```tsx
className="flex-1 text-[11px] font-semibold text-white dark:text-zinc-900 bg-slate-800 dark:bg-zinc-100 rounded-lg py-1.5 hover:bg-slate-900 dark:hover:bg-white transition-colors"
```

**Icon button (nav)**:
```tsx
className="flex h-8 w-8 items-center justify-center rounded-lg border border-slate-200 dark:border-zinc-700 bg-slate-50 dark:bg-zinc-800 text-slate-500 dark:text-zinc-400 hover:bg-slate-100 dark:hover:bg-zinc-700 transition-colors"
```

### Workflow Stepper

```tsx
<div className="flex items-center justify-center">
  {WORKFLOW_STAGES.map((stage, idx) => (
    <React.Fragment key={stage.id}>
      {/* Circle */}
      <div className="flex flex-col items-center gap-1.5 min-w-0">
        <div className={cn(
          "flex h-8 w-8 items-center justify-center rounded-full border-2 transition-all",
          stage.status === "completed" && "bg-emerald-500 border-emerald-500",
          stage.status === "current" && "bg-white dark:bg-zinc-900 border-amber-400 dark:border-amber-500 ring-4 ring-amber-100 dark:ring-amber-900/30",
          stage.status === "pending" && "bg-white dark:bg-zinc-900 border-slate-200 dark:border-zinc-700",
        )}>
          {stage.status === "completed" && (
            <svg className="w-3.5 h-3.5 text-white" viewBox="0 0 12 12" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M2 6l3 3 5-5"/>
            </svg>
          )}
          {stage.status === "current" && (
            <span className="relative flex h-2.5 w-2.5">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-60" />
              <span className="relative inline-flex rounded-full h-2.5 w-2.5 bg-amber-500" />
            </span>
          )}
          {stage.status === "pending" && (
            <span className="w-2 h-2 rounded-full bg-slate-200 dark:bg-zinc-700" />
          )}
        </div>

        {/* Label */}
        <span className={cn(
          "text-[11px] font-semibold whitespace-nowrap",
          stage.status === "completed" && "text-emerald-600 dark:text-emerald-400",
          stage.status === "current" && "text-amber-600 dark:text-amber-400",
          stage.status === "pending" && "text-slate-400 dark:text-zinc-500",
        )}>
          {stage.label}
        </span>
      </div>

      {/* Connector line */}
      {idx < WORKFLOW_STAGES.length - 1 && (
        <div className={cn(
          "flex-1 h-0.5 rounded-full mx-1 mt-[-18px]",
          stage.status === "completed" ? "bg-emerald-400 dark:bg-emerald-600" : "bg-slate-200 dark:bg-zinc-700",
        )} />
      )}
    </React.Fragment>
  ))}
</div>
```

### Floating Prompt Bar

```tsx
<div style={{ position: "fixed", bottom: 0, left: 0, right: 0, zIndex: 100, pointerEvents: "none" }}>
  <div style={{ maxWidth: 768, margin: "0 auto", padding: "0 24px 20px", pointerEvents: "auto" }}>
    <div className="rounded-2xl border border-black/[0.09] dark:border-zinc-700 bg-white/95 dark:bg-zinc-900/95 backdrop-blur-xl p-2 shadow-[0_-4px_32px_rgba(0,0,0,0.10)]">
      <div className="flex items-center gap-3">
        <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-50 dark:bg-zinc-800 border border-black/[0.05] dark:border-zinc-700 flex-shrink-0 p-1.5">
          <DiligentLogoFull />
        </div>
        <input
          type="text"
          placeholder="Ask about risks, assign owners, draft disclosures…"
          className="flex-1 bg-transparent text-[14px] text-slate-800 dark:text-zinc-100 placeholder-slate-400 dark:placeholder-zinc-500 focus:outline-none"
        />
        <button className="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-800 dark:bg-zinc-100 text-white dark:text-zinc-900 hover:bg-slate-900 dark:hover:bg-white active:bg-slate-950 transition-colors flex-shrink-0">
          {/* Send icon */}
        </button>
      </div>
    </div>
  </div>
</div>
```

**Important**: Use inline `style` with `position: fixed` for viewport anchoring, not Tailwind's `fixed` class (can fail in flex/transform contexts).

### Gradient Divider

```tsx
<div className="h-px bg-gradient-to-r from-transparent via-slate-300 dark:via-zinc-700 to-transparent" />
```

### Section Header

```tsx
<h3 className="text-[11px] font-semibold text-slate-800 dark:text-zinc-100 uppercase tracking-wide mb-3">
  Detected risks
</h3>
<p className="text-[13px] text-slate-500 dark:text-zinc-400 mb-3">
  3 emerging risks found across 5 monitoring agents.
</p>
```

---

## 7. Animations & Transitions

### Keyframe Animations (globals.css)

```css
/* Card entrance */
@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}
.suggestion-card {
  animation: fadeSlideUp 0.5s ease-out both;
}

/* Card glow breathing */
@keyframes glowBreath {
  0%, 100% { opacity: 0.5; }
  50%       { opacity: 1; }
}
.suggestion-card-glow {
  animation: glowBreath 3.5s ease-in-out infinite;
}

/* Modal entrance */
@keyframes confirmModalIn {
  from { opacity: 0; transform: scale(0.96) translateY(12px); }
  to   { opacity: 1; transform: scale(1)    translateY(0); }
}

/* Slide in from right */
@keyframes slide-in-right {
  from { transform: translateX(100%); opacity: 0; }
  to   { transform: translateX(0); opacity: 1; }
}
```

### Staggered Card Entrance

```tsx
style={{ animationDelay: `${i * 120}ms` }}
```

Cards appear 120ms apart.

### Transition Classes

```tsx
// Color transitions
transition-colors  // Default 150ms

// Multi-property (cards)
transition-all duration-[250ms] ease-out

// Hover lift protection
[will-change:transform] [backface-visibility:hidden]
```

**Hover effect on cards**:
```tsx
hover:border-slate-200 dark:hover:border-zinc-600
hover:shadow-[0_8px_28px_rgba(0,0,0,0.06)]
hover:-translate-y-0.5
```

### Modal Animation (inline)

```tsx
style={{ animation: 'confirmModalIn 220ms cubic-bezier(0.22,1,0.36,1) both' }}
```

---

## 8. Icons

All icons are **inline SVG** — no icon library.

**Standard attributes**:
```tsx
viewBox="0 0 16 16"  // or "0 0 12 12" for small icons
fill="none"
stroke="currentColor"
strokeWidth="1.5"     // 2 for small icons, 2.5 for checkmarks
strokeLinecap="round"
strokeLinejoin="round"
```

**Sizing**: `w-3 h-3` (12px), `w-3.5 h-3.5` (14px), `w-4 h-4` (16px), `w-5 h-5` (20px)

**Checkmark (small)**:
```tsx
<svg className="w-3.5 h-3.5 text-white" viewBox="0 0 12 12" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
  <path d="M2 6l3 3 5-5"/>
</svg>
```

**Close/X**:
```tsx
<svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
  <path d="M4 4l8 8M12 4l-8 8" />
</svg>
```

**Spinner**:
```tsx
<div className="w-5 h-5 border-2 border-slate-400 dark:border-zinc-500 border-t-transparent rounded-full animate-spin" />
```

---

## 9. Dark Mode Implementation

### Activation
```tsx
// Apply to <html> element
<html className={theme === "dark" ? "dark" : ""}>
```

Every component uses `dark:` variants:

```tsx
// Text
text-slate-800 dark:text-zinc-100
text-slate-500 dark:text-zinc-400
text-slate-400 dark:text-zinc-500

// Backgrounds
bg-white dark:bg-zinc-900
bg-slate-50 dark:bg-zinc-800
bg-[#f0f0f1] dark:bg-zinc-950

// Borders
border-black/[0.09] dark:border-zinc-700
border-slate-200 dark:border-zinc-800

// Status colors (use lighter weights in dark mode)
text-red-700 dark:text-red-400
text-emerald-700 dark:text-emerald-400
bg-red-50 dark:bg-red-950/40
```

---

## 10. Scrollbar Styling

```css
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: transparent;
}

::-webkit-scrollbar-thumb {
  background: #d4d4d8;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #a1a1aa;
}

.dark ::-webkit-scrollbar-thumb {
  background: #3f3f46;
}

.dark ::-webkit-scrollbar-thumb:hover {
  background: #52525b;
}
```

---

## 11. Utility Function

Every page file defines:

```tsx
function cn(...classes: Array<string | false | null | undefined>) {
  return classes.filter(Boolean).join(" ");
}
```

Use for conditional classes:
```tsx
<div className={cn(
  "base-class",
  condition && "conditional-class",
  "another-class"
)} />
```

---

## 12. Quick Reference: Common Patterns

### Page Structure
```tsx
<div className="min-h-screen bg-[#f0f0f1] dark:bg-zinc-950">
  <ProtoPanel description="..." stateToggle={false} />
  <nav>{/* Nav bar */}</nav>
  <div>{/* Hero section — no container */}</div>
  <div className="mx-auto w-full max-w-6xl px-6 pb-6 space-y-6">
    {/* Content cards */}
  </div>
</div>
```

### Standard Card
```tsx
<div className="rounded-[20px] border border-black/[0.09] dark:border-zinc-700 bg-white dark:bg-zinc-900 p-[22px_24px]">
  {/* Content */}
</div>
```

### Section
```tsx
<div>
  <h3 className="text-[11px] font-semibold text-slate-800 dark:text-zinc-100 uppercase tracking-wide mb-3">
    Section Title
  </h3>
  <div className="space-y-3">
    {/* Cards */}
  </div>
</div>
```

---

## 13. Key Design Principles

1. **Exact sizing**: Always use `text-[Npx]` arbitrary values, not semantic classes
2. **Transparent borders**: Use `border-black/[0.09]` not solid colors (adapts naturally)
3. **Dense but spacious**: Small type (`text-[13px]` body), but generous card padding (`p-[22px_24px]`)
4. **No bold**: Maximum weight is `font-semibold` (600), use `font-light` (300) for large headlines
5. **Radial glows**: Use inline `style` with radial gradients for top glows, not box-shadows
6. **Status colors**: Always provide dark variants with lighter tones (`-400` level vs `-700`)
7. **Hover lifts**: Cards lift with `hover:-translate-y-0.5`, always add `[will-change:transform]`
8. **Staggered reveals**: Delay cards by `i * 120ms`
9. **Fixed positioning**: Use inline `style={{ position: "fixed" }}` not Tailwind `fixed` for viewport anchoring
10. **Every visual element needs `dark:` variants** — no exceptions

---

## 14. File Checklist for Replication

When setting up this visual system in a new project:

### Required files:
- [ ] `app/layout.tsx` — Font loading (Plus Jakarta Sans 300/400/600)
- [ ] `app/globals.css` — CSS variables + animations
- [ ] `tailwind.config.ts` — darkMode: "class", font family
- [ ] `next.config.mjs` — output: "export" (if static)

### Required patterns:
- [ ] Page wrapper: `min-h-screen bg-[#f0f0f1] dark:bg-zinc-950`
- [ ] Content container: `mx-auto w-full max-w-6xl px-6 pb-6 space-y-6`
- [ ] Hero section: `max-w-2xl px-6 pt-12 pb-10 text-center` with radial glow
- [ ] Cards: `rounded-[20px]` with `border-black/[0.09]` and `p-[22px_24px]`
- [ ] Buttons: Primary uses `text-[14px] font-normal`, not bold
- [ ] Icons: All inline SVG with `stroke="currentColor"`
- [ ] Dark mode: Every color class has a `dark:` variant

### Copy directly:
- ProtoPanel component (optional)
- `cn()` utility function
- Scrollbar styling
- Animation keyframes
- Status badge component pattern

---

**End of specification. This document captures the exact implementation from ERG V3 as of 2026-03-25.**
