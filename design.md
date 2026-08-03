# Design System — Family Veda

STATUS: PROJECT-SPECIFIC · applies to both React (clinical/admin) and Flutter (patient/family)

## Design rule

**Clarity over decoration.** This is a clinical decision-support tool. A doctor scanning a case queue under time pressure and a worried parent reading a lab result have the same need: unambiguous information. Glassmorphism, gradients, and animated flourishes are **not** used. UI polish is explicitly the **first thing cut** when the schedule slips (blueprint §19.1).

## Brand

| Field | Value |
|---|---|
| Product name | Family Veda |
| Meaning | *vedā* (වෙදා) — the family's doctor. Pronounced *VAY-daa* |
| Audience | Sri Lankan families (Flutter) · licensed GPs and clinic admins (React) |
| Visual tone | Calm, clinical, trustworthy. Not playful, not "wellness app" |
| Trust level | High — the product handles health data and must never look like a consumer chatbot |
| References | Hospital record systems and lab report layouts, not fitness apps |

## Two surfaces, two purposes

The specification requires React and Flutter to serve genuinely different purposes.

| | React web | Flutter mobile |
|---|---|---|
| User | Doctor, Clinic Admin, Family Head (admin tasks) | Family Head, Family Member |
| Purpose | **Clinical and administrative** | **Patient and family operational** |
| Density | High — tables, queues, timelines, traces side by side | Low — one task per screen, thumb-reachable |
| Primary interaction | Read, compare, decide, approve | Capture, submit, track, read result |
| Screen size assumption | 1280px+ desktop, responsive down to tablet | Phone portrait first |

## Colours

Semantic, not decorative. Every colour carries meaning; nothing is used for atmosphere.

| Token | Light | Dark | Usage |
|---|---|---|---|
| `primary` | `#0F6D63` | `#3AA394` | CTA, active nav, approve action. Deep teal — clinical, not corporate blue |
| `background` | `#F7F9F9` | `#101615` | Page background |
| `surface` | `#FFFFFF` | `#1A2322` | Cards, panels, table rows |
| `border` | `#DDE4E3` | `#2C3937` | Dividers, table rules, input borders |
| `text` | `#132220` | `#EAF0EF` | Body and headings |
| `muted` | `#5C6D6A` | `#9AAAA7` | Secondary text, timestamps, units |
| `danger` | `#B3261E` | `#F2685F` | Errors, reject, revoked consent |
| `warning` | `#A66300` | `#E0A44A` | Out-of-range values, SLA nearing expiry, low confidence |
| `success` | `#1F7A45` | `#4BB574` | Approved, verified, in-range values |
| `emergency` | `#8B0000` | `#FF4D4D` | **Red-flag / emergency screen only.** Never used decoratively |
| `agent` | `#4A4A8F` | `#8C8CD9` | Agent trace steps, AI-generated draft content |

### Colour rules

1. **`agent` colour marks every piece of unapproved AI content.** Draft advisories, trace output and agent-derived signals are visually distinct from doctor-approved content at all times. A patient must never see `agent`-coloured content — if it is on a patient screen, that is a bug.
2. `emergency` is reserved for the red-flag path. Using it anywhere else devalues it.
3. Clinical values use `success` / `warning` / `danger` strictly against the reference range in the data, never against a designer's judgement.
4. Never encode status by colour alone — always pair with a label or icon (colour-blind accessibility, and doctors work on bad monitors).

## Status colour mapping

| Status | Token |
|---|---|
| `SUBMITTED` `PLANNING` `CONTEXT_READY` `ANALYSED` `RISK_ASSESSED` | `muted` |
| `VALIDATED` `PENDING_DOCTOR_REVIEW` | `primary` |
| `AWAITING_INFO` `LOW_CONFIDENCE` | `warning` |
| `APPROVED` `APPROVED_REVISED` `DELIVERED` `CLOSED` `VERIFIED` | `success` |
| `REJECTED` `AGENT_FAILED` `REVOKED` `SUSPENDED` | `danger` |
| `ESCALATED` | `emergency` |
| `PENDING` (doctor verification) `NOT_SET` `PENDING_REAFFIRMATION` | `warning` |

## Typography

