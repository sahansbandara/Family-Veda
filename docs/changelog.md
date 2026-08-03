# Changelog — Family Veda

Format: reverse chronological. One entry per meaningful milestone, not per commit.

## Unreleased

### 2026-08-04 — Workspace converted to the Family Veda project

- Removed universal-agent-template scaffolding: bootstrap prompts, template manifest, duplicated `claude/skills` tree, `.gemini/` config, examples, benchmarks and generic templates.
- Removed off-stack rules (Python, Go, Rust, Vue, Swift, React Native, framework) and off-domain skills (crawling, LLM provider selection, sandbox, automation, trading/Telegram content, AI-ML builder).
- Rewrote `CLAUDE.md` (`TEMPLATE_MODE` → **`PROJECT_MODE`**), `AGENTS.md`, `README.md`, `design.md`.
- Rewrote `agent/BRIEF.md`, `agent/TODO.md`, `agent/MEMORY.md`, `agent/DECISIONS.md` against the blueprint.
- Added project documentation: `DATABASE.md`, `API_CONTRACT.md`, `AGENTS_DESIGN.md`, `CLINICAL_SAFETY.md`, `TESTING.md`, `DEPLOYMENT.md`, `TIMELINE.md`, `RISK_REGISTER.md`, `VIVA_PREP.md`, `FUTURE_WORK.md`, `MARKS_MAPPING.md`, `DELIVERABLES.md`.
- Added `docs/adr/` (ADR-001 … ADR-009), `docs/ai-disclosure/`, `docs/individual-reports/`, `docs/diagrams/`, `docs/api/`.
- Added project skills: `agentic-triage`, `clinical-safety`, `viva-prep`.
- Added `.github/workflows/ci.yml` and `.github/pull_request_template.md`.
- Added `backend/`, `web/`, `mobile/` scaffold READMEs describing the agreed structure.

No application code written. Implementation begins at the W2 skeleton gate.

### 2026-07-31 — Blueprint frozen

- `docs/Family_Veda_Project_Blueprint.md` v1.0 written and reviewed. Scope frozen; component allocation proposed for W1 confirmation.
