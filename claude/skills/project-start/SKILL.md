---
name: project-start
description: Convert a rough idea into a complete, evaluated, permission-aware project setup before coding.
user-invocable: true
---

# Project Start

## When to use

Use after copying the universal template and before any application code is written.

## Inputs to check

- User's project idea
- `agent/BRIEF.md`
- Users and main workflow
- Project constraints
- Deployment preference
- Data sensitivity
- Deadline
- Design requirements

## Required setup sequence

1. Read core project files.
2. Run `grill-project` when requirements are unclear.
3. Define project type, user, problem, main flow, and MVP.
4. Select stack.
5. Use `tool-router` to select external tools.
6. Decide whether an LLM API is required.
7. If required, use `llm-provider-selector`.
8. Define evaluator and success criteria.
9. Define permission and approval matrix.
10. Decide sandbox requirement.
11. Create first milestone and TODO.
12. Record architecture decisions.
13. Switch to `PROJECT_MODE` only when ready.

## Multi-agent rule

Default to:

```text
One primary agent + one evaluator + human approval for high-risk actions
```

Use specialist agents only when tasks are meaningfully separable and the quality benefit exceeds coordination cost.

## Output format

```text
PROJECT SETUP:
- Project type:
- Goal:
- Main user:
- MVP:
- Stack:
- Tools:
- LLM required:
- Primary/fallback model:
- Evaluator:
- Approval model:
- Sandbox:
- First milestone:
- First tasks:
- Open questions:
- Ready for PROJECT_MODE: yes/no
```

## Quality checklist

- [ ] Main workflow clear
- [ ] MVP narrowed
- [ ] Stack justified
- [ ] Tools selected
- [ ] LLM decision completed if relevant
- [ ] Evaluator defined
- [ ] Approval boundaries defined
- [ ] Sandbox decision defined
- [ ] First tasks are buildable
- [ ] No secrets stored
- [ ] PROJECT_MODE enabled only when ready

## Stop conditions

Stop before coding. Stop if required architecture decisions remain unresolved. Ask only the minimum necessary question and include a recommended answer.
