# Workflow: Build

1. **Preflight.** Run `rules/common/agent-preflight.md`. Report the preflight line.
2. **Check ownership.** Is this file tagged for you? If `⚠ SHARED`, use the labelled-block convention. If it belongs to another member, stop and ask.
3. **Read context.** `agent/TODO.md` for the current week's tasks; the rules matching the layer you are touching.
4. **Invoke the matching skill.** `agentic-triage` for agent work · `clinical-safety` for anything patient-facing · `database-api` for schema or contract work.
5. **Migration lock.** If the change touches the schema, confirm the lock is free and announce it *before* generating anything.
6. **Write the failing test first** (`rules/common/testing.md`).
7. **Implement the smallest useful unit** — the smallest slice that makes the test pass, not the whole feature.
8. **UI work:** loading, empty, error and success states are part of the unit, not a follow-up.
9. **Verify.** Run the tests. Paste the output.
10. **Update `agent/TODO.md`** at the milestone, not after every edit.

## Layer commands

```bash
cd backend && dotnet build
```

```bash
cd web && npm run build
```

```bash
cd mobile && flutter analyze
```

## Stop and ask before

Editing another member's file · generating a migration · adding a dependency · restructuring a shared file · anything that would break a clinical safety rule.
