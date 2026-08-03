# TODO — Family Veda (SE3090_SE016)

> Full backlog derived from `docs/Family_Veda_Project_Blueprint.md`. Week plan in `docs/TIMELINE.md`.
> Ownership tags `[S1]`–`[S4]` are binding: **only the owner edits owner-tagged files**. `⚠ SHARED` files follow the labelled-block convention (blueprint §14.1.3).

## Current

**Phase:** W0 — repository and documentation setup (pre-W1).
**Active task:** project workspace converted from template to Family Veda. No application code written yet.

## Status board — weekly gates

| Week | Dates | Theme | Gate | State |
|---|---|---|---|---|
| W0 | — | Repo + docs setup | Workspace project-specific | ✅ done |
| W1 | Jul 31 – Aug 6 | Foundation | Contract signed off by all 4 | ⬜ |
| W2 | Aug 7 – 13 | Skeleton | 🚦 **CI green** | ⬜ |
| W3 | Aug 14 – 20 | Core CRUD | All endpoints 2xx in Swagger | ⬜ |
| W4 | Aug 21 – 27 | Frontend wiring | 🚦 **E2E login + record create on both platforms** | ⬜ |
| W5 | Aug 28 – Sep 3 | Agents I | Extraction + Context persist output · **SCOPE FREEZE** | ⬜ |
| W6 | Sep 4 – 10 | Agents II | 🚦 **Full workflow runs end to end** | ⬜ |
| W7 | Sep 11 – 17 | Integration & quality | Cross-platform demo runs unaided | ⬜ |
| W8 | Sep 18 – 24 | Deploy & document | 🚦 **Deployed and reachable by evaluator** | ⬜ |
| W9 | Sep 25 – 30 | Freeze & viva | Submitted 29 Sep, one day early | ⬜ |

---

## W1 — Foundation (Jul 31 – Aug 6)

### Group
- [ ] Week 1 group meeting: **confirm component allocation** (blueprint §1.1 is a proposal, the allocation *rule* is not)
- [ ] Write and sign the group charter (roles, response times, escalation path)
- [ ] Create GitHub repo `SE3090_SE016`, add all 4 members + lecturer access
- [ ] Protect `main` and `develop`; require 1 approving review + green CI
- [ ] Agree branch naming `feature/s<n>-<slug>` and conventional commit prefixes
- [ ] Finalise the ER diagram → `docs/diagrams/er-diagram.png` (source in `docs/diagrams/`)
- [ ] Draft the OpenAPI contract → `docs/api/openapi.yaml`
- [ ] Wireframes for React and Flutter → `docs/diagrams/`
- [ ] Write **ADR-001** (backend framework selection) → `docs/adr/ADR-001-backend-framework.md`
- [ ] **Freeze the domain and scope** — record the freeze date in `agent/DECISIONS.md`
- [ ] Each member creates `docs/ai-disclosure/S<n>.md` and makes the first entry

