# Nine-Week Timeline — Family Veda

31 July 2026 → 30 September 2026. Source: blueprint §13. Task detail per week: `agent/TODO.md`.

## Week plan

| Week | Dates | Theme | Deliverables | Gate |
|---|---|---|---|---|
| **W1** | Jul 31 – Aug 6 | Foundation | Group charter; repo + branch strategy; ER diagram final; OpenAPI contract drafted; wireframes; ADR-001; **domain and scope frozen**; component allocation confirmed | Contract signed off by all 4 |
| **W2** | Aug 7 – 13 | Skeleton | ASP.NET Core running; EF Core migrations applied; JWT auth working (S1); React shell + routing; Flutter shell + navigation; GitHub Actions CI | 🚦 **CI green** |
| **W3** | Aug 14 – 20 | Core CRUD | All members' endpoints implemented and Swagger-tested; DB tables with constraints and indexes; first PRs merged with review | All endpoints return 2xx in Swagger |
| **W4** | Aug 21 – 27 | Frontend wiring | React screens bound to API; Flutter screens bound to API; protected routes both sides; validation; loading/empty/error states | 🚦 **End-to-end login + record create on both platforms** |
| **W5** | Aug 28 – Sep 3 | Agents I | Ollama running; **tool dispatch layer with allow-list enforcement (S1)**; Extraction Agent producing flags (S2); Context Agent (S3); traces persisting | Extraction + Context produce persisted output · **SCOPE FREEZE** |
| **W6** | Sep 4 – 10 | Agents II | Analysis Agent (S3); Familial Risk Agent (S4); Safety Agent + rule tables (S4); approval gate wired to React; notification service | 🚦 **Full workflow runs end to end** |
| **W7** | Sep 11 – 17 | Integration & quality | Cross-platform workflow verified; unit + integration tests; device feature complete; security pass; emergency path tested; bug fixes | Cross-platform demo runs unaided |
| **W8** | Sep 18 – 24 | Deploy & document | All components deployed; APK built and tested on a physical device; consolidated report written; ADRs finalised; AI disclosure logs; 10-minute demo video recorded | 🚦 **Deployed and reachable by evaluator** |
| **W9** | Sep 25 – 30 | Freeze & viva | **Code freeze Sep 26**; mock viva ×2; each member rehearses explain + modify + debug; final proofread; **submit Sep 29** | Submitted one day early |

Memory hook: **2-4-6-8** — W2 CI green · W4 CRUD end-to-end · W6 agents complete · W8 deployed.

## Contingency rules

| Trigger | Action |
|---|---|
| W4 gate missed | Cut dashboard charts and the Flutter notification inbox. **Core CRUD is non-negotiable** |
| W6 gate missed | Cut the **Familial Risk Agent**; ship 3 agents. Document as a deliberate scope reduction. Three well-executed agents outscore four broken ones |
| W8 gate missed | Deploy backend + database + React as a minimum; ship Flutter as an APK only. **Never skip deployment entirely** |
| A member is 2+ weeks behind by W5 | Escalate to the lecturer-in-charge **in writing**. Do not absorb silently — individual marks are individual |
| New feature proposed after W5 | Goes to `docs/FUTURE_WORK.md`. Zero lines of code |

## Cut priority

| Priority | Item | Cut? |
|---|---|---|
| 1 | Agentic workflow end to end | **Never** |
| 2 | Working integrated system across all four stacks | **Never** |
| 3 | Deployment + consolidated report | **Never** |
| 4 | Testing and CI | Reduce, do not drop |
| 5 | Familial Risk Agent (4th agent) | Cut only if the W6 gate is missed |
| 6 | Dashboard charts, analytics depth, UI polish | **Cut first** |

## Weekly ritual

```
EVERY MONDAY — 30 minutes
  ▸ Each member: what shipped, what is blocked
  ▸ Update the gate board in agent/TODO.md
  ▸ Reassign if anyone is behind

EVERY THURSDAY — 30 minutes
  ▸ Integration check: does main still build and run?
  ▸ Merge outstanding PRs
  ▸ Demo whatever exists, however small

EVERY SUNDAY — individual, 15 minutes
  ▸ Update own AI-use disclosure log
  ▸ Update own individual report section
  ▸ (Do NOT leave the report to Week 8)
```

## Key dates

| Date | Event |
|---|---|
| Jul 31 2026 | Project starts |
| Sep 3 2026 | **Scope freeze** — end of W5 |
| Sep 26 2026 | **Code freeze** |
| Sep 29 2026 | **Submit** (one day early, by the group leader, via CourseWeb) |
| Sep 30 2026, 11:50 PM | Official deadline |
| Oct 21 2026 | Access must remain live until at least this date |
