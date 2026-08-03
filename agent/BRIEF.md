# Project Brief — Family Veda

> Source of truth: `docs/Family_Veda_Project_Blueprint.md`. This file is the working summary agents read on boot. If the two disagree, the blueprint wins.

## Identity

| Field | Value |
|---|---|
| Project | **Family Veda** |
| Tagline | Your family doctor, with your family's whole story. |
| Meaning | *vedā* (වෙදා) = Sinhala for traditional healer/doctor. Pronounced *VAY-daa* |
| Module | SE3090 — Software Engineering Frameworks, SLIIT Faculty of Computing |
| Assignment | Assignment 1 — Group Full-Stack and Agentic AI Project |
| Group | SE_016 · Lab group Y3.S1.SE.WE.01.01 |
| Weighting | 25% of module · 100 marks (30 group + 70 individual) |
| Duration | 31 Jul 2026 → 30 Sep 2026 (9 weeks) |
| Due | Wed 30 Sep 2026, 11:50 PM (submit 29 Sep) |
| Submission name | `SE3090_SE016` |
| Evaluation | 10-minute demonstration + 20-minute viva |
| Access maintained until | 21 Oct 2026 |

## Project type

Integrated full-stack clinical decision-support platform with a controlled multi-agent AI subsystem. Academic prototype. Synthetic data only.

## Goal

Give Sri Lankan family doctors the longitudinal patient context they currently lack, using a controlled multi-agent AI system that assembles each member's health history, detects deviations from their personal baseline, and surfaces consented familial risk signals — with every output requiring licensed doctor approval before it reaches a patient.

## Main problem

Sri Lanka has family doctors, but they operate without patient history. Every consultation starts from zero, so patients bypass their GP for hospitals. The failure is **loss of continuity**, not lack of availability.

## Target users (5 roles)

| Role | Surface | Sees |
|---|---|---|
| Family Head | Flutter + React | Own record; minors' records in family; family dashboard; minors' consent |
| Family Member (18+) | Flutter + React | Own record and consent only |
| Doctor (VERIFIED) | React | Only cases with an active, unexpired grant |
| Clinic Admin | React | Doctor verification queue; system config; **no clinical data** |
| Agent (system) | — | Only what an allow-listed tool returns, always scoped |

## Main workflow (the demo centrepiece)

```text
Flutter: father uploads son's FBC via camera
   → OCR + Extraction Agent → hereditary_flags row
Flutter: father submits "son, 12, fever 3 days"
   → Coordinator → Context → Analysis → Familial Risk → Safety (deterministic)
   → red flag? ESCALATED : PENDING_DOCTOR_REVIEW
React: doctor opens case, sees timeline + deviations + familial signal + agent trace
React: doctor REVISES and APPROVES
   → notification service → Flutter
Flutter: father reads doctor-approved guidance + screening advice
```

All four members' work appears in one continuous workflow.

## Positioning (memorise)

> Family Veda does not diagnose. It closes the **context gap**. The AI performs context assembly, trend analysis and deviation flagging. Clinical judgement, decision and accountability remain entirely with the licensed doctor, enforced architecturally through a mandatory approval gate.

## Team and component allocation

| Ref | IT Number | Name | Component | Extra |
|---|---|---|---|---|
| **S1** | IT23544154 | Samaranayaka S.G.V.S | Family, Identity & Consent | CI/testing lead · **tool-permission enforcement layer** |
| **S2** | IT24101875 | Fernando K.R.N | Health Records & Extraction | OCR pipeline · Extraction Agent |
| **S3** | IT24100551 | Karunathilaka K.D.J.C | Triage & Agent Orchestration | **Group Leader** · notifications · Coordinator + Context + Analysis Agents |
| **S4** | IT24100559 | W.M.S.S.B. Wasala | Familial Risk & Clinical Approval | Deterministic rule tables · Familial Risk + Safety Agents |

**Allocation rule:** each member owns **one business feature end to end** across API + DB + React + Flutter + Agents. Never split by layer (A=backend, B=frontend) — 70 of 100 marks are individual and each individual rubric band asks the student to *explain, test, modify or debug* their own contribution across all five technologies.

## MVP — in scope (frozen at W5)

