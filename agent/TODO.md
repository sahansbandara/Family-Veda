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
- [x] Flutter analyze/tests: 27 passing
- [x] Docker build and PostgreSQL-backed runtime health/Swagger/Tesseract checks
- [ ] 80% service-layer coverage — current coverage tooling hangs under the local .NET 10 SDK and React aggregate coverage is below target; expand tests and rerun under CI/.NET 8
- [ ] Android APK/device verification — Android SDK and physical device unavailable locally
- [ ] Physical iPhone verification — connect the iPhone, select an Apple signing team and add the local Firebase iOS configuration
- [ ] Live Ollama workflow/latency — Ollama/model unavailable locally
- [ ] Live FCM push/device deep-link — Firebase configuration and device unavailable

## Deployment state and blockers

- [x] Neon CLI authenticated; organization `Sahan` and project `SLIIT Project` are accessible
- [x] Render CLI authenticated; workspace `SLIIT` is selected
- [x] Vercel CLI authenticated; team `Sithmi` is accessible
- [x] Provision separate Neon PostgreSQL 16 production project and apply all six existing EF Core migrations
- [ ] Add payment information to Render workspace — blueprint validation returns `need_payment_info`
- [ ] Create the Family Veda Render service and Vercel project
- [ ] Configure production database URL, JWT key, frontend origin/API URL, persistent storage and Data Protection path in provider dashboards
- [ ] Provide a reachable user-controlled Ollama endpoint; hosted LLM APIs are prohibited by ADR-006
- [ ] Configure Firebase service account/project if push delivery is required
- [x] Verify production migration state independently with `dotnet ef migrations list`
- [ ] Run deployed health, role-flow and log verification

Never place production secrets in this file or chat.

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
