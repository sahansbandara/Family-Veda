# Start Here

This folder is a reusable project-start agent template.

## Correct workflow

1. Copy the template into a new project.
2. Explain the project idea.
3. Send the instruction below.
4. Let the agent grill weak assumptions.
5. Let it select stack, tools, LLM provider if required, evaluation rules, permissions, and sandbox policy.
6. Confirm `CLAUDE.md` changes from `TEMPLATE_MODE` to `PROJECT_MODE`.
7. Start implementation with the development methodology.
8. Automate only after the manual workflow succeeds.

## First instruction

```text
Read PROJECT_SETUP_AGENT_PROMPT.md. Run the pre-project grill, select the project tools, decide whether an LLM is required, evaluate suitable free LLM APIs when relevant, define evaluation and approval rules, then customize the template. Do not write application code until CLAUDE.md is switched from TEMPLATE_MODE to PROJECT_MODE.
```

## Before meaningful implementation

```text
Use skills/development-methodology/SKILL.md. Plan first, implement in small verified steps, evaluate the result, and request approval before high-risk actions.
```

## Hard rules

- No application code in `TEMPLATE_MODE`.
- No secrets in Markdown.
- No high-risk action without approval.
- No “best free LLM” recommendation without current verification and project-specific testing.
- No scheduled automation before manual success.
