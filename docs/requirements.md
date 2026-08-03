# Requirements — Family Veda

Traceability from the SE3090 Assignment 1 specification to the implementation. `agent/BRIEF.md` is the working summary; `docs/Family_Veda_Project_Blueprint.md` is authoritative.

## Specification fit

| Specification requirement | How Family Veda satisfies it |
|---|---|
| At least three user roles | **Five**: Family Head, Family Member (18+), Doctor, Clinic Admin, Agent |
| One major business component per student | Four naturally separable components (S1–S4) |
| CRUD plus business-specific operations | Members, records, lab reports, episodes, triage cases, approvals |
| Status workflows | Triage case lifecycle · doctor verification lifecycle · consent lifecycle |
| Search, filter, sort, pagination, reporting | Record browser, doctor queue, family dashboard, audit viewer |
| Different React and Flutter purposes | React = clinical/administrative · Flutter = patient/family operational |
| One complete cross-platform workflow | Flutter submission → agents → React approval → Flutter result |
| Meaningful third-party service | Notification service (FCM or Twilio) via the backend |
| Non-trivial authorisation | Family-scoped, consent-gated, case-scoped, time-bound grants |
| Multi-step agentic problem | Longitudinal context assembly is inherently multi-step, multi-source |
| Genuine human approval gate | Clinically mandatory, architecturally unbypassable |

## Functional requirements

| ID | Requirement | Owner | Priority |
|---|---|---|---|
| FR-01 | Family account with member profiles and biological relationships | S1 | Must |
| FR-02 | Role-based authentication and authorisation across 5 roles | S1 | Must |
| FR-03 | Granular consent management, per member, per data category | S1 | Must |
| FR-04 | Consent auto-transitions to `PENDING_REAFFIRMATION` when a member turns 18 | S1 | Must |
| FR-05 | Health record repository: conditions, allergies, medications, surgeries, immunisations | S2 | Must |
| FR-06 | Lab report upload with camera capture (device feature) | S2 | Must |
| FR-07 | OCR extraction of lab values, with a manual-correction fallback | S2 | Must |
| FR-08 | Structured hereditary flag extraction into `hereditary_flags` | S2 | Must |
| FR-09 | Vitals recording and trend computation | S2 | Must |
| FR-10 | Episode/complaint submission from mobile | S3 | Must |
| FR-11 | Agentic triage workflow: Coordinator + 4 agents | S3 + S4 | Must |
| FR-12 | Agent trace persistence and a trace viewer | S3 | Must |
| FR-13 | Deterministic clinical safety validation | S4 | Must |
| FR-14 | Familial risk signal detection across consented profiles | S4 | Must |
| FR-15 | Doctor review / revise / approve / reject / escalate | S4 | Must |
| FR-16 | Doctor self-registration and admin verification | S4 + S1 | Must |
| FR-17 | Time-bound, case-scoped access grants | S4 | Must |
| FR-18 | Full audit logging of cross-profile access | S4 | Must |
| FR-19 | Push/SMS notification on case status change | S3 | Must |
| FR-20 | Family health dashboard and reporting | S3 | Should |
| FR-21 | Emergency red-flag detection with a safe-failure path | S4 | Must |

## Non-functional requirements

| ID | Requirement | Target |
|---|---|---|
| NFR-01 | Full 4-agent workflow latency | Under 60 s on the demo machine |
| NFR-02 | API response time for CRUD reads | Under 500 ms at seed data volume |
| NFR-03 | Test coverage on each member's service layer | ≥ 80% |
| NFR-04 | Availability of the deployed stack during evaluation | Reachable, verified daily in W9 |
| NFR-05 | Transport security | HTTPS enforced; no plaintext HTTP |
| NFR-06 | Secrets handling | Environment variables only; never committed |
| NFR-07 | Data policy | Synthetic data only |
| NFR-08 | Accessibility | 44×44 touch targets; contrast ≥ 4.5:1; status never colour-only |
| NFR-09 | Every list view | Search, filter, sort, pagination |
| NFR-10 | Every data view | Loading, empty, error and success states |
| NFR-11 | Auditability | Every cross-profile read produces an audit row |
| NFR-12 | Reproducibility of clinical safety decisions | Deterministic — same input, same output |

## Constraints

| Constraint | Source |
|---|---|
| ASP.NET Core Web API is mandatory | Module specification |
| PostgreSQL, React and Flutter are mandatory | Module specification |
| An agentic AI subsystem is mandatory | Module specification |
| No real patient data | Ethics policy (blueprint §17) |
| AI use Level 4 during development, Level 1 at demo and viva | Module specification |
| Scope frozen at the end of W5 | `agent/DECISIONS.md` |
| Free-tier hosting only | Team budget |
| Access maintained until 21 Oct 2026 | Module specification |

## Out of scope

Appointment booking · payments · calendar sync · live video · meal plans and lifestyle prescriptions · direct urgent AI advice · automated SLMC verification · pharmacy dispensing · wearables · real patient data.

Reasoning and reserved extension points: `docs/FUTURE_WORK.md`.
