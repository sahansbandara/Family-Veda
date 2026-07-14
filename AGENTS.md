# Cross-Agent Operating Rules

These rules apply to Codex, Claude Code, Cursor, Antigravity, Gemini, ChatGPT Projects, and other agents.

## Required context

Read:

- `CLAUDE.md`
- `agent/BRIEF.md`
- `agent/TODO.md`
- `agent/MEMORY.md`
- `agent/DECISIONS.md`

## Before project setup

1. Run the grill gate when requirements are unclear.
2. Select tools using API-first routing.
3. Decide whether the project needs an LLM.
4. If needed, evaluate project-suitable LLM providers.
5. Define evaluator and success criteria.
6. Define permissions and approval.
7. Decide whether sandbox execution is required.
8. Switch to `PROJECT_MODE` only when setup is complete.

## Tool policy

Before using a tool:

- Confirm it is necessary.
- Prefer Direct API → MCP → browser automation → Computer Use.
- Use least privilege.
- Define expected output.
- Define failure and fallback behavior.
- Do not store credentials in Markdown.

## LLM policy

- Do not use one model for every project.
- Use `skills/llm-provider-selector/SKILL.md`.
- Treat free quotas as temporary.
- Verify provider documentation.
- Benchmark project-specific candidates.
- Define primary and fallback.
- Do not send sensitive data to an unacceptable free tier.

## Evaluation policy

- Define hard failures.
- Define passing score.
- Bound revision loops.
- Use independent review for high-risk work.
- Do not claim verification without evidence.

## Change control

Ask approval before deleting, overwriting major files, changing lock files, changing deployment or security settings, committing, pushing, deploying, changing production data, publishing publicly, executing trades, or sending payments.

## Memory rules

Update memory only for meaningful project knowledge, bugs and fixes, reusable patterns, dependency notes, environment issues, and session handoff.

Never store secrets or sensitive personal data.

## Conflict priority

1. Latest explicit user instruction
2. Project-specific files
3. Safety, security, and permission rules
4. Selected skills
5. Generic template rules

Document important conflicts in `agent/DECISIONS.md`.

## Automation rule

Do not schedule or enable unattended workflows before the manual version is reliable and `skills/automation-readiness/SKILL.md` passes.