1. Family account with member profiles and biological relationships — S1
2. Role-based auth/authorisation, 5 roles — S1
3. Granular consent management (per member, per data category) — S1
4. Health record repository: conditions, allergies, medications, surgeries — S2
5. Lab report upload with camera capture and OCR extraction — S2
6. Structured hereditary flag extraction — S2
7. Vitals recording and trend computation — S2
8. Episode/complaint submission from mobile — S3
9. Agentic triage workflow (Coordinator + 4 agents) — S3 + S4
10. Agent trace persistence and viewer — S3
11. Deterministic clinical safety validation — S4
12. Familial risk signal detection across consented profiles — S4
13. Doctor review / revise / approve / reject / escalate — S4
14. Doctor self-registration and admin verification — S4 + S1
15. Time-bound, case-scoped access grants — S4
16. Full audit logging of cross-profile access — S4
17. Push/SMS notification on case status change — S3
18. Family health dashboard and reporting — S3
19. Emergency red-flag detection and safe-failure path — S4

## Out of scope — v1

Appointment booking · payments/billing · external calendar sync · live video (WebRTC) · meal plans and lifestyle prescriptions · direct urgent AI advice · automated SLMC registry verification · pharmacy/e-prescription · wearables · **any real patient data**.

Full reasoning and reserved extension points: blueprint §18, mirrored in `docs/FUTURE_WORK.md`.

## Stack (mandated + selected)

| Layer | Technology | Target |
|---|---|---|
| Backend | ASP.NET Core Web API, C# 12 | .NET 8 (LTS) |
| ORM | EF Core + Npgsql | EF Core 8 |
| Database | PostgreSQL | 16 |
| Web | React (Vite) + React Router | React 18 |
| Web state | Redux Toolkit (ADR-004) | — |
| Mobile | Flutter / Dart | Flutter 3.x |
| Mobile routing | go_router | — |
| Mobile state | Riverpod (ADR-005) | — |
| Secure storage | flutter_secure_storage | — |
| LLM runtime | **Ollama, local** (ADR-006) | llama3.1:8b |
| OCR | Tesseract / Google ML Kit on-device | — |
| API docs | Swagger / OpenAPI | built-in |
| CI | GitHub Actions | — |
| Testing | xUnit + Moq, Vitest + RTL, flutter_test | — |
| Notifications | Firebase Cloud Messaging (fallback: Twilio SMS) | — |

## Data model

Full schema: `docs/DATABASE.md`. 18 tables across four owners.

| Owner | Tables |
|---|---|
| S1 | `users` `families` `members` `relationships` `consents` |
| S2 | `health_records` `lab_reports` `lab_values` `vitals` `hereditary_flags` |
| S3 | `episodes` `triage_cases` `agent_traces` |
| S4 | `doctors` `doctor_verification_log` `family_doctor_assignments` `case_access_grants` `approvals` `audit_log` |

**Two-stage model — the core design idea:** raw records stay member-scoped (Stage 1, Extraction Agent). Only small, consented, structured `hereditary_flags` cross member boundaries (Stage 2, Familial Risk Agent). *Flags cross, files don't.*

## APIs and integrations

- One ASP.NET Core API at `/api/v1`, consumed by **both** React and Flutter. No second backend.
- Third-party: FCM push (fallback Twilio SMS) — called **only** by the backend, never by a client.
- LLM: Ollama on localhost — called **only** by the backend agent layer, never by a client.
- Full contract: `docs/API_CONTRACT.md`.

## LLM requirements

- LLM required: **yes**, for the Context, Analysis and Familial Risk agents (structuring and wording only).
- Deterministic, **no LLM**: Safety/Validation Agent, inheritance pattern tables, reference ranges, red-flag tables.
- Provider: Ollama local (ADR-006) — data residency for health data, zero cost, offline demo.
- Structured output: mandatory JSON schema per agent; schema failure → retry once → safe failure.
- Privacy level: high (synthetic health data, but treated as if real).
- Latency target: full 4-agent workflow under 60 s on the demo machine.

## Auth

- JWT bearer, ASP.NET Core Identity-style hashing, refresh tokens.
- Roles: `FAMILY_USER` (head/member), `DOCTOR`, `ADMIN`. Clinical access is **not** granted by role.
- **Access by grant, not by role** — authorisation reads `case_access_grants`, not `user.role` (ADR-008).
- Consent gate on every cross-profile read; audit row on every cross-profile read.

## Payments

