# Individual Reports

**70 of 100 marks are individual.** These sections are compiled into the single consolidated PDF alongside the group report — not submitted separately.

## Required structure per member

Each `S<n>.md` covers seven criteria, mirroring the individual mark scheme:

| § | Section | Marks | What the examiner looks for |
|---|---|---:|---|
| 1 | ASP.NET Core REST API | 10 | Your endpoints, DTOs, validation, async signatures, status codes, exception handling |
| 2 | PostgreSQL and data modelling | 10 | Your tables, FKs, constraints, indexes, migrations, seed contribution |
| 3 | React web application | 10 | Your screens, reusable components, route guards, states, client validation |
| 4 | Flutter mobile application | 10 | Your screens, widgets, routing, secure storage, device feature |
| 5 | Agentic AI contribution | 12 | Your agent(s) or agent-infrastructure, tools, state, validation, traces |
| 6 | API integration, security, cross-platform | 10 | Consent enforcement, case grants, audit, your part of the cross-platform workflow |
| 7 | Testing, CI and Git workflow | 8 | Your tests, coverage, PR reviews, commit history |
| 8 | **Personal reflection** | — | **Written by you, never AI-generated** |
| 9 | Component map and flows | — | Owner-tagged diagrams of your own component — supporting evidence for §1–§6 |
| 10 | Daily push plan | — | Your day-by-day commit schedule, 10 Aug → 29 Sep 2026 — supporting evidence for §7 |

Sections 1–8 are the mark scheme. Sections 9–10 are working sections: §9 is what you show the examiner, §10 is what produces the history the examiner checks.

## Writing rules

1. **Start in W1. Fifteen minutes every Sunday.** A report written in Week 8 reads like one.
2. **Show evidence, not claims.** File paths, endpoint names, screenshots, `git log --author="<you>"` output, test results with coverage figures.
3. **Write about your own work only.** Describing a teammate's component does not earn your marks.
4. **S1 specifically:** state explicitly that your agentic contribution is the tool-permission enforcement layer that every agent depends on, plus the CI pipeline. Without that sentence the examiner may read §5 as empty.
5. **The reflection is never AI-generated.** The specification states it receives no credit. Write about what was hard, what you got wrong, what you would do differently — that is what the section is for.

## §9 — Component map and flows

Each `S<n>.md` §9 carries three or four Mermaid diagrams of that member's own component. GitHub renders Mermaid inline, so these stay reviewable in the repository and export cleanly for the report.

1. **Ownership map** — clients → your endpoints → your services → your tables, with every node tagged by owner. This diagram is the one-page answer to "what did you build".
2. **Your central flow** — a sequence or pipeline diagram of the thing you own end to end.
3. **Your state machine or boundary** — consent (S1), the stage 1/stage 2 split (S2), the triage case lifecycle (S3), the approval gate and doctor verification (S4).

Rules: tag every node `S1`–`S4` (`docs/diagrams/README.md` rule 1) · keep diagrams consistent with the blueprint · export SVG **and** keep the `.mmd` source · no real patient data.

## §10 — Daily push plan

Each `S<n>.md` §10 is a day-by-day table from **Mon 10 Aug to Tue 29 Sep 2026**, aligned to the week gates in `docs/TIMELINE.md`. Every row names the exact files to stage and the exact conventional-commit message.

| Rule | Why |
|---|---|
| **Commit under your own git identity, on your own branch, every working day** | §7 is marked from `git log --author="<you>"`. A history with no commits from you is an unmarkable §7, whatever the code shows |
| **Never commit on another member's behalf** | It deletes the evidence their individual marks depend on — CLAUDE.md, binding |
| **Work already merged as group-authored commits stays group-authored** | Do not rewrite or re-attribute existing history to manufacture a per-member trail. The daily plan governs work from 10 Aug forward; the honest record is the one the examiner can trust |
| **Saturday = review + merge · Sunday = report + disclosure** | Mirrors the weekly ritual in `docs/TIMELINE.md` |
| **Announce the migration lock before any `dotnet ef migrations add`** | Two simultaneous migrations break the repository |
| **`⚠ SHARED` files: your labelled block only** | Never reorder or reformat another member's block |

Check yourself weekly:

```bash
git log --author="<your name>" --since="8 weeks ago" --oneline | wc -l
```

## Reflection prompts (answer in your own words)

- What was the hardest technical problem you personally solved, and how?
- What did you get wrong first, and what changed your mind?
- Which decision would you make differently with hindsight?
- What did working across five technologies teach you that working in one would not have?
- What did you learn about building AI systems with a human approval gate?
