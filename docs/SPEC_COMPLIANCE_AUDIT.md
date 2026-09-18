# SE3090 Assignment 1 — Specification Compliance Audit

**Audited:** 2026-09-18 · **Against:** *SEF Assignment 1 Specification and Marking Scheme* (17 pages) · **Due:** 30 Sep 2026, 11:50 PM

Status key: ✅ met · 🟡 partly met / evidence missing · ❌ not met

Evidence tags: [Certain] = verified by command or live request today · [Likely] = inferred from file names/structure, not run.

---

## Summary — the blockers first

| # | Blocker | Spec section | Severity |
|---|---|---|---|
| 1 | **Agentic AI cannot run on the deployed system** — Ollama not hosted. Spec §16/§17.1 says the agentic subsystem *must be executed during the demonstration*. "We won't show it" is not an option. | §9, §14, §16, §17.1 | ❌ CRITICAL |
| 2 | **Git history shows only 2 authors** (ImSahanS 27 commits, Jani6969 2). S2 and S4 have no commits; 3 PRs total. Individual marks (70/100) are adjusted from Git history. | §3, §13, rubric "Testing, CI and Git" | ❌ CRITICAL |
| 3 | **Swagger disabled in production** — `/swagger` returns 401 on Render. Spec §14 requires a working Swagger URL. | §5, §14 | ❌ HIGH |
| 4 | **AI usage logs empty** — `docs/ai-disclosure/S1–S4.md` are blank templates; declarations unsigned. | §18.3 | ❌ HIGH |
| 5 | **No performance test and no automated end-to-end test.** | §12 | ❌ HIGH |
| 6 | Individual reports contain 17–30 placeholders each; reflections must be written by each member personally. | §15, §18.3 | 🟡 HIGH |
| 7 | APK not confirmed built/signed; physical Android device verification not done. | §8, §14, §15 | 🟡 HIGH |
| 8 | Demo video (10 min) not recorded. | §15 | 🟡 |
| 9 | No ADR for **cloud deployment platform** or **agent workflow-state schema** (both named as minimum ADR topics). | §14.2 | 🟡 MEDIUM |

---

## §1 Assignment Overview — integrated system

✅ One ASP.NET Core API, one PostgreSQL DB, one React app, one Flutter app. Both clients use `https://family-veda-api.onrender.com/api/v1` [Certain — web bundle and `mobile/lib/config/app_config.dart`].

## §2 Required Technology Stack

| Area | Our project | Status |
|---|---|---|
| Backend | ASP.NET Core 8 Web API (`backend/src/Api`) | ✅ |
| Data access | EF Core 8 + Npgsql, 6 migrations in `Infrastructure/Persistence/Migrations` | ✅ |
| Database | PostgreSQL 16 on Neon | ✅ |
| Web | React 18 + Vite + React Router + Redux Toolkit (ADR-004) | ✅ |
| Mobile | Flutter + Riverpod + go_router (ADR-005) | ✅ |
| Agentic AI | Custom orchestration in C# (`TriageOrchestrator`, `ToolRegistry`, `ToolDispatcher`) + Ollama (ADR-006) | ✅ design / ❌ deployment |
| Version control | GitHub + `.github/workflows/ci.yml` | ✅ |
| Testing | xUnit, Vitest, flutter_test — no performance tooling | 🟡 |

Mandatory backend rule: agents are in-process behind ASP.NET Core; clients never call Ollama or FCM. ✅

## §3 Group Structure and Individual Contribution

| Student | Component | Agent | Status |
|---|---|---|---|
| S1 Samaranayaka | Family, Identity & Consent (`FamiliesController`, `MembersController`, `AuthController`) | Tool-permission layer (`ToolDispatcher`) | 🟡 — "distinct agentic contribution" is a dispatch layer, not an agent; be ready to defend it |
| S2 Fernando | Health Records & Extraction (`RecordsController`, 13 endpoints) | Extraction Agent | ✅ code / ❌ no commits by S2 |
| S3 Karunathilaka | Triage & Orchestration (`TriageController`, 14 endpoints) | Coordinator, Context, Analysis | ✅ code |
| S4 Wasala | Familial Risk & Clinical Approval (`ClinicalController`, 18 endpoints) | Familial Risk, Safety/Validation | ✅ code / ❌ no commits by S4 |

❌ **Contribution evidence is the biggest risk.** Spec: "artificial commit activity, final-day bulk uploads … will not be accepted". Every member must commit their own component work from their own account, open their own PRs and review others' PRs. Nobody may commit on someone else's behalf.

## §4 Domain and Functional Scope

