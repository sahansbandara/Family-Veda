# Universal Agent Skill Pack Template v2

A project-neutral starter template for AI-assisted coding, business planning, content systems, AI/ML projects, Telegram automation, trading content workflows, academic work, and reusable prompt engineering.

## Why this exists

Most AI project templates fail because they are too opinionated. They assume one stack, one design style, and one agent. This template is different:

- Project-neutral by default
- Skill-based instead of one giant instruction file
- Safe for Codex, Claude Code, Cursor, Antigravity, Gemini, and ChatGPT Projects
- Designed to be customized before coding starts
- Keeps useful memory, TODO, decisions, and brief files

## Setup workflow

1. Fill `agent/BRIEF.md`
2. Ask the agent to run `workflows/new-project.md`
3. Agent selects stack and relevant skills
4. Agent updates `CLAUDE.md`, `design.md`, `agent/TODO.md`, and `agent/DECISIONS.md`
5. Agent switches `TEMPLATE_MODE` to `PROJECT_MODE`
6. Start building
7. Test
8. Deploy

## Important safety rules

- Do not store secrets in memory files.
- Do not copy leaked prompts verbatim.
- Do not delete or overwrite major files without approval.
- Project-specific rules override generic skills.
- If a rule conflicts, stop and document the conflict in `agent/DECISIONS.md`.

## First-run prompt

The full first-run instruction is saved in:

```text
PROJECT_SETUP_AGENT_PROMPT.md
```

Use it after explaining the project idea to the agent.

## Grill + Superpowers workflow

This template includes two built-in gates:

| Gate | File | Use |
|---|---|---|
| Pre-project grill | `skills/grill-project/SKILL.md` | Challenge the idea before setup finalization |
| Development methodology | `skills/development-methodology/SKILL.md` | Plan, implement, test, review after PROJECT_MODE |

Use this before every project:

```text
Read PROJECT_SETUP_AGENT_PROMPT.md. First run the pre-project grill gate using skills/grill-project/SKILL.md, then customize the template. Do not write app code until CLAUDE.md is switched from TEMPLATE_MODE to PROJECT_MODE.
```

Use this after setup:

```text
Use skills/development-methodology/SKILL.md before implementing this feature. Plan first, then build in small verified steps.
```
