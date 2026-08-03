---
name: deployment-release
description: Use when deploying the API, database, React web app or Flutter APK, preparing the evaluator access package, verifying a deployed build, or rolling back. Fires on "deploy", "release", "APK", "hosting", "environment variables in production".
---

# Deployment and Release

Full detail: `docs/DEPLOYMENT.md`. Workflow: `workflows/deploy.md`. Gate: **W8 — deployed and reachable by the evaluator.**

Platforms are already chosen in principle (free tier: Render/Azure + Neon/Supabase + Vercel/Netlify). The pair is confirmed by **W7**. Deployment is a graded deliverable and is **never skipped**.

## Approval

Group leader (S3) plus S1. Deploying is a high-risk action — state the rollback before you start.

## Order

```
1. Provision the database
2. Apply migrations against it
3. Run the synthetic seed
4. Deploy the API           → verify /swagger + one authenticated endpoint
5. Deploy React             → verify login end to end
6. Build the signed APK     → install and test on a PHYSICAL Android device
7. Verify all five role credentials against the DEPLOYED stack
8. Record the URLs in the report and agent/DECISIONS.md
```

## Pre-deploy checklist

- [ ] CI green on `main`
- [ ] **History scanned for leaked secrets** — rotate anything ever exposed
- [ ] `.env` gitignored; no secret in any committed config
- [ ] Environment variables set in the platform, matching `docs/ENV_VARS.md`
- [ ] HTTPS enforced; HTTP redirects
- [ ] CORS restricted to the deployed web origin
- [ ] Rate limiting active on `/auth/*`
- [ ] Generic 500s — no stack traces in production
- [ ] Synthetic seed loaded, no real patient data anywhere

## Evaluator access package

- [ ] Deployed web URL
- [ ] API base URL + Swagger URL
- [ ] Repository link with evaluator access granted
- [ ] APK download link
- [ ] Test credentials for all five roles
- [ ] Reproducible local setup in `README.md`
- [ ] Access maintained until **21 October 2026**

Credentials and URLs go in the submitted report — **never in this repository**.

## The Ollama caveat — say it plainly

The deployed API cannot run the agent workflow without a reachable Ollama instance, and Ollama is not deployed. The demonstration runs it locally. This is a consequence of ADR-006, not an oversight. Never imply the hosted API performs live inference.

## Rollback

| Failure | Action |
|---|---|
| Bad API deploy | Redeploy the previous build from the host's history |
| Bad migration | Add a **new** corrective migration — never edit a pushed one |
| Web broken | Redeploy the previous Vercel/Netlify build |
| APK broken | Rebuild from the last green `main` commit |

## After deploying

Verify the deployed URLs **daily** through W9 (risk R6 — free tiers sleep). Keep a fully working local stack ready as a demo fallback. Do not delete projects, rotate evaluator credentials, or let a free-tier database be reclaimed for inactivity before 21 October 2026.
