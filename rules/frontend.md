# Frontend Rules — Family Veda

Applies to **both** React (`web/`) and Flutter (`mobile/`). Design tokens and component rules: `design.md`. Stack detail: `rules/react/`, `rules/typescript/`, `rules/flutter/`.

## Two surfaces, two purposes

| | React | Flutter |
|---|---|---|
| Users | Doctor, Clinic Admin, Family Head (admin) | Family Head, Family Member |
| Purpose | Clinical and administrative | Patient and family operational |
| Density | High — tables, queues, timelines side by side | Low — one task per screen |

The specification requires them to serve **genuinely different purposes**. Do not port a React screen to Flutter or vice versa.

## Required on every data view

- `loading` · `empty` · `error` · `success` — all four. This is assessed; a missing state is incomplete work, not "polish pending".
- Empty states explain *why* it is empty and what to do next. Never a bare "No data".
- Errors are recoverable and offer a retry. Never a stack trace.

## Required on every list view

Search · filter · sort · pagination. Assessed on both platforms.

## Required everywhere

- Client-side validation mirroring the server rules.
- Route guards enforced on both platforms — React Router protected routes, `go_router` redirect guards.
- Reusable components, not copy-paste screens.
- Design tokens from `design.md`. No ad-hoc hex values.
- Status conveyed by **label + colour + icon**, never colour alone.
- Minimum 44×44 touch targets; visible keyboard focus; contrast ≥ 4.5:1.
- Respect `prefers-reduced-motion`; no essential information carried only by animation.
- Persistent labels on form fields, not placeholder-only labels.

## Clinical UI rules

- **Unapproved AI content is visually distinct at all times** (`agent` token). If `agent`-coloured content appears on a patient screen, that is a bug.
- The `emergency` token is reserved for the red-flag path. Never decorative.
- Clinical values are coloured strictly against the reference range in the data, never by judgement.
- The disclaimer component is persistently visible on any advisory screen, both platforms.
- The emergency screen contains **no AI-generated text**: referral, 1990, hospitals, notification statement.

## Forbidden

- Chat-bubble UI anywhere. Family Veda is not a chatbot and must not look like one.
- AI branding on patient screens. The patient receives doctor-approved guidance.
- Gamification, streaks, urgency dark patterns. This is health data.
- Inaccessible clickable `div`s / bare `GestureDetector` without semantics.
- Hardcoded secrets. `VITE_*` values are inlined into the client bundle.
- Placeholder UI merged as complete.
- Restructuring `AppRouter.tsx` or `app_router.dart` — add your route block only.
