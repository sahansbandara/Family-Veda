# Cross-Agent Operating Rules

These rules apply to Codex, Claude Code, Cursor, Antigravity, Gemini, ChatGPT Projects, and other agents.

## Thinking methodology (mandatory)

All agents MUST follow `rules/common/thinking-methodology.md` as their cognitive framework. This applies to every response, every task.

Core enforcement:
- Infer goals, not just execute methods
- Break work into testable pieces; verify each before moving on
- Identify the kill-component and double-verify it
- Tag uncertainty: [Certain], [Likely], [Possible], [Guessing]
- Self-attack conclusions before delivering
- Answer first, reasoning second, risks last
- Never guess when the answer will be acted on without verification

## Coding preflight (mandatory before any code)

Every code agent runs `rules/common/agent-preflight.md` before writing/editing code:

1. **superpowers** (MANDATORY) — check for and invoke a matching skill before acting (brainstorming/debugging first, then implementation). Fallback: `skills/development-methodology/SKILL.md`.
2. **headroom** — compress heavy context/data/tool-output. Note if absent, continue.
3. **caveman** — optional terse output; never on committed code, commits, PRs, or security warnings.

Report before coding: `Preflight: superpowers=[…] · headroom=[on|absent] · caveman=[on|off]`. Missing plugin = noted, not a hard-fail.

## Required context

Read:

- `rules/common/thinking-methodology.md` (load first)
- `rules/common/agent-preflight.md`
- `CLAUDE.md`
- `agent/BRIEF.md`
- `agent/TODO.md`
- `agent/MEMORY.md`
- `agent/DECISIONS.md`

## Available agents

| Agent | Purpose | Model | When to use |
|---|---|---|---|
| `worker` | File reads, grep, single edits | Haiku/Sonnet | Fully specified, no judgment needed |
| `researcher` | Code search, doc lookup, web research | Sonnet | "Where is X", "what does Y do" |
| `implementer` | Feature implementation, bug fixes | Sonnet | Clear spec or plan exists |
| `code-reviewer` | Code quality, patterns, best practices | Sonnet | After writing/modifying code |
| `security-reviewer` | OWASP Top 10, secrets, vulnerabilities | Sonnet | Auth, user input, API endpoints, sensitive data |
| `tdd-guide` | Test-driven development | Sonnet | New features, bug fixes — write tests first |
| `build-error-resolver` | Fix build/type errors | Sonnet | Build fails — minimal diffs only |
| `architect` | System design, scalability, ADRs | Opus | Architectural decisions, tradeoffs |
| `doc-updater` | Documentation, codemaps | Haiku | Updating docs, generating codemaps |
| `planner` | Implementation planning, decisions | Opus | Ambiguous requirements, complex features |
| `performance-optimizer` | Bottleneck analysis, profiling | Sonnet | Performance issues, optimization |

### Immediate agent usage (no user prompt needed)

1. Complex feature requests → **planner**
2. Code just written/modified → **code-reviewer**
3. Bug fix or new feature → **tdd-guide**
4. Architectural decision → **architect**
5. Build fails → **build-error-resolver**
6. Security-sensitive code → **security-reviewer**

### Parallel execution

ALWAYS use parallel agent execution for independent operations:

```
# GOOD: Parallel
Agent(security-reviewer): "Security analysis of auth module"
Agent(code-reviewer): "Quality review of cache system"
Agent(tdd-guide): "Write tests for new utilities"

# BAD: Sequential when unnecessary
First security, then quality, then tests
```

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

## Code quality gates

### Before any commit

- [ ] `code-reviewer` agent run — no CRITICAL or HIGH issues
- [ ] `security-reviewer` agent run for auth/input/API changes
- [ ] Tests passing with 80%+ coverage
- [ ] No hardcoded secrets
- [ ] No console.log/debug statements

### Review severity levels

| Level | Meaning | Action |
|---|---|---|
| CRITICAL | Security vulnerability or data loss | **BLOCK** — must fix |
| HIGH | Bug or significant quality issue | **WARN** — should fix |
| MEDIUM | Maintainability concern | **INFO** — consider |
| LOW | Style or minor suggestion | **NOTE** — optional |

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
