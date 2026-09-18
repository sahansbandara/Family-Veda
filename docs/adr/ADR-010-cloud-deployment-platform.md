# ADR-010 — Cloud deployment platform

**Owner:** S1 · **Status:** Proposed (AI-drafted 2026-09-18 — owner must review, edit and accept) · **Date:** 2026-09-18

## Context

SE3090 §14 requires a deployed API with working health and Swagger URLs, a deployed PostgreSQL database with migrations, a live React URL using the deployed API, and an APK. §14 also requires no-cost services. The team decided on 2026-09-18 that the evaluated system must be fully hosted — no laptop, `localhost` or emulator URL in any required flow — and must stay reachable until 21 Oct 2026.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| **Render (API, Docker) + Neon (PostgreSQL 16) + Vercel (React)** (chosen) | Already live since 2026-08-04; all free; Blueprint (`render.yaml`) is reproducible; Neon branching; Vercel SPA hosting with env-var build config | Render free sleeps after idle (~35 s cold start), 512 MB RAM, no persistent disk; Neon free 0.5 GB |
| Azure App Service + Azure Database for PostgreSQL | First-class .NET hosting; student credit | Credit expires; more setup; PostgreSQL flexible server is not free after credit |
| Railway | Simple multi-service deploys, persistent volumes | No permanent free tier; usage billing |
| Fly.io | Volumes, close to users | Card required; free allowance removed for new orgs |

## Decision

Keep **Render + Neon + Vercel**. Compensate for the free-tier limits in the application:

- Lab-report files and ASP.NET Data Protection keys are stored in PostgreSQL, not the container filesystem.
- React API timeout is 60 s; a keep-alive ping hits `/health` every 10 minutes during the evaluation window.
- Agent inference runs on a hosted API (ADR-012) because 512 MB cannot hold a local model.
- Secrets live only in provider dashboards (`sync: false` in `render.yaml`); Vercel holds only `VITE_API_BASE_URL`.

## Consequences

**Makes easy:** zero cost; evaluator URLs already exist; redeploy on merge to `main`.

**Makes hard:** cold starts; in-process background workers pause while the service sleeps (queued triage resumes on wake — covered by `TriageWorkerRecoveryTests`); total upload volume bounded by Neon free storage.

**Rules out:** relying on the container filesystem for anything that must survive a restart.

## Status

Proposed. Accept after S1 review and hosted verification of `/health` and `/swagger`.