### Per member
- [ ] [S1] Confirm ownership of the tool-permission enforcement layer in writing (this is S1's agentic contribution — must be explicit in the individual report)
- [ ] [S2] Collect 5+ sample Sri Lankan lab report layouts (synthetic/redacted) for OCR planning
- [ ] [S3] Draft the triage case state machine as a diagram
- [ ] [S4] Draft the four deterministic rule tables (red flags, paediatric vitals, inheritance patterns, allergy contraindications)

---

## W2 — Skeleton (Aug 7 – 13) · 🚦 gate: CI green

- [ ] [S1] Scaffold the ASP.NET Core solution: `backend/src/{Api,Application,Domain,Infrastructure}` + `backend/tests`
- [ ] [S1] `AppDbContext` skeleton with the S1/S2/S3/S4 labelled `DbSet` blocks ⚠ SHARED
- [ ] [S1] First EF Core migration; `dotnet ef database update` against local PostgreSQL 16
- [ ] [S1] JWT issuing + validation; `[Authorize]` policies scaffolded
- [ ] [S1] `ExceptionMiddleware` returning RFC 7807 Problem Details
- [ ] [S1] `.github/workflows/ci.yml`: backend + web + mobile + quality jobs
- [ ] [S1] `.github/pull_request_template.md`
- [ ] [S3] React shell: Vite + React Router + Redux store skeleton ⚠ SHARED
- [ ] [S1] React protected-route wrapper and role guards
- [ ] [S1] Flutter shell: `go_router` + Riverpod + `flutter_secure_storage` wiring ⚠ SHARED
- [ ] [ALL] Verify CI green on a PR into `develop` before the gate closes
- [ ] [ALL] Local dev setup documented in `README.md` and reproduced by another member

---

## W3 — Core CRUD (Aug 14 – 20) · gate: all endpoints 2xx in Swagger

### S1 — Identity, Family, Consent
- [ ] Tables `users` `families` `members` `relationships` `consents` with FKs, CHECKs, indexes
- [ ] `POST /auth/register` `POST /auth/login` `POST /auth/refresh`
- [ ] `GET /families/me` `POST /families` `PUT /families/{id}`
- [ ] `GET|POST /families/{id}/members` · `GET|PUT|DELETE /members/{id}`
- [ ] `GET|POST /members/{id}/relationships` — enforce `is_biological` NOT NULL
- [ ] `GET /members/{id}/consents` · `PUT /members/{id}/consents/{category}` · `POST /members/{id}/consents/reaffirm`
- [ ] Consent state machine: `NOT_SET → GRANTED → REVOKED`, and `GRANTED → PENDING_REAFFIRMATION` on turning 18
- [ ] `AuthService` `FamilyService` `ConsentService` + unit tests

### S2 — Records and Extraction
- [ ] Tables `health_records` `lab_reports` `lab_values` `vitals` `hereditary_flags`
- [ ] `GET|POST /members/{id}/records` (paged, filtered, sorted) · `PUT|DELETE /records/{id}`
- [ ] `GET /members/{id}/lab-reports` · `POST /members/{id}/lab-reports` (multipart) · `GET /lab-reports/{id}`
- [ ] `GET|POST /members/{id}/vitals` · `GET /members/{id}/vitals/trends`
- [ ] `GET /members/{id}/hereditary-flags`
- [ ] `RecordService` `VitalsTrendService` + unit tests
- [ ] `SyntheticFamilySeed` — the demo family of four (blueprint §8.7)

### S3 — Episodes and Triage
- [ ] Tables `episodes` `triage_cases` `agent_traces`
- [ ] `POST|GET /members/{id}/episodes`
- [ ] `GET /triage-cases/{id}` · `/status` · `/traces`
- [ ] `GET /families/{id}/triage-cases` (paged, filtered) · `GET /families/{id}/dashboard`
- [ ] `POST /notifications/subscribe`
- [ ] `EpisodeService` + unit tests

### S4 — Doctor, Approval, Risk, Audit
- [ ] Tables `doctors` `doctor_verification_log` `family_doctor_assignments` `case_access_grants` `approvals` `audit_log`
- [ ] `POST /doctors/register` · `GET /doctors/me` · `GET /doctors/me/cases`
- [ ] `GET /admin/doctors?status=PENDING` · `verify` `request-info` `reject` `suspend`
- [ ] `POST /triage-cases/{id}/{claim,approve,revise,reject,escalate}`
- [ ] `GET /members/{id}/familial-risk` · `GET /audit?subjectMemberId=`
- [ ] `DoctorVerificationService` `ApprovalService` `AuditService` + unit tests

### Shared
- [ ] [ALL] Request and response DTOs for every endpoint — entities are never exposed
- [ ] [ALL] FluentValidation validators returning field-level 400s
- [ ] [ALL] Every action `async Task<ActionResult<T>>`
- [ ] [ALL] First PRs merged with a peer review each

---

## W4 — Frontend wiring (Aug 21 – 27) · 🚦 gate: E2E login + record create on both platforms

### React
- [ ] [S1] Login / Register page with role-based redirect
- [ ] [S1] Family Management (members CRUD, relationships)
- [ ] [S1] Consent Management (per-category toggles, reaffirmation prompt)
- [ ] [S2] Record Browser (search, filter, sort, paginate)
- [ ] [S2] Lab Report Viewer (parsed values, reference ranges, trend chart)
- [ ] [S3] Family Health Dashboard
- [ ] [S4] Doctor Case Queue (filter by priority/status, sort, paginate, SLA countdown)
- [ ] [S4] Case Detail shell
- [ ] [ALL] Shared components: `DataTable` `StatusBadge` `EmptyState` `ConfirmDialog` `ErrorBoundary` ⚠ SHARED — PR review required

### Flutter
- [ ] [S1] Onboarding / Login with `flutter_secure_storage`
- [ ] [S1] Family Setup + Member Switcher (persisted active profile)
- [ ] [S2] Records List (search, filter by type, sort, paginate)
- [ ] [S2] Record Vitals form
- [ ] [S3] Home / Member Summary
- [ ] [S3] Submit Complaint (symptom picker, duration, severity slider, notes)
- [ ] [ALL] Shared widgets: `MemberCard` `StatusStepper` `VitalTile` `SymptomChip` `EmptyStateView` `ErrorRetryView` ⚠ SHARED

### Both
- [ ] [ALL] Loading / empty / error / success states on **every** data view
- [ ] [ALL] Client-side validation mirroring server rules
- [ ] [ALL] Route guards enforced on both platforms

**Contingency if the gate is missed:** cut dashboard charts and the Flutter notification inbox. Core CRUD is non-negotiable.

---

## W5 — Agents I (Aug 28 – Sep 3) · gate: Extraction + Context persist output · **SCOPE FREEZE**

- [ ] [S3] Install Ollama; pull `llama3.1:8b`; **measure latency on the actual demo machine** (risk R2)
- [ ] [S3] `OllamaClient` with timeout, retry-once and structured-output parsing
- [ ] [S1] `ToolRegistry` — declare every tool and its per-agent allow-list
- [ ] [S1] `ToolDispatcher` — **enforce the allow-list at dispatch**; a denied call returns a hard error and writes to `agent_traces.tools_denied`
- [ ] [S1] Unit tests proving a denied tool call fails and is logged (this is S1's headline viva demo)
- [ ] [S3] `IAgent` contract ⚠ SHARED — interface changes need group agreement
- [ ] [S3] `Coordinator` — validates request shape, creates `TriageCase` (PLANNING), emits trace step 0
- [ ] [S2] `ExtractionAgent` — OCR → parse → identify hereditary-relevant findings → `hereditary_flags` row
- [ ] [S2] `TesseractOcrService`; `ocr_status` lifecycle incl. `FAILED` + manual-entry fallback
- [ ] [S2] `POST /lab-reports/{id}/extract`
- [ ] [S3] `ContextAgent` — scope ONE member; tools: `read_member_profile` `read_member_vitals` `read_member_episodes` `read_member_conditions`; output `MemberContext`
- [ ] [S3] Trace persistence: input hash (SHA-256), tools requested/allowed/denied, output, confidence, latency, tokens
- [ ] [ALL] **Scope freeze meeting.** Everything raised after this date goes to `docs/FUTURE_WORK.md` and receives zero lines of code

---

## W6 — Agents II (Sep 4 – 10) · 🚦 gate: full workflow runs end to end

- [ ] [S3] `AnalysisAgent` — tools `read_lab_trends` `compute_deviation`; output `AnalysisFindings`
- [ ] [S4] `FamilialRiskAgent` — scope FAMILY but **flags table only**; tools `read_consented_hereditary_flags` `read_relationship_graph` `lookup_inheritance_pattern`; raw-record tool **denied at dispatch**
- [ ] [S4] Exclude `is_biological = false` relationships from all hereditary reasoning
- [ ] [S4] Output `FamilialRiskSignal` with `unknownParties` — screening indication, never a diagnosis
- [ ] [S4] `SafetyValidationAgent` — **deterministic, no LLM**
- [ ] [S4] Rule tables: `RedFlagSymptoms` `PaediatricVitalRanges` `InheritancePatterns` `AllergyContraindications`
- [ ] [S4] Prohibited-content check: no diagnosis language, no drug names or dosing, no prescriptions, no meal plans
- [ ] [S4] Output JSON schema validation; retry once then safe failure
- [ ] [S4] Red flag → bypass queue → `ESCALATED` → doctor broadcast + emergency screen, **zero AI output shown**
- [ ] [S3] Full state machine wired: SUBMITTED → PLANNING → CONTEXT_READY → ANALYSED → RISK_ASSESSED → VALIDATED → PENDING_DOCTOR_REVIEW → …
- [ ] [S4] React Case Detail: member timeline, deviation flags, familial risk panel, draft advisory
- [ ] [S3] React Agent Trace Viewer — step-by-step, tools requested/denied, confidence, latency
- [ ] [S4] React Approval Panel — Approve / Revise+approve / Request info / Reject / Escalate
- [ ] [S4] Case assignment: primary doctor → 48 h grant, 6 h SLA → shared pool on timeout
- [ ] [S3] `FcmNotificationClient` — push on case status change, called only from the backend
- [ ] [S4] Flutter: Approved Guidance, Familial Risk & Screening, Emergency screen
- [ ] [S3] Flutter: Case Status Tracker (stepper matching the state machine), Notifications inbox

**Contingency if the gate is missed:** cut the **Familial Risk Agent** and ship 3 agents. Document as a deliberate scope reduction — three well-executed agents outscore four broken ones.

---

## W7 — Integration and quality (Sep 11 – 17)

- [ ] [ALL] Run the full cross-platform workflow unaided, end to end, from a clean database
- [ ] [S2] Camera lab upload verified on a **physical Android device**
- [ ] [S1] `AuthFlowTests` `ConsentEnforcementTests` (integration, Testcontainers PostgreSQL)
- [ ] [S2] `ExtractionAgentTests`
- [ ] [S3] `TriageWorkflowTests`
- [ ] [S4] `CaseGrantTests` `ToolDenialTests`
- [ ] [ALL] The 8 priority test cases (blueprint §14.5 / `docs/TESTING.md`) written and passing
- [ ] [ALL] React tests: reusable components, approval panel, guarded routes (Vitest + RTL)
- [ ] [ALL] Flutter widget tests: forms, status stepper, providers
- [ ] [S1] Security pass: no secrets committed, HTTPS enforced, no entity leakage, rate limiting on auth
- [ ] [S4] Emergency path tested end to end — confirm zero AI output reaches the patient
- [ ] [S3] Safe-failure path tested: kill Ollama mid-run, confirm the member sees only the referral message
- [ ] [ALL] Bug-fix pass; 80%+ coverage on own service layer

---

## W8 — Deploy and document (Sep 18 – 24) · 🚦 gate: deployed and reachable by evaluator

- [ ] [S1] Deploy the API (Render / Azure), HTTPS enforced, secrets in env only
- [ ] [S1] Provision PostgreSQL (Neon / Supabase); run migrations; seed synthetic data
- [ ] [S3] Deploy React to Vercel / Netlify
- [ ] [S2] Build and test the signed Flutter APK on a physical device
- [ ] [S3] Document Ollama hardware requirements in the deployment section
- [ ] [ALL] Create test credentials for all five roles and verify each one logs in on the deployed build
- [ ] [ALL] Finalise ADR-001 … ADR-009 in `docs/adr/`
- [ ] [ALL] Export the OpenAPI spec to `docs/api/openapi.yaml`
- [ ] [ALL] Write the consolidated report: technical 10–15p · testing 6–10p · agentic AI evaluation 5–8p · performance 3–5p · deployment 3–5p · ADRs 3–6p
- [ ] [ALL] Individual report sections + **personal reflection (never AI-generated)**
- [ ] [ALL] Finalise `docs/ai-disclosure/S<n>.md`
- [ ] [ALL] Record the 10-minute demonstration video

**Contingency if the gate is missed:** deploy backend + database + React as a minimum; ship Flutter as an APK only. Never skip deployment entirely.

---

## W9 — Freeze and viva (Sep 25 – 30)

- [ ] [ALL] **Code freeze Sep 26**
- [ ] [ALL] Rehearse the cross-platform demo ×5 with pre-seeded data
- [ ] [ALL] Mock viva ×2 — each member demos, explains, modifies and debugs their own component
- [ ] [ALL] Memorise blueprint §6.3 (agent comparison), §6.4 (tool permission matrix), §6.6 (genetics framing)
- [ ] [ALL] Drill the 17 viva questions in `docs/VIVA_PREP.md`
- [ ] [ALL] Verify deployed URLs daily (risk R6)
- [ ] [ALL] Final proofread of the consolidated PDF
- [ ] [S3 leader] **Submit through CourseWeb by 29 Sep** as `SE3090_SE016`
- [ ] [ALL] Keep all access live until **21 Oct 2026**

---

## Standing obligations (every member, every week)

- [ ] Unit tests for own service layer
- [ ] At least 2 pull request reviews per week
- [ ] Own ADR contributions
- [ ] Own individual report section, updated **every Sunday** (15 min) — never left to W8
- [ ] Own AI-use disclosure log, updated weekly
- [ ] `git pull origin develop` every morning before writing code
- [ ] Never commit on another member's behalf — it destroys the evidence individual marks depend on

## Weekly ritual

| When | Duration | What |
|---|---|---|
| Monday | 30 min | Each member: what shipped, what is blocked. Update the gate board. Reassign if anyone is behind |
| Thursday | 30 min | Integration check: does `main` still build and run? Merge outstanding PRs. Demo whatever exists |
| Sunday | 15 min (individual) | Update own AI-disclosure log and own report section |

## Blocked

None.

## Done

- [x] Blueprint written and reviewed (`docs/Family_Veda_Project_Blueprint.md`)
- [x] Repository converted from the universal agent template to a Family Veda workspace
- [x] Project docs, rules, skills and workflows scoped to the actual stack

## Last session

Repository restructured: template-only scaffolding removed; `agent/`, `docs/`, `rules/`, `skills/`, `workflows/` rewritten for Family Veda. No application code written yet — that starts at W2.

## Update rule

Update this file at task start, at each weekly gate, and at session end. Do not update for every tiny edit.
