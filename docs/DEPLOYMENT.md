# Deployment — Family Veda

Source: blueprint §15. Gate: **W8 — deployed and reachable by the evaluator.** Deployment is worth marks and is never skipped.

## Targets

| Component | Platform | Notes |
|---|---|---|
| ASP.NET Core API | Render / Azure App Service (free tier) | HTTPS enforced; secrets in environment variables, **never committed** |
| PostgreSQL | Neon / Supabase (free tier) | Connection string via environment only |
| React web | Vercel / Netlify | e.g. `familyveda.vercel.app` — no custom domain purchase needed |
| Flutter | Signed APK submitted with the report | Tested on at least one physical Android device |
| Ollama | **Local**, run during the demonstration | Hardware requirements documented in the deployment report |

Hosting pair (Render+Neon vs Azure+Supabase) is decided by **W7**, before the deploy gate. Record the decision in `agent/DECISIONS.md`.

## The Ollama caveat — state it plainly

The deployed API cannot run the agent workflow without a reachable Ollama instance, and Ollama is not deployed. The demonstration runs it locally on the demo machine.

This is a **consequence of ADR-006**, not an oversight: local inference was chosen for health-data residency, zero cost and offline demonstrability. The report says exactly this. Do not imply that the hosted API performs live inference.

## Evaluator access package (required)

- [ ] Deployed web URL
- [ ] API base URL + Swagger URL
- [ ] Repository link with evaluator access granted
- [ ] APK download link
- [ ] Test credentials for every role: Family Head · Member 18+ · Doctor (verified) · Doctor (pending) · Clinic Admin
- [ ] Reproducible local setup instructions in `README.md`
- [ ] Access maintained until **at least 21 October 2026**

Store the actual URLs and credentials in the submitted report — **not in this repository**.

## Pre-deployment checklist

- [ ] CI green on `main`
- [ ] No secrets in the repository history (`git log -p | grep` for keys before the first deploy)
- [ ] `.env` gitignored; `.env.example` contains names only
- [ ] Migrations applied to the hosted database
- [ ] Synthetic seed data loaded and verified
- [ ] HTTPS enforced; HTTP redirects
- [ ] CORS restricted to the deployed web origin
- [ ] Rate limiting active on `/auth/*`
- [ ] Swagger reachable and accurate
- [ ] Generic 500 responses — no stack traces in production
- [ ] Every role's test credentials verified against the **deployed** build, not localhost

## Deploy sequence

1. Provision the database. Note the connection string; set it as an environment variable on the API host.
2. Apply migrations against the hosted database (`dotnet ef database update` with the production connection string, run locally — never commit it).
3. Run the synthetic seed.
4. Deploy the API. Verify `/swagger` and one authenticated endpoint.
5. Set `VITE_API_BASE_URL` on the web host; deploy React. Verify login end to end.
6. Point the Flutter build at the deployed API base URL; build the signed APK; install and test on a physical device.
7. Verify all five role credentials on the deployed stack.
8. Record the URLs in the report and in `agent/DECISIONS.md`.

## Rollback

| Failure | Action |
|---|---|
| Bad API deploy | Redeploy the previous build from the host's deployment history |
| Bad migration | Add a **new** corrective migration — never edit or roll back a pushed one |
| Web deploy broken | Redeploy the previous Vercel/Netlify build |
| APK broken | Rebuild from the last green `main` commit |

## Free-tier risk (R6)

Free-tier hosting sleeps and occasionally fails.

Mitigation:
- Deploy in **W8**, not W9 — leave a week of margin.
- Verify the deployed URLs **daily** during W9.
- Keep a fully working local stack ready as a demo fallback.
- Warm the API before the demonstration starts.

## Post-submission obligations

Access must remain live until **21 October 2026**:

- Do not delete the hosting projects or the database.
- Do not rotate the evaluator's test credentials.
- Do not make the repository private or revoke evaluator access.
- Do not let the free-tier database be reclaimed for inactivity — check weekly.