Not required. Deferred deliberately (blueprint §18.2) — v1 assumes clinic-side settlement outside the platform.

## Deployment

| Component | Platform |
|---|---|
| API | Render / Azure App Service free tier, HTTPS enforced |
| PostgreSQL | Neon / Supabase free tier, connection string via env only |
| React web | Vercel / Netlify |
| Flutter | Signed APK submitted with the report, tested on a physical Android device |
| Ollama | Local, run during the demonstration |

Details and evaluator access package: `docs/DEPLOYMENT.md`.

## Design direction

See `design.md`. Clinical-calm, high-contrast, information-dense. React = clinical/administrative. Flutter = patient/family operational. UI polish is the **first thing cut** under time pressure.

## Evaluation

- Agent output evaluator: JSON schema validation + deterministic rule tables + prohibited-content check (no diagnosis language, no drug dosing, no prescription, no meal plan).
- Hard failures: schema invalid · prohibited content present · red flag present · confidence below threshold · denied tool call attempted.
- Passing score: schema valid **and** zero prohibited content **and** zero denied-tool violations.
- Maximum revisions: **1** retry, then safe failure.
- Human approval required: **always**. No patient-visible output exists that has not passed the doctor approval gate.

## Approval model

| Action | Risk | Approval required | Rollback |
|---|---|---|---|
| Show any advisory to a patient | Critical | Licensed verified doctor, per case | Case status reverts; advisory withdrawn |
| Grant a doctor access to a case | High | System policy + time bound (48 h), audited | `case_access_grants.revoked_at` |
| Verify a doctor | High | Clinic Admin, manual SLMC check | `doctor_verification_log` SUSPEND |
| Cross-profile hereditary flag read | High | Member/guardian consent, audited | Consent revoke removes flag from analysis |
| DB migration | Medium | Migration lock announced in group chat | New migration, never edit a pushed one |
| Merge to `develop` | Medium | 1 peer PR review + green CI | Revert commit |

## Logging

- Log: auth events, consent changes, cross-profile reads, agent steps (input hash, tools requested/allowed/denied, output, confidence, latency, tokens), doctor decisions, verification transitions.
- Never log: passwords, raw JWTs, full record content in audit rows, OCR raw text in agent traces.
- Retention: full project lifetime; DB retained until 21 Oct 2026.

## Acceptance criteria

- [ ] React and Flutter use the same API, database, identity and permissions
- [ ] Five roles enforced (spec requires three)
- [ ] CRUD plus business operations on every component
- [ ] Three status workflows implemented and demonstrable (triage case, doctor verification, consent)
- [ ] Search, filter, sort, pagination and reporting on every list view
- [ ] One complete cross-platform workflow demonstrable end to end
- [ ] Device feature (camera lab capture) working on a physical device
- [ ] Third-party service integrated through the backend only
- [ ] Tool allow-list enforced; a **denied call demonstrable live**
- [ ] Deterministic validation demonstrable
- [ ] Approval gate demonstrable with no bypass path
- [ ] Emergency red-flag path demonstrable with zero AI output
- [ ] Agent traces visible in the UI
- [ ] Safe failure demonstrable
- [ ] Tests passing, CI green on `main`
- [ ] Every member can explain, test, modify and debug their own contribution

## Risks

Top five (full register in `docs/RISK_REGISTER.md`):

| Risk | Impact | Mitigation |
|---|---|---|
| Agent workflow not working by W6 | Critical | Hard W6 gate; contingency ships 3 agents not 4 |
| Integration left until the end | Critical | W4 gate forces end-to-end integration at halfway |
| A member cannot explain their own component | Critical | Mock viva ×2 in W9; each member demos to the group first |
| Examiner challenges the genetics framing | High | Blueprint §6.6 memorised by all four members |
| Free-tier hosting sleeps during evaluation | High | Deploy W8, verify daily in W9, local fallback ready |

## Open questions

1. Component allocation to be confirmed in the Week 1 group meeting (blueprint §1.1) — the *rule* is fixed, the *assignment* is a proposal.
2. Ollama model choice (`llama3.1:8b` vs smaller) pending the W5 latency test on the actual demo machine.
3. Notification provider: FCM primary, Twilio SMS fallback — decide by W6 based on Android device availability.
4. Hosting pair (Render+Neon vs Azure+Supabase) — decide by W7, before the W8 deploy gate.
