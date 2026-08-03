# Workflow: Deploy

Full detail and the evaluator access package: `docs/DEPLOYMENT.md`. Gate: **W8**.

**Deployment is a graded deliverable. It is never skipped.** Approval required from the group leader (S3) plus S1.

1. **Confirm approval** and that CI is green on `main`.
2. **Scan history for secrets** before the first deploy. Rotate anything ever leaked.
3. **Verify environment variable names** against `docs/ENV_VARS.md`. Values are set in the platform, never committed.
4. **Provision the database**, apply migrations against it, run the synthetic seed.
5. **Deploy the API.** Verify `/swagger` and one authenticated endpoint.
6. **Deploy React** with `VITE_API_BASE_URL` set. Verify login end to end.
7. **Build the signed APK** against the deployed API. Install and test on a **physical Android device**.
8. **Verify all five role credentials** against the deployed stack, not localhost.
9. **Record the URLs** in the report and in `agent/DECISIONS.md`.
10. **Document the rollback** before considering the deploy done.

## Rollback

| Failure | Action |
|---|---|
| Bad API deploy | Redeploy the previous build from the host's history |
| Bad migration | Add a **new** corrective migration — never edit or roll back a pushed one |
| Web broken | Redeploy the previous Vercel/Netlify build |
| APK broken | Rebuild from the last green `main` commit |

## The Ollama caveat

The deployed API cannot run the agent workflow without a reachable Ollama instance, and Ollama is **not deployed**. The demo runs it locally. State this plainly in the report — never imply the hosted API performs live inference.

## After deploying

- Verify the deployed URLs **daily** through W9 (risk R6).
- Keep everything live until **21 October 2026**: do not delete projects, rotate evaluator credentials, or let a free-tier database be reclaimed for inactivity.
