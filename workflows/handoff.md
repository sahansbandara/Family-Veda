# Workflow: Session Handoff

Run at the end of every working session.

## Update

| File | When |
|---|---|
| `agent/TODO.md` | Always — tick completed items, update "Current" and "Last session", move blocked items |
| `agent/MEMORY.md` | When something was learned that the next session would otherwise rediscover |
| `agent/DECISIONS.md` | When a decision was made — **including rejected alternatives**, at the moment it was made |
| `docs/changelog.md` | At a milestone, not per commit |
| `docs/ai-disclosure/S<n>.md` | Weekly, every Sunday |
| `docs/individual-reports/S<n>.md` | Weekly, every Sunday, 15 minutes |

## Report

- **What changed** — files, with owner tags
- **What works** — with the evidence (test output, screenshot, trace row)
- **What failed** — exact error text, not a paraphrase
- **What is blocked** — and on whom
- **Next task** — the specific next item in `agent/TODO.md`
- **Risks** — anything that moved a row in `docs/RISK_REGISTER.md`

## Do not

- Mark a task complete without verification, or without stating that verification was not possible.
- Leave a schema change with the migration lock still held.
- Leave uncommitted work on a shared file at the end of a session.
- Leave the individual report and disclosure log to Week 8 (risk R10).
