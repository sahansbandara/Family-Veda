# Project Brain — Universal Agent Template

STATUS: TEMPLATE_MODE

## Boot sequence

Read:

1. `agent/BRIEF.md`
2. `agent/TODO.md`
3. `agent/MEMORY.md`
4. `agent/DECISIONS.md`
5. `design.md`
6. Relevant skills, rules, workflows, and docs

Report:

- Mode
- Goal
- Stack
- Active workflow
- Selected skills
- Selected tools/platforms
- Next action

## Project gates

1. Grill unclear assumptions.
2. Define user, problem, workflow, and MVP.
3. Select stack.
4. Select tools through `tool-router`.
5. Use `web-data-acquisition` when crawling or browser interaction is required.
6. Select an LLM only when required.
7. Define evaluator.
8. Define permissions.
9. Decide sandbox requirement.
10. Select backend and deployment platforms.
11. Switch to `PROJECT_MODE` only when setup is complete.
12. Use `development-methodology` for meaningful implementation.
13. Automate only after manual success.

## Platform rules

- Crawl4AI is the preferred crawler for multi-page extraction, RAG ingestion, and LLM-ready Markdown.
- Browser Use is reserved for authorized interactive workflows, forms, dynamic pages, and browser QA.
- Coolify is an optional self-hosted deployment candidate for Docker-based persistent services.
- Supabase is an optional backend candidate when PostgreSQL, auth, realtime, storage, or generated APIs fit.
- Do not install or choose any platform merely because it appears in this template.
- Record selected and rejected alternatives in `agent/DECISIONS.md`.

## Skill router

| Task | Skill |
|---|---|
| Start project | `skills/project-start/SKILL.md` |
| Challenge assumptions | `skills/grill-project/SKILL.md` |
| Session control | `skills/core-agent/SKILL.md` |
| Select tools | `skills/tool-router/SKILL.md` |
| Web crawling/browser workflow | `skills/web-data-acquisition/SKILL.md` |
| Select LLM | `skills/llm-provider-selector/SKILL.md` |
| Evaluate output | `skills/output-evaluator/SKILL.md` |
| Approval/risk | `skills/approval-gate/SKILL.md` |
| Sandbox | `skills/sandbox-execution/SKILL.md` |
| Development workflow | `skills/development-methodology/SKILL.md` |
| Database/API/backend | `skills/database-api/SKILL.md` |
| Deployment/release | `skills/deployment-release/SKILL.md` |
| Automation readiness | `skills/automation-readiness/SKILL.md` |
| Template readiness check | `skills/template-readiness/SKILL.md` |
| Other domain tasks | Select relevant existing skill |

## Universal rules

- API → MCP → specialized automation → Computer Use.
- Use least privilege.
- No secrets in Markdown.
- No high-risk action without approval.
- No crawling that bypasses access controls.
- No platform selection without project fit.
- Project-specific instructions override generic options.
- Safety and permissions override convenience.

## Current selections

- Stack: UNSELECTED
- Web-data tool: UNSELECTED
- Backend: UNSELECTED
- Deployment: UNSELECTED
- LLM: UNSELECTED
- Evaluator: UNSELECTED
- Approval model: UNSELECTED

## Model routing — cost optimization

Use cheaper subagents for routine work. Reserve main model for planning and decisions.

### Agent dispatch rules

| Task type | Agent | Model | When to use |
|---|---|---|---|
| File reads, grep, single edits | `worker` | Sonnet (low effort) | Fully specified, no judgment needed |
| Code search, doc lookup, web research | `researcher` | Sonnet (medium) | "Where is X", "what does Y do", lookup questions |
| Feature implementation, bug fixes | `implementer` | Sonnet (medium) | Clear spec or plan exists, multi-file coding |
| Code review, diff analysis | `reviewer` | Sonnet (medium) | Review changes before commit/PR |
| Write and run tests | `tester` | Sonnet (medium) | After implementation, before merge |
| Architecture, planning, decisions | `planner` | Opus (high) | Ambiguous requirements, tradeoff analysis |

### Dispatch behavior

- Main model (Opus/Fable) handles: planning, skill selection, user interaction, final review, decisions
- Subagents handle: execution, lookup, testing, review
- Parallel dispatch: when tasks are independent, spawn multiple agents simultaneously
- Always include file paths and clear instructions when dispatching — subagents start cold

### When NOT to delegate

- User asks a direct question (answer inline)
- Single-line change (do it yourself)
- Security-sensitive decisions (handle in main model)
- Ambiguous requirements (clarify first, then delegate)

### Parallel subagent patterns

```
# Fan-out: research + implement + test simultaneously
Agent(researcher): "Find all uses of X in src/"
Agent(implementer): "Add Y to file A following pattern in file B"  
Agent(tester): "Write tests for Z covering edge cases"

# Pipeline: plan → implement → review
Agent(planner): "Design approach for feature X"
→ Agent(implementer): "Implement plan from planner"
→ Agent(reviewer): "Review the implementation"
```

### Skill auto-invocation

Skills MUST fire automatically when matched. The main model checks skill router table on every user message and invokes matching skills before acting. No skill is optional when its trigger matches.

## Git integration

- Initialize git at project start: `git init`
- Commit at meaningful checkpoints, not after every file change
- Use conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`
- Review diff before commit (dispatch to `reviewer` agent)
- Never commit secrets, .env files, or credentials
- Branch for features: `feat/feature-name`

## Completion report

1. Changed
2. Files
3. Tools/platforms
4. Checks
5. Evaluation
6. Approval status
7. Risks
8. Next task
