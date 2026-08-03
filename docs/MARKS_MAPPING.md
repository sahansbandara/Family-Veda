# Marks Mapping — Family Veda

100 marks, scaled to 25% of SE3090. **30 group + 70 individual.** Source: blueprint §19.

## Criteria

| Contribution | Criterion | Marks | Family Veda evidence |
|---|---|---:|---|
| Group | Component Design and Business Logic | 10 | 4 distinct business components; 3 status workflows; 5 roles; consent state machine |
| Group | Integrated Architecture, Agent Orchestration, State | 10 | Single backend/DB/identity; 4 distinct agents; persisted state; tool allow-list; approval gate; traces |
| Group | Documentation and Deployment | 10 | Consolidated report; 9 ADRs; deployed URLs; APK; reproducible setup; AI disclosure |
| Individual | ASP.NET Core REST API | 10 | Owned endpoints, DTOs, validation, async, status codes, exception handling |
| Individual | PostgreSQL and Data Modelling | 10 | Owned tables, FKs, constraints, indexes, migrations, seed data |
| Individual | React Web Application | 10 | Owned screens, reusable components, guards, states, validation |
| Individual | Flutter Mobile Application | 10 | Owned screens, widgets, routing, secure storage, device feature |
| Individual | Agentic AI Contribution | 12 | Owned agent(s), tools, state, validation, traces |
| Individual | API Integration, Security, Cross-Platform | 10 | Consent enforcement, case grants, audit, cross-platform workflow |
| Individual | Testing, CI and Git Workflow | 8 | Own tests, PR reviews, commit history, CI participation |
| | **Total** | **100** | |

## What each individual criterion actually asks

Every individual band reads *"the student can explain, test, modify, or debug"* their contribution. That is why the component allocation is by **business feature across all five technologies**, never by layer.

| Criterion | You must be able to, live |
|---|---|
| REST API | Open your controller in Swagger, call it, change a validator, explain a status code choice |
| Data modelling | Open your tables, explain a constraint and an index, write a migration |
| React | Open your screen, explain a guard, add a filter, show loading/empty/error states |
| Flutter | Open your screen, explain routing and secure storage, demo the device feature |
| Agentic AI | Open your agent, explain its scope and tools, show a trace, show a denial or a deterministic rule firing |
| Integration & security | Show consent enforcement or a grant check failing correctly, and the audit row it produced |
| Testing, CI & Git | Show your tests passing, your PR reviews, and `git log --author="<you>"` |

## Per-member evidence checklist

Fill this in as evidence accumulates. Each member owns their own row set.

### S1 — Samaranayaka (Family, Identity & Consent)

- [ ] Endpoints: `/auth/*` `/families/*` `/members/*` `/consents/*`
- [ ] Tables: `users` `families` `members` `relationships` `consents`
- [ ] React: Family Management, Consent Management, Login/Register
- [ ] Flutter: Register/login, family setup, member switcher
- [ ] Agentic: `ToolDispatcher` + `ToolRegistry` — allow-list enforcement, **denied call demonstrable live**
- [ ] Security: four authorisation layers, JWT policies, consent gate
- [ ] Testing/CI: `AuthFlowTests`, `ConsentEnforcementTests`, `ci.yml`

### S2 — Fernando (Health Records & Extraction)

- [ ] Endpoints: `/records/*` `/lab-reports/*` `/vitals/*` `/hereditary-flags`
- [ ] Tables: `health_records` `lab_reports` `lab_values` `vitals` `hereditary_flags`
- [ ] React: Record Browser, Lab Report Viewer, trend charts
- [ ] Flutter: **camera lab upload (device feature)**, record entry, vitals
- [ ] Agentic: Extraction Agent, OCR pipeline, Stage 1 isolation
- [ ] Integration: file storage, OCR failure path
- [ ] Testing: `ExtractionAgentTests`, seed data

### S3 — Karunathilaka (Triage & Orchestration) — Group Leader

- [ ] Endpoints: `/episodes/*` `/triage-cases/*` `/dashboard` `/notifications/*`
- [ ] Tables: `episodes` `triage_cases` `agent_traces`
- [ ] React: Family Dashboard, Case List, Agent Trace Viewer
- [ ] Flutter: complaint submission, status tracker, notifications
- [ ] Agentic: Coordinator + Context + Analysis Agents, trace persistence
- [ ] Integration: third-party notification service via the backend
- [ ] Testing: `TriageWorkflowTests`, safe-failure path

### S4 — Wasala (Familial Risk & Clinical Approval)

- [ ] Endpoints: `/doctors/*` `/admin/doctors/*` `/approve` `/familial-risk` `/audit`
- [ ] Tables: `doctors` `doctor_verification_log` `family_doctor_assignments` `case_access_grants` `approvals` `audit_log`
- [ ] React: Doctor Queue, Case Detail, **Approval Panel**, Verification Queue, Audit Viewer
- [ ] Flutter: risk view, screening recommendations, approved guidance, emergency screen
- [ ] Agentic: Familial Risk + Safety/Validation Agents, deterministic rule tables
- [ ] Security: case grants, audit strategy
- [ ] Testing: `CaseGrantTests`, `ToolDenialTests`

## Where marks are most easily lost

| Loss | Cause | Prevention |
|---|---|---|
| Agentic AI band drops to 2 | The system reads as a chatbot or disconnected prototype | Distinct agents, enforced allow-list, persisted state, approval gate, traces |
| Individual marks collapse for one member | They only built one layer | The allocation rule — one feature across five technologies |
| Documentation and deployment marks lost | Nothing deployed, or the report written in the last week | W8 gate; 15 minutes every Sunday from W1 |
| Testing marks lost | No own tests, no PR reviews, thin commit history | The 8 priority tests; 2 PR reviews per week; commit under your own account |
| Reflection scores zero | AI-generated | Write it yourself. The specification is explicit |
