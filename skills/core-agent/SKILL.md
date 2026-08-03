---
name: core-agent
description: Use at the start of every session in this repository — boot sequence, ownership check, safe file changes, memory updates and handoff. Fires on session start, "where were we", "what's next", "resume", and before any first edit of a session.
---

# Core Agent — Family Veda session control

## Boot

Read, in order:

1. `rules/common/thinking-methodology.md`
2. `rules/common/agent-preflight.md`
3. `agent/BRIEF.md` — what this project is
4. `agent/TODO.md` — what is next, and which weekly gate is live
5. `agent/MEMORY.md` — what we already know and must not repeat
6. `agent/DECISIONS.md` — what is already decided
7. `design.md` — if the task touches UI
8. The rules and docs matching the component being touched

`docs/Family_Veda_Project_Blueprint.md` is the source of truth for anything the summaries do not answer.

## Report after boot

```
Mode:          PROJECT_MODE
Week / gate:   W_ — <gate>
Component:     <name> [S_]
Active task:   <item from agent/TODO.md>
Skills:        <invoked>
Preflight:     superpowers=[…] · headroom=[on|absent] · caveman=[on|off]
Next action:   <one line>
```

## Working rules

1. **Check ownership before editing.** `[S1]`–`[S4]` are sole owners. `⚠ SHARED` files use the labelled-block convention. Another member's file → stop and ask.
2. **Invoke the matching skill first.** `agentic-triage` · `clinical-safety` · `database-api` · `code-quality` · `security-privacy` · `frontend-design` · `viva-prep`.
3. **Smallest safe change.** Test first, then implement.
4. **Run the checks and paste the output.** Never claim green without evidence.
5. **Update `agent/TODO.md` at milestones**, not per edit.
6. **Record decisions in `agent/DECISIONS.md` at the moment they are made**, including rejected alternatives.

## Stop conditions — ask before

Deleting or overwriting a file · generating an EF Core migration · adding a dependency · committing or pushing · deploying · changing security or deployment settings · editing another member's file · anything that would break one of the ten clinical safety rules.

## Never

- Commit on another member's behalf.
- Claim a test passed without the output.
- Put a secret in a Markdown file, a seed, or a commit.
- Put real patient data anywhere.
- Add a feature after the W5 scope freeze — it goes to `docs/FUTURE_WORK.md`.

## Handoff

Run `workflows/handoff.md` at session end: what changed, what works (with evidence), what failed (exact error), what is blocked, next task, risks moved.
