# WheelOne — Design System

> **Brand voice:** Editorial Auto | Precision Intelligence
> A high-end, editorial magazine aesthetic fused with precision engineering sensibility.

---

## ⚠️ CRITICAL: What WheelOne Actually Does

**WheelOne is a wheel visualisation tool for car owners.** Before generating any UI, read this carefully.

The app has exactly **three types of records**:

1. **Cars (`Automobiliai`)** — a user's personal vehicle (e.g. BMW 540, Tesla Model S). Has a photo, VIN, year, odometer reading.
2. **Rims (`Ratlankiai`)** — a set of aftermarket wheels/rims (e.g. BBS RS, Vossen HF-2). Has a photo, size, bolt pattern.
3. **Visualizations (`Vizualizacijos`)** — an **AI-generated image** showing what a specific car would look like with a specific set of rims fitted to it. It is a **composite render of a car + rims together**. It is NOT a person. It is NOT a profile. It is NOT a user account. It is a rendered automotive image.

### What a Visualization IS:
- A digital render / photomontage of **one car** wearing **one set of rims**
- The output is a single image showing the vehicle with the selected wheels applied
- Think of it like a "virtual try-on" — you pick your car, you pick the rims, the system generates what it would look like
- Status can be: `PARUOŠTA` (Ready/Done) or `ARCHYVUOTA` (Archived)
- Each visualization belongs to **exactly one car** and references **exactly one rim set**

### ⚠️ CRITICAL — Sample data for Visualizations:
All three example visualizations on the Vizualizacijos index page belong to the **same car: BMW 540**. Do NOT invent multiple different cars. Do NOT show different VINs per card. The meta row shows the **visualization name** and **status**, NOT the car's VIN. Use this exact sample data:

| Name | Hero image | Badge | Car | Rim | Status |
|---|---|---|---|---|---|
| SUNSET RENDER | Sunset sky backdrop with car | PARUOŠTA | BMW 540 | M-Performance V1 | PARUOŠTA |
| TRACK EDITION | Car on a racetrack | ARCHYVUOTA | BMW 540 | BBS Super RS | ARCHYVUOTA |
| CITY DRIVE | City skyline backdrop with car | PARUOŠTA | BMW 540 | Vossen HF-2 | PARUOŠTA |

The card meta row shows: **Car name** (left) · **Status badge** (right). No VINs on visualization cards.

### What a Visualization is NOT:
- ❌ NOT a person or user profile
- ❌ NOT a photo of a person
- ❌ NOT a social media post
- ❌ NOT a gallery of people
- ❌ NOT anything involving human figures
- ❌ NOT multiple different cars — all example visualizations belong to BMW 540
- ❌ NOT showing a VIN number on the card

### Example visualization card (correct):
```
[Image: AI render of a BMW 540 with BBS RS rims]
SUNSET RENDER          ● AKTYVUS
Car: BMW 540
Rim: M-Performance V1
Created: 2024-03-15
[Edit] [Delete]
```

---

## Visual Identity

WheelOne uses a light, authoritative editorial style. The UI feels like a premium automotive magazine brought to the web — bold typography, glass-effect cards, crisp gradients, and sharp contrast between content and background.

**Core aesthetic principles:**

- Glass morphism for card surfaces (frosted, semi-transparent with backdrop blur)
- Bold, black-weight headlines in uppercase for all titles
- Gradient CTAs — deep blue to lighter blue, with lift-on-hover
- Normal spacing inside cards (`p-6` or similar based on normal spacing)
- Hero images that scale on hover (`group-hover:scale-105`)
- Status indicators use color (green for active, neutral for other states)

---

## Color Tokens

These are the custom Tailwind tokens used throughout the app. They must be defined in `tailwind.config.js`.

| Token | Role |
|---|---|
| `primary` | Main brand blue — used for buttons, links, active states |
| `primary-container` | Lighter blue — used as gradient end on CTAs |
| `on-primary` | Text on primary backgrounds (white) |
| `surface-container` | Card interior background |
| `surface-container-low` | Stat block background inside cards |
| `surface-container-lowest` | Badge background (semi-transparent) |
| `on-surface` | Main body text |
| `on-surface-variant` | Secondary / muted text |
| `outline` | Icon color in placeholder states |
| `outline-variant` | Separator dots between meta items |
| `tertiary` | Destructive / delete button color |
| `on-tertiary` | Text on tertiary backgrounds |

