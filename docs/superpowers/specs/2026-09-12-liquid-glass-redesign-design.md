# Liquid Glass Redesign — Design Spec

Date: 2026-09-12
Branch: `claude/ui-redesign-liquid-glass-88a7ac`
Surfaces: React web (S1–S4 shared) · Flutter mobile · `design.md`
Mockup: https://claude.ai/code/artifact/dd2b84ef-55ec-462b-97b4-e58650f3dce1

---

## 1. Why

The current UI follows `design.md`'s "clarity over decoration" rule, which explicitly bans glassmorphism,
gradients and animated flourishes. The project owner has decided to reverse that rule and adopt an
Apple-style liquid glass aesthetic across both surfaces, with `design.md` rewritten to match so the
repository stays self-consistent for marking.

This spec records what changes, what deliberately does not, and why.

## 2. Decisions taken

| # | Decision | Rationale |
|---|---|---|
| D1 | Redesign **both** React web and Flutter mobile | Assignment requires two genuinely different surfaces off one API; redesigning one leaves an obvious mismatch |
| D2 | **Full consumer redesign**, not subtle polish | Owner's explicit choice |
| D3 | Rewrite `design.md` to match the new direction | Avoids code/doc contradiction during marking |
| D4 | `--primary` stays teal `#0F6D63` | Logo green/blue feed the ambient mesh and hero gradients; teal stays the *action* colour. Keeps the entire status→colour safety table valid and already contrast-checked |
| D5 | Light-first glass, dark theme fully supported | Apple's Liquid Glass is luminous; also matches the owner's reference image |
| D6 | **No glass npm package.** Pure CSS on web | Available "liquid glass" packages are WebGL toys that break accessibility and keyboard focus |
| D7 | Only new web dependency: `motion` (~5 kb) | Spring physics for sheet/drawer/nav transitions. Flutter needs none — `BackdropFilter` is built in |
| D8 | Custom vector marks drawn for in-app chrome | The supplied illustrated logo is a raster whose face detail is illegible below ~64 px |

## 3. The material system

One recipe, four densities. Depth is expressed by how much background a surface admits.

```css
.glass {
  background: linear-gradient(147deg, var(--glass-fill-hi), var(--glass-fill-lo));
  backdrop-filter: blur(var(--blur)) saturate(180%);
  border: 1px solid var(--glass-edge);
  box-shadow:
    inset 0 1px 0 0 var(--glass-spec),      /* top specular */
    inset 0 -1px 0 0 var(--glass-edge-dim),
    0 18px 44px -14px var(--glass-cast);    /* cast shadow */
}
```

| Density | Blur | Used for |
|---|---|---|
| Thin | 9 px | Chips, toolbars, inline filters |
| Regular | 22 px | Cards, panels — the default surface |
| Thick | 40 px | Nav bars, sheets, modals |
| Solid | none | Unapproved AI output, emergency screen |

Glass requires something behind it to blur. Both surfaces gain an ambient mesh layer: three slow-drifting
radial gradients using the logo's green `#8BC53F`, teal `#1FA07E` and blue `#1B6BA8`, disabled under
`prefers-reduced-motion`.

## 4. Guardrails — surfaces that reject glass

These are not stylistic preferences. Each maps to a stated project invariant.

| Surface | Treatment | Rule |
|---|---|---|
| Unapproved AI output | Opaque `--agent` `#4A4A8F`, never translucent | Clinical Rules 1, 2 — a frosted panel would let draft content blend into approved content, the exact failure the colour exists to prevent |
| Emergency screen | Solid `--emergency` `#8B0000`, no translucency, no motion, no AI text | Clinical Rule 10 |
| Clinical values & status pills | Flat backing, ≥4.5:1 contrast, label + shape never colour alone | `design.md` accessibility section, unchanged |
| Doctor approval gate | Solid, high-contrast action buttons | Invariant 6 — no patient-visible output bypasses it |

## 5. Scope

### 5.1 Brand assets — **complete**

| Path | State |
|---|---|
| `brand/dist/mark.svg` | Heart + shield + cross. Nav mark, app icons. Verified 512/240/22 px |
| `brand/dist/mark-small.svg` | Heart + cross. Favicon. Verified 32/16 px |
| `brand/generate-icons.sh` | Reproducible generation of every icon size from the vectors |
| `web/public/` | `favicon.svg` `favicon.ico` (16/32/48) `apple-touch-icon.png` `icon-192` `icon-512` `icon-maskable-512` `site.webmanifest` |
| `web/index.html` | Real title, icon links, manifest, theme-color per scheme, `noindex` |
| `mobile/android/.../mipmap-*` | All 5 densities |
| `mobile/ios/.../AppIcon.appiconset` | All 15 sizes, alpha stripped as iOS requires |

