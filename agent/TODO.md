# TODO — Family Veda

Status reconciled against the repository on 2026-08-04. This file separates implemented code from work that requires people, devices, citations, provider accounts, or production credentials.

## Implemented code

- [x] .NET 8 layered API, PostgreSQL 16 model, 21 tables, EF Core migrations and startup migration option
- [x] JWT registration/login/refresh/logout, single-use refresh concurrency, role policies and RFC 7807 errors
- [x] Family onboarding, linked head profile, minor management, adult privacy, relationships and consent/reaffirmation
- [x] Records CRUD, vitals/trends, lab upload, Tesseract extraction, retryable OCR state and manual review/confirmation
- [x] Unconfirmed OCR values and hereditary flags excluded from every agent tool
- [x] Episodes, asynchronous triage queue, interrupted-work recovery above queue capacity and safe-failure handling
- [x] Emergency gate before LLM, de-identified doctor claim pool and patient emergency route
- [x] Context, Analysis and Familial Risk agents through local Ollama with structured schema validation and one retry
- [x] Per-agent tool allow-list, hard denial/audit and raw-record denial for familial reasoning
- [x] Biological-direct-relation and active-consent enforcement for hereditary flags
- [x] Deterministic safety validation, prohibited-content gate and exact patient-guidance allow-list
- [x] Conservative rule-table interfaces; uncited paediatric/allergy tables fail closed to clinician review
- [x] Verified-doctor registration/status, admin verification, case grants, shared pool, claim concurrency and approval gate
- [x] Emergency, failed-safe and overdue-SLA deterministic referral behavior
- [x] Adult/minor notification privacy, active-grant doctor notification and notification-token protection
- [x] React family/doctor/admin workspace with public registration, onboarding, records/vitals/lab review, relationships/consent, queues, approvals and audit
- [x] Flutter patient app with secure auth, member switching, records, record/vital entry, lab upload, complaint submission, case tracking, emergency, notifications and approved-only guidance
- [x] Flutter iOS scaffold with camera/photo permissions, iOS 15 minimum, push capability, CocoaPods lock and correct `IOS` device-token registration
- [x] Render/Neon/Vercel manifests, Docker image, CI workflow and exported OpenAPI
- [x] Synthetic family-of-four seed; disabled by default
- [x] Backend unit/integration, React and Flutter test suites

## Local verification gates

- [x] Backend Release build: 0 warnings, 0 errors
- [x] Backend unit tests: 56 passing
- [x] PostgreSQL integration tests: 5 passing
- [x] EF pending-model check: clean
- [x] React lint/build/tests: 17 passing
- [x] Flutter analyze/tests: 46 passing; touched auth/storage service coverage 93%+
- [x] Docker build and PostgreSQL-backed runtime health/Swagger/Tesseract checks
- [ ] 80% service-layer coverage — current coverage tooling hangs under the local .NET 10 SDK and React aggregate coverage is below target; expand tests and rerun under CI/.NET 8
- [x] Android SDK/API 36, debug APK, emulator install and login-screen launch verified locally
- [ ] Physical Android device verification — device still required for assignment evidence
- [ ] Physical iPhone verification — connect the iPhone, select an Apple signing team and add the local Firebase iOS configuration
- [ ] Live Ollama workflow/latency — Ollama/model unavailable locally
- [ ] Live FCM push/device deep-link — Firebase configuration and device unavailable

## Deployment state and blockers

- [x] Neon CLI authenticated; organization `Sahan` and project `SLIIT Project` are accessible
- [x] Render CLI authenticated; workspace `SLIIT` is selected
- [x] Vercel CLI authenticated; team `Sithmi` is accessible
- [x] Provision separate Neon PostgreSQL 16 production project and apply all six existing EF Core migrations
- [x] Render service `family-veda-api` (free) and Vercel project `family-veda-web` live since 2026-08-04
- [ ] Configure production database URL, JWT key, frontend origin/API URL, persistent storage and Data Protection path in provider dashboards
- [ ] ~~Provide a reachable Ollama endpoint~~ — superseded 2026-09-18 by hosted Groq inference (ADR-012); see section H
- [ ] Configure Firebase service account/project if push delivery is required
- [x] Verify production migration state independently with `dotnet ef migrations list`
- [ ] Run deployed health, role-flow and log verification

Never place production secrets in this file or chat.

## H. Hosted compliance (added 2026-09-18)