**Hardcoded gradient (CTAs):**

```
background: linear-gradient(135deg, #0053da 0%, #346df5 100%)
```

Used on all primary action buttons and "Add" links.

---

## Typography

Three font families are used. Load them via `<link>` tags in the layout.

| Role | Font | Tailwind class | Usage |
|---|---|---|---|
| Headlines | Manrope | `font-headline` | Page titles, card titles, button labels |
| Body | Inter | `font-body` | Descriptions, meta text, paragraph copy |
| Labels | Manrope | `font-label` | Stat labels, badges, uppercase trackers |

**Typographic patterns:**

- Page headings: `font-[Manrope] text-3xl font-black tracking-tight`
- Card titles: `font-headline text-4xl font-black tracking-tighter` — always `.toUpperCase()`
- Stat labels: `font-label text-[10px] uppercase tracking-widest font-bold`
- Body copy: `text-sm text-slate-500 font-[Inter]`

---

## Icons

Material Symbols Outlined. Load via Google Fonts CDN.

```html
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
```

Used with the class `material-symbols-outlined`. Fill variant activated via `font-variation-settings:'FILL' 1` (e.g. on active status icons).

Common icons in use:

| Icon name | Context |
|---|---|
| `directions_car` | Car placeholder / empty states |
| `settings` | Rim placeholder / empty states |
| `image` | Visualization placeholder (rendered car image) |
| `fingerprint` | VIN / ID meta field |
| `check_circle` | Active status (filled, green) |
| `info` | Inactive / other status |
| `edit` | Edit action button |
| `delete` | Delete action button |
| `add` | New record button |

---

## Components

### `RecordCardComponent`

The primary UI building block. An editorial-style glass card with hero image, badge, title, meta row, stats grid, and action buttons.

**Structure:**

```
┌─────────────────────────────┐
│ Hero Image (h-72)           │ ← scales on group hover
│ [Badge — top right]         │ ← rounded-full, glass blur
│ gradient overlay (bottom)   │
├─────────────────────────────┤
│ p-6                         │
│ TITLE (uppercase, 4xl)      │
│ VIN: xxxxxx · Status ✓      │ ← meta row
│                             │
│ ┌──────────┐ ┌──────────┐  │
│ │ Stat 1   │ │ Stat 2   │  │ ← 2-col grid, rounded-xl bg
│ └──────────┘ └──────────┘  │
│                             │
│ [Edit btn]   [Delete btn]   │ ← flex row, gradient / tertiary
└─────────────────────────────┘
```

**Props:**

| Prop | Type | Description |
|---|---|---|
| `title` | String | Card headline — auto-uppercased |
| `image` | ActiveStorage / URL | Hero image (optional) |
| `badge` | String | Top-right pill (tier, brand, status) |
| `subtitle_left` | String | Left meta label (e.g. "VIN") |
| `subtitle_left_value` | String | Left meta value |
| `subtitle_right` | String | Right meta value (e.g. status) |
| `subtitle_right_status` | Boolean | Render as green active indicator |
| `stats` | Array of `{label:, value:}` | 2-column stat grid |
| `edit_path` | Path | Edit button destination |
| `delete_path` | Path | Delete button destination (DELETE method, Turbo confirm) |
| `show_path` | Path | Makes title a link |
| `record` | AR object | Optional — for future slot content |

**CSS requirements** (must be in `application.css`):

```css
.glass-card {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.3);
}
```

**Status logic:** `subtitle_right` is treated as "active" if its value (downcased) is `"active"`, `"aktyvi"`, or `"aktyvus"` — shows filled green `check_circle` icon.

---

### `RecordCardController` (Stimulus)

Optional Stimulus controller that adds a quick-preview modal to any card.

Attach with `data-controller="record-card"` on the card container and `data-action="click->record-card#preview"` on the image area.

Values:
- `previewUrlValue` — optional link for full record
- `titleValue`, `subtitleValue`, `statusValue`, `imageUrlValue` — populate modal

The modal is created once in the DOM on first `connect()` and reused across all cards.

---

## Page Layout Patterns

### Index pages (Cars, Rims, Visualizations)

