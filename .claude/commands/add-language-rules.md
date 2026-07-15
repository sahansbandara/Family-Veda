---
name: add-language-rules
description: Add a new programming language to the rules system.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /add-language-rules

Add a new programming language to the rules system.

## Goal

Create language-specific rules covering coding style, hooks, patterns, security, and testing.

## Pipeline

1. Create `rules/{language}/` directory.
2. Add these files with language-specific content:
   - `coding-style.md` — naming, formatting, idioms
   - `hooks.md` — pre/post tool hooks relevant to the language
   - `patterns.md` — common design patterns
   - `security.md` — language-specific security concerns
   - `testing.md` — testing frameworks, conventions, coverage
3. Optionally add framework-specific files (e.g., `fastapi.md` for Python).
4. Update `CLAUDE.md` rules table to include the new language.

## Common Files

- `rules/*/coding-style.md`
- `rules/*/hooks.md`
- `rules/*/patterns.md`
- `rules/*/security.md`
- `rules/*/testing.md`

## Reference

Look at existing language rules (e.g., `rules/typescript/`, `rules/python/`) for format and depth.
