---
name: feature-development
description: Full feature implementation workflow for Family Veda — ownership check, plan, TDD, implement, review, security, commit.
allowed_tools: ["Bash", "Read", "Write", "Edit", "Grep", "Glob"]
---

# /feature-development

Implement one feature slice end to end. Take the next item from `agent/TODO.md`.

## Pipeline

0. **Preflight** — run `rules/common/agent-preflight.md`. Report the preflight line.
1. **Ownership check** — is every file you will touch tagged for this member, or `⚠ SHARED`? If it belongs to someone else, stop and ask.
2. **Skill check** — invoke the matching skill before acting: `agentic-triage` (agents) · `clinical-safety` (anything patient-facing) · `database-api` (schema or contract) · `frontend-design` (UI).
3. **Plan** — `planner` agent for anything spanning more than one layer. Name the risks and the phases.
4. **TDD** — `tdd-guide` agent. RED → GREEN → REFACTOR. 80%+ coverage on your own service layer.
5. **Implement** — `implementer` agent. Smallest change that passes the test. Many small files over few large.
6. **Review** — `code-reviewer` agent. Fix CRITICAL and HIGH before merge.
7. **Security** — `security-reviewer` agent for anything touching auth, consent, grants, user input, endpoints, agent tools, or audit.
8. **Commit** — `workflows/commit.md`. Conventional commit with your owner scope: `feat(s3): …`.
9. **PR** — into `develop`, 1 approving review, green CI.

## Remember

- A feature slice spans **API + DB + React + Flutter + agent** where applicable — that is the allocation rule, and the individual marks depend on it.
- Loading, empty, error and success states are part of the slice, not a follow-up.
- Search, filter, sort and pagination are part of any list view.
- Schema change → take the migration lock first.
- After the W5 scope freeze, new features go to `docs/FUTURE_WORK.md`, not into code.

## Files typically touched

`backend/src/**` · `web/src/**` · `mobile/lib/**` · `backend/tests/**` · `agent/TODO.md` · the relevant `docs/*.md`