```
┌── Page header ──────────────────────────────────────────┐
│  [Page title — 3xl black]                               │
│  [Subtitle — team name]      [+ Add button — CTA]       │
└─────────────────────────────────────────────────────────┘

┌── Grid ─────────────────────────────────────────────────┐
│  grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6        │
│  RecordCardComponent × N                                │
└─────────────────────────────────────────────────────────┘

┌── Empty state ──────────────────────────────────────────┐
│  Centered, py-20, bg-white/60 backdrop-blur             │
│  Large icon (56px, slate-300)                           │
│  Bold message + muted description                       │
│  Inline CTA link                                        │
└─────────────────────────────────────────────────────────┘
```

**Add button style** (used on all index pages):

```erb
class: "inline-flex items-center gap-2 px-5 py-3 rounded-lg text-white font-[Manrope] font-bold text-sm tracking-tight shadow-lg shadow-blue-500/25 hover:shadow-xl hover:-translate-y-0.5 active:scale-95 transition-all duration-200",
style: "background: linear-gradient(135deg, #0053da 0%, #346df5 100%)"
```

---

## Three Core Resources

The app revolves around three record types, each with its own index page and `RecordCardComponent` mapping:

### Cars (`Automobiliai`)
A user's personal vehicle. Each car can have multiple visualizations generated for it.

Key fields: `make`, `model`, `year`, `vin`, `status`, `photo`, `odometer_km`, `last_serviced_at`, `tier`
Meta: VIN left / Status right
Stats: Last service date + odometer
Icon placeholder: `directions_car`
Hero image: a photo of the actual car

### Rims (`Ratlankiai`)
An aftermarket wheel/rim product. Rims are selected when creating a visualization.

Key fields: `name`, `code`/`sku`, `status`, `photo`, `size`, `bolt_pattern`, `brand`/`manufacturer`
Meta: Code left / Status right
Stats: Size (inches) + bolt pattern
Icon placeholder: `settings`
Hero image: a photo of the rim/wheel product

### Visualizations (`Vizualizacijos`)
An **AI-generated render** showing a specific car fitted with a specific set of rims. The hero image is the rendered composite — a photorealistic image of the car wearing those wheels.

Key fields: `name`, `status`, `result_image`/`image`, `car`, `rim`, `created_at`
Meta: Car name left / Status right
Stats: Rim name + creation date
Badge: Status (`PARUOŠTA` / `ARCHYVUOTA`)
Icon placeholder: `image`
Hero image: the AI-generated car+rim render (e.g. a BMW with BBS rims on a sunset backdrop)

**DO NOT** show people, faces, or human figures anywhere in the Visualizations section. Every image in this section is a car render.

---

## Interaction Patterns

| Pattern | Implementation |
|---|---|
| Card hover zoom | `group` + `group-hover:scale-105 transition-transform duration-700` on image |
| Button hover lift | `hover:shadow-xl hover:-translate-y-0.5 active:scale-95 transition-all duration-200` |
| Delete confirmation | Turbo: `data: { turbo_confirm: "..." }` |
| Destructive action | `button_to` with `method: :delete` |
| Quick preview modal | Stimulus `record-card` controller (optional) |

---

## Localisation

The UI is in **Lithuanian**. Common strings:

| English | Lithuanian |
|---|---|
| Cars | Automobiliai |
| Rims / Wheels | Ratlankiai |
| Visualizations | Vizualizacijos |
| Add car | Pridėti automobilį |
| Add rim | Pridėti ratlankį |
| Create visualization | Sukurti vizualizaciją |
| Edit | Redaguoti |
| Delete | Ištrinti |
| No records | [Resource name] nėra |
| Last service | Paskutinis servisas |
| Mileage | Rida |
| Code | Kodas |
| Size | Dydis |
| Bolt pattern | Tvirtinimas |
| Car | Automobilis |
| Created | Sukurta |

---

## Required Dependencies

| Dependency | Purpose |
|---|---|
| `ViewComponent` | `RecordCardComponent` |
| `Hotwire / Turbo` | Delete confirmations, page updates |
| `Stimulus` | `record-card` controller (quick-preview modal) |
| `Tailwind CSS` | All styling |
| `Material Symbols` | Icons (Google Fonts CDN) |
| `Manrope` | Headline font (Google Fonts CDN) |
| `Inter` | Body font (Google Fonts CDN) |
| `ActiveStorage` | Car/Rim/Visualization photo attachments |
