# Universal Agent Project Template

A project-neutral starter template for AI-assisted development with battle-tested agents, rules, skills, and workflows. Enhanced with production-grade code review, security analysis, TDD enforcement, and multi-language support.

## Why this exists

Most AI project templates fail because they are too opinionated. They assume one stack, one design style, and one agent. This template is different:

- **Project-neutral** — no stack assumptions until you choose
- **Skill-based** — modular skills instead of one giant instruction file
- **Multi-agent** — 11 specialized agents with cost-optimized model routing
- **Quality-enforced** — code review, security review, and TDD built into the workflow
- **Multi-language** — rules for TypeScript, Python, Go, Rust, React, Vue, Swift, React Native
- **Cross-platform** — works with Claude Code, Codex, Cursor, Antigravity, Gemini, and others
- **Gated workflow** — forces you to grill assumptions, select tools, and plan before coding

## What's included

### Agents (`.claude/agents/`)

| Agent | Model | Purpose |
|---|---|---|
| `worker` | Haiku/Sonnet | File reads, grep, single edits |
| `researcher` | Sonnet | Code search, doc lookup, web research |
| `implementer` | Sonnet | Feature implementation, bug fixes |
| `code-reviewer` | Sonnet | Confidence-filtered code quality review |
| `security-reviewer` | Sonnet | OWASP Top 10, secrets, vulnerability detection |
| `tdd-guide` | Sonnet | Test-driven development (RED → GREEN → REFACTOR) |
| `build-error-resolver` | Sonnet | Fix build/type errors with minimal diffs |
| `architect` | Opus | System design, scalability, ADRs |
| `doc-updater` | Haiku | Documentation and codemap generation |
| `planner` | Opus | Implementation planning, tradeoff analysis |
| `performance-optimizer` | Sonnet | Bottleneck analysis, profiling, optimization |

### Rules (`rules/`)

| Directory | Scope |
|---|---|
| `common/` | Security, testing, code review, coding style, git workflow, performance, patterns |
| `typescript/` | TypeScript/JavaScript coding style, patterns, security, testing |
| `python/` | Python coding style, FastAPI, patterns, security, testing |
| `golang/` | Go coding style, patterns, security, testing |
| `rust/` | Rust coding style, patterns, security, testing |
| `react/` | React patterns, hooks, security, testing |
| `react-native/` | React Native with accessibility, performance, production readiness |
| `swift/` | Swift/iOS coding style, patterns, security, testing |
| `vue/` | Vue.js coding style, patterns, security, testing |
| `framework/` | Next.js, Java Spring, vanilla JS |

### Skills (`skills/`)

25+ skills covering project start, tool selection, LLM selection, web data acquisition, security, database/API, deployment, automation readiness, code quality, AI/ML, prompt engineering, and more.

### Commands (`.claude/commands/`)

| Command | Purpose |
|---|---|
| `/feature-development` | Full pipeline: research → plan → TDD → implement → review → commit |
| `/database-migration` | Schema changes with migration files and rollback |
| `/add-language-rules` | Add a new programming language to the rules system |

### Workflows (`workflows/`)

16 workflows covering new project setup, pre-project grill, build, test, deploy, commit, audit, handoff, and more.

## Setup workflow

1. Fill `agent/BRIEF.md` with your project idea
2. Ask the agent to run `workflows/new-project.md`
3. Agent grills assumptions, selects stack and skills
4. Agent updates `CLAUDE.md`, `design.md`, `agent/TODO.md`, and `agent/DECISIONS.md`
5. Agent switches `TEMPLATE_MODE` to `PROJECT_MODE`
6. Start building with `/feature-development`

## Development workflow

Once in `PROJECT_MODE`, every feature follows this pipeline:

1. **Research** — search GitHub, docs, registries for existing solutions
2. **Plan** — use `planner` agent for implementation plan
3. **TDD** — use `tdd-guide` agent (write tests first, 80%+ coverage)
4. **Implement** — use `implementer` agent
5. **Review** — use `code-reviewer` agent (confidence-filtered, severity-leveled)
6. **Security** — use `security-reviewer` agent for auth/input/API changes
7. **Commit** — conventional commits, reviewed diff

## Coding preflight

Before any agent writes code, it runs `rules/common/agent-preflight.md` — three efficiency/discipline systems, each degrading gracefully if not installed:

| System | Purpose |
|---|---|
| **superpowers** (mandatory) | Skill discipline — checks for and invokes a matching skill (brainstorming, TDD, debugging) before acting |
| **headroom** | Context compression — 15–20% fewer tokens for coding, 60–95% for JSON/data |
| **caveman** | Optional terse output mode (~75% fewer output tokens) — never on committed code, commits, PRs, or security warnings |

A missing plugin is noted, never a hard-fail. Agents report `Preflight: superpowers=[…] · headroom=[on|absent] · caveman=[on|off]` before coding.

## Project gates

Before coding starts, the template enforces:

1. Grill unclear assumptions
2. Define user, problem, workflow, and MVP
3. Select stack
4. Select tools (API-first routing)
5. Select LLM only when needed
6. Define evaluator and success criteria
7. Define permissions and approval model
8. Decide sandbox requirement
9. Select backend and deployment platforms

## Safety rules

- No secrets in Markdown or memory files
- No high-risk action without approval
- No platform selection without project fit
- Prompt defense baseline on all agents
- Input validation at all system boundaries
- Security review mandatory for auth, input, API, and sensitive data changes
- Project-specific rules override generic template rules

## First-run prompt

```text
Read PROJECT_SETUP_AGENT_PROMPT.md. First run the pre-project grill gate
using skills/grill-project/SKILL.md, then customize the template.
Do not write app code until CLAUDE.md is switched from TEMPLATE_MODE to PROJECT_MODE.
```

## Credits

Agent definitions, common rules, and language-specific rules adapted from [ECC (Extended Claude Configuration)](https://github.com/affaan-m/ECC) — the agent harness performance optimization system. Project gates, skill router, model routing, and workflow system are original to this template.