Full plan: `docs/HOSTED_COMPLIANCE_PLAN.md`. Audit: `docs/SPEC_COMPLIANCE_AUDIT.md`. Tick only after hosted verification.

### H1 Hosted AI + Swagger (P0)
- [x] [S3] `ChatCompletionsLlmClient` (Groq, OpenAI-compatible) behind `IOllamaClient`, `Llm__*` config, 3 unit tests — PR #4
- [x] [S1] Swagger served on deployed API — PR #4
- [x] [S1] Web API timeout 60 s; no refresh-retry on `/auth/*` — PR #4
- [ ] [human] Groq key → Render `Llm__ApiKey`; set `Llm__Provider=openai-compatible`; merge PR #4 after cross-review
- [ ] [human] Keep-alive ping on `/health` every 10 min
- [ ] Verify `/swagger` and one full triage case on hosted system

### H2 Durable persistence (P1 — take migration lock)
- [x] [S2] Lab-report bytes stored in PostgreSQL (`lab_report_files`), 10 MB cap — PR #5
- [x] [S1] Data Protection keys persisted in PostgreSQL (`DataProtection__PersistToDatabase`) — PR #5
- [x] [S2+S1] Migration `20260918_ALL_AddDurableStorage` — PR #5 (take migration lock before merge)
- [ ] [S2] Upload survives Render restart (evidence)

### H3 Third-party (P1)
- [ ] [S3] FCM client timeout + failure handling; push failure never breaks clinical state
- [ ] [human] Firebase project + `Fcm__ProjectId` / `Fcm__ServiceAccountJson` on Render
- [ ] [S1] Startup config validation (fail: DB/JWT/CORS/LLM; warn: FCM)

### H4 Functional scope (P1)
- [ ] [S2/S3/S4/S1] Allow-listed `sortBy`/`sortDir` on records, cases, approvals, audit
- [ ] [S2/S3] Sort controls in React `ListToolbar`
- [ ] [S3] DB-derived dashboard analytics
- [ ] [S4] Explicit transaction: decision + approval + audit
- [ ] [S1] Wrong login → 401; Flutter skips refresh on `/auth/*`
- [ ] [S1] Distinct S1 agent (open decision 6)

### H5 Tests (P1)
- [ ] [S3] Agent golden case · [ ] [S3] safe-failure (timeout/invalid JSON/429/500)
- [ ] [S4] Prompt-injection test · [ ] [S4] transaction rollback integration test
- [ ] [S1] Authorization integration tests · [ ] [S2] sorting tests
- [ ] React tests: login validation, records sorting, cases/approval, apiClient
- [ ] Flutter tests: navigation, API integration, case-status workflow
- [ ] [S3] Playwright E2E on hosted web · [ ] [S1] k6 performance (manual dispatch)

### H6 Release + CI (P1)
- [ ] [S2] CI release APK with hosted `API_BASE_URL`, artifact `SE3090_SE016.apk`
- [ ] [S3/S1] `e2e.yml`, `performance.yml` manual workflows
- [ ] [human] Physical Android install + screenshots

### H7 Docs (P1/P2)
- [ ] ADR-010/011/012 drafted as Proposed — owners review and accept
- [ ] ADR-006 Superseded
- [ ] DEPLOYMENT / ENV_VARS / ARCHITECTURE / AGENTS_DESIGN / README hosted-only
- [ ] ER diagram regenerated from current migrations
- [ ] Per-member full-stack evidence table

## Human/course work — cannot be completed by a coding agent

- [ ] Confirm four-member allocation and collect each member's own commits/PR reviews
- [ ] Complete group meetings, charter, weekly AI disclosure entries and individual report sections
- [ ] Each member writes their own personal reflection and signature; AI must never generate these
- [ ] Supply authoritative clinician-approved paediatric, allergy and inheritance citations before populating clinical thresholds
- [ ] Validate synthetic lab layouts and physical-device camera flow
- [ ] Complete consolidated report, diagrams/screenshots, manual test log and deployment evidence
- [ ] Record demonstration video, rehearse viva, freeze, submit through CourseWeb and keep deployments live through the required date

## Deliberate MVP boundaries

- Adult family users maintain independent accounts and join through a one-time, email-bound, 48-hour invitation token.
- OCR is assistive and cannot enter agent context until explicit manual confirmation.
- Uncited paediatric/allergy rules do not guess; they return clinician-review-required.
- Patient familial-risk output is a deterministic approved screening instruction, never raw agent JSON or diagnosis.
