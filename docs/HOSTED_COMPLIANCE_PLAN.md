# Family Veda — Hosted Compliance Plan

**Created:** 2026-09-18 · **Due:** 30 Sep 2026 11:50 PM · **Access period:** until 21 Oct 2026
**Inputs:** [`SPEC_COMPLIANCE_AUDIT.md`](SPEC_COMPLIANCE_AUDIT.md) · team fix plan (`FAMILY_VEDA_FULL_HOSTED_COMPLIANCE_FIX_PLAN.md`) · SE3090 Assignment 1 specification
**Tracking:** every task below is mirrored in [`agent/TODO.md`](../agent/TODO.md) section **H**.

## Goal

A **fully working hosted system** — not a demo-only build. Every evaluator-facing flow uses hosted services only:

```text
Flutter APK ─┐
             ├─> ASP.NET Core API (Render) ─┬─> PostgreSQL (Neon) — data, lab files, DP keys
React (Vercel)┘                             ├─> Groq (hosted LLM, llama-3.1-8b-instant)
                                            └─> Firebase FCM
```

Nothing required may depend on `localhost`, `10.0.2.2`, a laptop running Ollama, local files, or committed secrets.
Do **not** redesign UI, replace the database, change state management or rewrite the agent architecture.

## Decisions taken (2026-09-18)

| Decision | Choice | Record |
|---|---|---|
| Hosted inference | Groq free API, `llama-3.1-8b-instant`, OpenAI-compatible client behind `IOllamaClient` | ADR-012 (supersedes ADR-006) |
| Lab-report file storage | PostgreSQL `bytea` on Neon, 10 MB cap per file | ADR-010, DECISIONS |
| Data Protection keys | EF Core key store in PostgreSQL | ADR-010 |
| Swagger | Served on deployed API (`Swagger:Enabled`, default true) | PR #4 |
| Ownership | All work is built; each owner reviews/merges their component PRs from their own account | DECISIONS |

## Phases

Status: ☐ todo · ◐ in progress · ☑ done (only after hosted verification)