The supplied illustrated logo (`brand/source/`) is **not yet on disk**. When added it is used only on
splash, login and report surfaces where it has room; in-app chrome uses the vector mark.

### 5.2 React web — pending

| Path | Change |
|---|---|
| `web/src/styles/tokens.css` | New — colour, glass, type, spacing tokens; three theme states |
| `web/src/styles/materials.css` | New — the glass primitive and its four densities |
| `web/src/styles/components.css` | New — component classes, same names as today |
| `web/src/index.css` | Rewritten to import the above plus base/reset |
| `web/src/App.css` | Folded into `components.css`; file removed |
| `web/src/components/layout/AppLayout.tsx` | Pill nav, glass topbar, ambient mesh layer, vector mark |
| `web/src/components/shared/*` | `StatusBadge` shape marker, `ListToolbar` thin glass, `ViewState` restyle |
| `web/src/pages/**` | Markup tweaks only — metric tiles gain sparklines, approval panel goes solid |

Class names are preserved, so component churn stays small and existing tests keep passing.

### 5.3 Flutter mobile — pending

| Path | Change |
|---|---|
| `lib/theme/app_theme.dart` | Rewritten — glass tokens, light + dark, Material 3 |
| `lib/theme/glass.dart` | New — `GlassCard`, `GlassNavBar`, `GlassSheet`, `AmbientMesh` |
| `lib/screens/**` (13) | Adopt the glass kit; `emergency_screen.dart` explicitly excluded |
| `lib/widgets/shared/**` (5) | Restyled; `clinical_disclaimer.dart` keeps its solid backing |

**Performance constraint.** `BackdropFilter` is expensive and the target audience runs mid/low-range
Android. Cap: **three live blur layers per screen** (app bar, tab bar, active sheet). Every other
"glass" surface uses a tinted translucent fill, which costs nothing and is visually near-identical
at card scale.

### 5.4 Documentation

`design.md` — the "Design rule" and "Motion" sections are rewritten and a "Materials" section added.
The colour table, status mapping, accessibility rules, states checklist and the "deliberately does not"
list are **kept intact**.

## 6. Testing

| Check | How |
|---|---|
| Contrast | Every token pair ≥4.5:1 body / ≥3:1 large and UI edges, both themes |
| Reduced motion | Mesh drift and all transitions disabled under `prefers-reduced-motion` |
| Themes | Light, dark, and un-stamped system default all resolve — no token defined only inside a media block |
| Existing suites | `web`: vitest (`AppRouter`, `ApprovalsPage`, `OnboardingPage`, `ViewState`, `authSlice`); `mobile`: `flutter test` |
| Guardrails | Agent content opaque, emergency screen solid, no `agent` colour on any patient screen |

## 7. Known blocker

`registry.npmjs.org` is TLS-intercepted by a Fortinet appliance (`FG10E0TB22901445`) whose CA is not in
the machine's trust store. `npm install` and `bun install` both fail certificate verification;
`github.com` and `pub.dev` verify normally. `web/node_modules` is therefore empty and **the React build,
lint and test suites cannot run on this machine** until one of:

1. the appliance's CA certificate is installed in the system/npm trust store (IT-sanctioned path), or
2. the work is done from a network without registry interception.

Disabling TLS verification is **not** an accepted workaround — it removes the integrity check on package
downloads on a machine with a demonstrated middlebox in the path, which is precisely the supply-chain
risk the project's own security rules call out.

Flutter is unaffected if `pub.dev` stays clean.

## 8. Risks

| Risk | Mitigation |
|---|---|
| Glass reduces legibility of clinical data | Tables and values keep flat, high-contrast backings; glass is confined to chrome |
| Frame drops on low-end Android | Three-blur-layer cap; tinted fills elsewhere |
| React changes unverifiable on this machine | Class names preserved to minimise breakage; full suite must be run once the registry is reachable |
| `design.md` is a shared graded artifact | Rewrite touches only the design-rule and motion sections; ownership convention respected |
