---
name: template-readiness
description: Pre-project checklist verifying agents, skills, MCPs, git, model routing, and parallel dispatch are properly configured before starting work.
user-invocable: true
---

# Template Readiness Check

## When to use

Run before starting any new project from this template. Validates infrastructure is wired correctly.

## Checklist

### 1. Agent definitions
- [ ] `.claude/agents/worker.md` exists — Sonnet, low effort
- [ ] `.claude/agents/researcher.md` exists — Sonnet, medium effort
- [ ] `.claude/agents/implementer.md` exists — Sonnet, medium effort
- [ ] `.claude/agents/reviewer.md` exists — Sonnet, medium effort
- [ ] `.claude/agents/tester.md` exists — Sonnet, medium effort
- [ ] `.claude/agents/planner.md` exists — Opus, high effort

### 2. Skills discovery
- [ ] `.claude/skills/` symlink or directory exists
- [ ] Skills match skill router table in CLAUDE.md
- [ ] Each skill has valid frontmatter (name, description)

### 3. Settings
- [ ] `.claude/settings.json` exists with permissions
- [ ] Read-only commands pre-allowed (ls, find, grep, git status/log/diff)
- [ ] Agent dispatch allowed

### 4. Git integration
- [ ] Git initialized (`git status` succeeds)
- [ ] `.gitignore` excludes secrets, build artifacts, local settings
- [ ] Branch is `main`

### 5. Model routing
- [ ] CLAUDE.md contains model routing section
- [ ] Dispatch rules table present
- [ ] Parallel subagent patterns documented

### 6. Skill auto-invocation
- [ ] CLAUDE.md skill router table present
- [ ] Skills match between CLAUDE.md table and `skills/` directory
- [ ] Boot sequence reads required files

### 7. Project brain files
- [ ] `agent/BRIEF.md` exists
- [ ] `agent/TODO.md` exists
- [ ] `agent/MEMORY.md` exists
- [ ] `agent/DECISIONS.md` exists
- [ ] `design.md` exists

### 8. Rules and workflows
- [ ] `rules/` directory has rule files
- [ ] `workflows/` directory has workflow files

## Verification commands

```bash
# Check agents
ls .claude/agents/

# Check skills wired
ls .claude/skills/

# Check git
git status

# Check settings
cat .claude/settings.json

# Check CLAUDE.md has routing
grep -c "Model routing" CLAUDE.md
```

## Output

Report pass/fail per section. Flag missing or misconfigured items. Do not proceed to PROJECT_MODE until all checks pass.