| Requirement | Our project | Status |
|---|---|---|
| ≥ 3 roles | Family head, adult member, doctor, admin (+ minor member family role) | ✅ |
| ≥ 4 components, business-specific ops | 4 components; e.g. consent state machine, case-grant issuing, OCR extraction review, triage orchestration, doctor approval gate | ✅ |
| CRUD + status workflows | Triage status enum, consent status, OCR status | ✅ |
| Search / filter / pagination | `PageSize` and search present in services | ✅ [Likely] |
| Sorting | `OrderBy` fixed server-side; no user-selectable sort param found | 🟡 add `sortBy`/`sortDir` to at least one list endpoint per component |
| Reporting / analytics | Dashboard page exists | 🟡 [Likely] — confirm an actual report/analytics view per component |
| Different purposes for React vs Flutter | React = doctor/admin workspace; Flutter = family members, complaint submission, lab upload, emergency | ✅ |
| ≥ 1 third-party service | FCM push via `FcmPushNotificationClient` | 🟡 code exists; Firebase not configured in prod, push "deferred" |
| One cross-platform workflow | Flutter submit complaint → API → DB → agents → React doctor approval → Flutter approved guidance | ✅ design / ❌ agent step not runnable when deployed |

## §5 Part 1 — ASP.NET Core Backend

| Area | Status |
|---|---|
| Controllers, DTOs, service layer, DI | ✅ Api / Application / Infrastructure split |
| REST routes, status codes, async | ✅ RFC 7807 via `ExceptionMiddleware` |
| JWT, role auth, password hashing | ✅ `PasswordHasher`, `[Authorize]`, rate limiter on auth |
| Validation, global errors, logging, CORS | ✅ FluentValidation, middleware, CORS verified live |
| **Swagger/OpenAPI** | ❌ only enabled in Development (`Program.cs:119`) — enable in Production (read-only docs, no secrets) |
| Agent endpoints: start, status, approve, summaries | ✅ Triage + Clinical controllers [Likely] |
| ≥ 4 endpoints per component | ✅ 4+7+9 / 13 / 14 / 18 |

Note: wrong login returns **403** "Access is denied" (`AuthService.cs:53`). Conventionally 401; UI message is generic. Minor.

## §6 Part 2 — PostgreSQL

✅ Normalised schema, FKs, constraints, concurrency tokens, EF migrations, seed (disabled in prod).
🟡 ER diagram — confirm an up-to-date image exists in `docs/diagrams`.
🟡 Transactions — relies on implicit `SaveChanges` transactions; add one explicit transaction (e.g. approval + audit write) and a test for it.
✅ Agent state persisted in `Domain/Triage/TriageEntities.cs`; no passwords/tokens in plain text.

## §7 Part 3 — React Web

✅ Functional components, hooks, router, Redux Toolkit, protected routes, role navigation, loading/empty/error states (`ViewState`).
✅ Approve/reject/revise on `ApprovalsPage`.
🟡 Only **5 test files** — add form-validation, API-integration and error-state tests (§12).
🟡 Default API timeout 15 s < Render cold start (~35 s) → first login after idle can fail. Raise to 60 s.

## §8 Part 4 — Flutter Mobile

✅ Riverpod, go_router, `flutter_secure_storage`, login/logout, protected screens, forms, status tracking, history.
✅ Device feature: camera / image_picker for lab report upload; FCM notifications.
✅ Agentic task submission (`submit_complaint_screen`) and status (`case_status_screen`).
🟡 13 test files — check coverage of navigation + API-integration tests.
❌ Signed release APK not yet produced/verified on a physical Android device.

## §9 Part 5 — Agentic AI

| Requirement | Our implementation | Status |
|---|---|---|
| Objective → structured plan | `TriageOrchestrator` (Coordinator) | ✅ |
| ≥ 4 distinct agents | Extraction, Context, Analysis, Familial Risk, Safety/Validation (+ Coordinator) | ✅ |
| Allow-listed tools, validated IO | `ToolRegistry` + `ToolDispatcher`, tests exist | ✅ |
| Persisted shared state | Triage entities | ✅ |
| Deterministic validation | `SafetyValidationService`, rule tables (ADR-007) | ✅ |
| Human approval | Doctor approval gate | ✅ |
| Observability | Agent traces / audit log | ✅ [Likely] — make sure a UI shows tool calls, timings, retries |
| Security: timeouts, retries, safe failure | `OllamaClient` timeout + single retry | ✅ |
| **Runs reliably during evaluation** | ❌ Ollama unreachable from Render |

## §10 Integrated Architecture

✅ Matches the reference diagram. ❌ End-to-end evidence cannot be produced on the live system until Ollama is reachable.

## §11 Third-Party Integration

🟡 FCM client exists with backend-only access. Need: Firebase project + service-account secret on Render, timeout/failure handling evidence, and a demonstrated push. If Firebase stays unconfigured, this criterion is not demonstrable.