| Role | Choice | Note |
|---|---|---|
| Main font | Inter (web) / Roboto (Flutter default) | Both ship a Sinhala-capable fallback for future localisation |
| Headings | 600 weight, tight tracking | Never all-caps for clinical labels |
| Body | 400 weight, 1.55 line height | Long-form advisory text must stay readable |
| Numbers / data | **Tabular figures**, monospace tint | Lab values and vitals must align in columns |
| Units | `muted`, one step smaller, never bolded | `7.2 %` reads as one value, not two |

Minimum body size: 16 px web, 15 sp Flutter. Never below 12 px for any clinical value.

## Layout

| Aspect | React | Flutter |
|---|---|---|
| Max width | 1440 px content, tables full-bleed within the panel | Device width |
| Grid | 12-column, 24 px gutter | Single column, 16 px page padding |
| Spacing scale | 4 · 8 · 12 · 16 · 24 · 32 · 48 | 4 · 8 · 12 · 16 · 24 |
| Mobile behaviour | Tables collapse to stacked cards below 768 px | Portrait first; landscape must not break forms |
| Desktop behaviour | Case Detail is a three-pane layout: timeline · findings · approval panel | n/a |

## Components

### React

| Component | Rules |
|---|---|
| `<DataTable>` | Sortable headers, sticky header, zebra rows off, row click opens detail. **Every** table gets search, filter, sort, pagination |
| `<StatusBadge>` | Label + colour + icon. Never colour alone |
| `<TimelineChart>` | Reference band shaded, out-of-range points marked with shape as well as colour |
| `<TraceStep>` | Numbered, `agent`-tinted, collapsed by default; shows tools requested / **allowed** / **denied**, confidence, latency, tokens. Denied tools render in `danger` |
| `<ApprovalPanel>` | Five actions, destructive ones behind `<ConfirmDialog>`. Approve is `primary`, Reject is `danger`, Escalate is `emergency` |
| `<ConfirmDialog>` | Required for approve, reject, escalate, revoke consent, suspend doctor |
| `<EmptyState>` | Explains *why* it is empty and what to do next — never a bare "No data" |
| `<ErrorBoundary>` | Wraps the app; shows a recoverable message, never a stack trace |

### Flutter

| Widget | Rules |
|---|---|
| `MemberCard` | Name, age, sex, active-profile indicator. Tapping switches active profile |
| `StatusStepper` | Mirrors the triage state machine exactly — the patient sees the same states the system stores |
| `VitalTile` | Value, unit, reference range, trend arrow. Out-of-range uses colour **and** an icon |
| `SymptomChip` | Multi-select, minimum 44×44 touch target |
| `EmptyStateView` / `ErrorRetryView` | Every async surface has both, plus a retry action |

### Disclaimer component (both platforms, mandatory)

Persistently visible on any advisory screen:

> This is a clinical decision-support tool. It does not provide medical diagnosis. All guidance is reviewed and approved by a licensed doctor before you receive it. In an emergency, seek immediate in-person medical care.

### Emergency screen (Flutter, S4)

Deliberately minimal. No AI-generated text of any kind.

- `emergency` header: "Seek immediate in-person medical care."
- Suwa Seriya **1990** as a one-tap call action
- Nearest hospital list
- Statement that the case has been sent to verified doctors and the Family Head notified

## States

Every UI surface handles all eight:

`loading` · `empty` · `error` · `success` · `disabled` · `hover/focus` · `mobile` · `reduced motion`

This is explicitly assessed on both platforms. A screen missing a state is incomplete, not "polish pending".

## Accessibility

- Minimum touch target 44×44 px / dp
- Visible keyboard focus ring on every interactive element (doctors work fast, often keyboard-first)
- Contrast ≥ 4.5:1 for body text, ≥ 3:1 for large text and UI boundaries
- Semantic HTML in React; `Semantics` widgets and labels in Flutter
- Status never conveyed by colour alone
- Respect `prefers-reduced-motion`; no essential information conveyed only by animation
- Form fields have persistent labels, not placeholder-only labels

## Motion

Minimal by policy. Transitions ≤ 150 ms, easing only. No decorative animation. Loading uses a determinate progress indicator where the duration is knowable (agent workflow steps) and a simple spinner otherwise.

## What this design system deliberately does not do

- No dark-pattern urgency, no streaks, no gamification — this is health data.
- No chat-bubble UI anywhere. Family Veda is not a chatbot, and it must not look like one.
- No AI branding on patient screens. The patient receives **doctor-approved guidance**; the AI's involvement is disclosed in the disclaimer, not celebrated in the UI.