### Phase 1 — Hosted AI + Swagger (P0)
| Task | Owner | Status |
|---|---|---|
| `ChatCompletionsLlmClient` + `Llm__*` config + tests | S3 | ☑ code (PR #4) · ☐ hosted verify |
| Production Swagger | S1 | ☑ code (PR #4) · ☐ hosted verify |
| Web 60 s timeout, no refresh-retry on `/auth/*` | S1 | ☑ code (PR #4) |
| Groq key in Render dashboard; merge PR #4 | S4 (human) | ☐ |
| Keep-alive ping `/health` every 10 min (UptimeRobot / cron-job.org) | S1 (human) | ☐ |

### Phase 2 — Durable hosted persistence (P1, needs migration lock)
| Task | Owner | Status |
|---|---|---|
| Lab-report bytes in PostgreSQL (`LabReportFile` table), `ILabReportStorage` abstraction | S2 | ☐ |
| Data Protection keys persisted with `PersistKeysToDbContext` | S1 | ☐ |
| One migration `YYYYMMDD_ALL_AddDurableStorage`; announce lock | S2 + S1 | ☐ |
| Restart test: upload → redeploy → file still downloadable | S2 | ☐ |

### Phase 3 — Third-party service (P1)
| Task | Owner | Status |
|---|---|---|
| FCM `HttpClient` 10 s timeout; 4xx/5xx/invalid-token handled, never breaks clinical transaction | S3 | ☐ |
| Firebase project + `Fcm__ProjectId`, `Fcm__ServiceAccountJson` on Render | human | ☐ |
| `google-services.json` for release APK (not committed if it holds secrets) | human | ☐ |
| Startup config check: fail on missing DB/JWT/CORS/LLM; **warn only** on missing FCM | S1 | ☐ |

### Phase 4 — Functional-scope gaps (P1)
| Task | Owner | Status |
|---|---|---|
| Allow-listed `sortBy`/`sortDir` on records, cases, approvals, audit lists | S2 / S3 / S4 / S1 | ☐ |
| Sorting control in `ListToolbar` on Records + Cases pages | S2 / S3 | ☐ |
| Dashboard metrics from DB (cases by status/priority, awaiting review, avg completion) | S3 | ☐ |
| Explicit transaction: doctor decision + approval + audit | S4 | ☐ |
| Wrong login → 401 (web + Flutter never refresh-retry `/auth/*`) | S1 | ☐ |
| **S1 distinct agent** — Consent & Access Verification Agent (see open decision 6) | S1 | ☐ |

### Phase 5 — Testing evidence (P1)
| Task | Owner | Status |
|---|---|---|
| Agent golden-case test (plan shape, agents, allowed tools, schema, validator, approval required) | S3 | ☐ |
| Prompt-injection test (no tool widening, no cross-family data, gate not bypassed, attempt recorded) | S4 | ☐ |
| Safe-failure tests (timeout, invalid JSON, 429/500 → failed-safe, trace recorded) | S3 | ☐ |
| Transaction rollback integration test | S4 | ☐ |
| Authorization integration tests per component | S1 | ☐ |
| Sorting tests | S2 | ☐ |
| React: login validation, records sorting, cases/approval, apiClient tests | owners | ☐ |
| Flutter: navigation, API integration, case-status workflow tests | owners | ☐ |
| Playwright E2E against hosted web (`tests/e2e/`, manual `workflow_dispatch`) | S3 | ☐ |
| k6 performance (`tests/performance/`, manual dispatch; exclude or document auth 429s) | S1 | ☐ |

### Phase 6 — Release + CI (P1)
| Task | Owner | Status |
|---|---|---|
| CI release APK with `--dart-define=API_BASE_URL=https://family-veda-api.onrender.com/api/v1`, artifact `SE3090_SE016.apk` (debug-key signing is enough) | S2 | ☐ |
| `e2e.yml`, `performance.yml` (manual only) | S3 / S1 | ☐ |
| Install APK on a physical Android device; screenshot evidence | human | ☐ |

### Phase 7 — Documentation (P1/P2)
| Task | Owner | Status |
|---|---|---|
| ADR-010 deployment platform, ADR-011 workflow-state schema, ADR-012 hosted inference (drafted — owners must review and own the reasoning) | S1 / S3 / S3 | ◐ |
| ADR-006 marked Superseded | S3 | ◐ |
| Update DEPLOYMENT, ENV_VARS, ARCHITECTURE, AGENTS_DESIGN, README — remove "Ollama local" claims | owners | ☐ |
| Current ER diagram from migrations | S2 | ☐ |
| Per-member full-stack evidence table (backend/DB/React/Flutter/agent/tests per student) | all | ☐ |

### Phase 8 — Human-only submission work (P0 for marks)
- Each member commits and opens PRs from **their own account**; cross-reviews. No backdating, no fake commits.
- Each member fills `docs/ai-disclosure/S*.md` with real entries and writes their own reflection. AI must not write these.
- Consolidated PDF `SE3090_SE016_Report.pdf`, 10-min video, incognito link check, services live until 21 Oct.

## Timeline (12 days)

| Days | Focus |
|---|---|
| 18–20 Sep | Phase 1 verify, Phase 2, S1 agent decision |
| 21–24 Sep | Phases 3–5 |
| 25–27 Sep | Phase 6, Phase 7, device testing |
| 28–29 Sep | Report, video, reflections, rehearsal |
| 30 Sep | Incognito link check, submit |

Cut first if late: sorting on secondary lists, Playwright (keep manual E2E evidence), durable DP keys.

## Hosted acceptance checklist (tick only after proving on hosted system)

- [ ] Web opens in private browser · [ ] `/health` 200 · [ ] `/swagger` opens · [ ] login works after cold start
- [ ] Full triage workflow completes with Groq · [ ] traces + tool allow/deny visible · [ ] invalid model output fails safe
- [ ] Doctor approval required; guidance hidden before approval · [ ] FCM push received · [ ] FCM failure keeps case state
- [ ] Lab upload survives Render restart · [ ] release APK on physical device uses hosted API
- [ ] CI green · [ ] E2E + k6 + golden + injection evidence saved as artifacts
- [ ] Every member has own commits, PRs and reviews
