---
name: feature-development
description: Full feature implementation workflow — research, plan, TDD, review, commit.
allowed_tools: ["Bash", "Read", "Write", "Edit", "Grep", "Glob"]
---

# /feature-development

Use this workflow for implementing new features.

## Goal

Standard feature implementation workflow with research-first, TDD, and code review.

## Pipeline

1. **Research** — Search GitHub, docs, and package registries for existing solutions before writing code.
2. **Plan** — Use **planner** agent. Generate PRD, architecture, task list. Identify risks.
3. **TDD** — Use **tdd-guide** agent. Write tests first (RED), implement (GREEN), refactor (IMPROVE). Target 80%+ coverage.
4. **Implement** — Use **implementer** agent. Follow the plan. Many small files > few large files.
5. **Review** — Use **code-reviewer** agent. Address CRITICAL and HIGH issues.
6. **Security** — Use **security-reviewer** agent for auth, input, API, or sensitive data changes.
7. **Commit** — Conventional commits. Review diff before committing.

## Common Files

- `src/**`
- `**/*.test.*`
- `**/api/**`
- `agent/TODO.md`

## Typical Commit Signals

- Add feature implementation
- Add tests for feature
- Update documentation

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves.