## §12 Testing

| Area | Status |
|---|---|
| Backend unit | ✅ 19 unit test classes |
| Backend API/integration | 🟡 2 integration test files — add auth/authz + controller tests per component |
| Database (Testcontainers, constraints, migrations, transactions) | 🟡 `MigrationTests` only |
| React | 🟡 5 tests |
| Flutter | 🟡 13 tests |
| **End-to-end** | ❌ none |
| **Performance** (concurrency, response time, AI latency) | ❌ none — add a k6 or NBomber script + results table |
| Agent evaluation (golden case, injection, safe failure) | 🟡 schema/emergency/recovery tests exist; add one golden-case end-to-end eval and a prompt-injection test |

## §13 Git, CI/CD

✅ CI restores, builds and tests backend, web and mobile on push/PR to `main`/`develop`.
❌ Contribution evidence (see §3). Issues and project board — confirm they exist on GitHub.

## §14 Deployment and Documentation

| Component | Required | Current | Status |
|---|---|---|---|
| API | cloud + health + Swagger URL | Render, `/health` 200 [Certain] | 🟡 Swagger missing |
| PostgreSQL | secure, migrations | Neon, migrate-on-startup | ✅ |
| React | live URL on deployed API | `family-veda-web.vercel.app` [Certain] | ✅ |
| Flutter | APK | not verified | ❌ |
| Agentic AI | deploy or run locally, setup + startup order | not reachable from deployed API | ❌ |

Also: Render free sleeps (~35 s cold start). Render uploads and data-protection keys are **ephemeral** — uploaded lab reports vanish on restart.

§14.1 README: ✅ mostly present (setup, env vars, live URLs). Check test accounts listed (without passwords in the repo — give them in the report).
§14.2 ADRs: ✅ React state (004), Flutter state (005), agent framework (006/007). ❌ Add **ADR-010 Cloud deployment platform** and **ADR-011 Agent workflow-state schema**.

## §15 Submission

❌ Consolidated PDF, demo video, APK, signed declarations — not done. Name everything `SE3090_SE016`. Keep all services live until **21 Oct 2026**.

## §16 / §17 Evaluation and Demo

Demo checklist status:
- ✅ Login with different roles
- 🟡 CRUD + business workflow + DB changes + **Swagger** (Swagger missing)
- ✅ React and Flutter on the same API
- ❌ **Run the agentic subsystem** end-to-end (Ollama)
- ✅ Human approval + execution history (once agents run)
- 🟡 Tests, passing CI, deployed apps, **GitHub contribution history** (weak)

## §18 / §19 AI Usage and Integrity

❌ Per-member AI logs are empty. Each member fills their own log (date, tool, model, task, output, what was changed, verification) and writes their own one-page reflection. AI must not write reflections — reflections that don't match Git history get no credit.

## §20 Final Checklist

| Item | Status |
|---|---|
| 4 components | ✅ |
| API + PostgreSQL working | ✅ |
| JWT + roles | ✅ |
| React + Flutter via shared API | ✅ |
| ≥ 4 agents, controlled tools, state | ✅ code |
| Validation, observability, approval | ✅ |
| Third-party integration | 🟡 |
| Testing incl. agent eval + performance | ❌ |
| CI builds and tests | ✅ |
| ADRs | 🟡 (2 missing topics) |
| React, API, DB deployed; APK | 🟡 |
| Consolidated report | ❌ |
| Git contribution for every member | ❌ |
| AI declared, no secrets committed | 🟡 |
| Demo/viva without AI | pending |
| Contribution statements, logs, reflections | ❌ |

---

## Action plan (12 days left)

| Priority | Task | Owner |
|---|---|---|
| P0 | Host Ollama (HF Space or Oracle free VM, `llama3.2:3b`), add auth header to `OllamaClient`, set `Ollama__BaseUrl` on Render, amend ADR-006 | S3 |
| P0 | Each member commits own work from own GitHub account; PRs + cross-reviews | All |
| P0 | Enable Swagger in Production | S1 (API host config) |
| P1 | Configure Firebase on Render; demonstrate one push | S3 / owner of notifications |
| P1 | Performance test (k6) + results; one E2E test; golden-case agent eval + injection test | S3 / S4 |
| P1 | Build signed release APK; verify on Android device | All |
| P1 | Fill AI logs; write individual reflections (personally) | Each member |
| P2 | ADR-010 deployment platform, ADR-011 workflow-state schema | S1 / S3 |
| P2 | User-selectable sorting on list endpoints; raise web timeout to 60 s | Component owners |
| P2 | Consolidated PDF, demo video, incognito link check | Group leader S3 |
