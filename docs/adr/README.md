# Architecture Decision Records — Family Veda

Twelve ADRs, worth 3–6 pages of the consolidated report. Format: **Context → Options → Decision → Consequences → Status.**

| ADR | Title | Owner | Status |
|---|---|---|---|
| [ADR-001](ADR-001-backend-framework.md) | Backend framework selection | S1 | Accepted |
| [ADR-002](ADR-002-database-and-orm.md) | Relational database and ORM | S2 | Accepted |
| [ADR-003](ADR-003-two-stage-familial-model.md) | Two-stage familial data model | S4 | Accepted |
| [ADR-004](ADR-004-react-state-management.md) | React state management | S3 | Accepted |
| [ADR-005](ADR-005-flutter-state-management.md) | Flutter state management | S2 | Accepted |
| [ADR-006](ADR-006-local-llm-ollama.md) | Local LLM via Ollama | S3 | Superseded by ADR-012 |
| [ADR-007](ADR-007-deterministic-safety-layer.md) | Deterministic safety layer | S4 | Accepted |
| [ADR-008](ADR-008-access-by-grant.md) | Access by grant, not by role | S4 | Accepted |
| [ADR-009](ADR-009-async-over-video.md) | Async consultation over video | S3 | Accepted |
| [ADR-010](ADR-010-cloud-deployment-platform.md) | Cloud deployment platform | S1 | Proposed |
| [ADR-011](ADR-011-agent-workflow-state-schema.md) | Agent workflow-state schema | S3 | Proposed |
| [ADR-012](ADR-012-hosted-llm-inference.md) | Hosted LLM inference | S3 | Proposed |

## Writing rule

Write the ADR **when the decision is made**, not in Week 8. The marks are in the trade-off reasoning and the rejected alternatives — those are impossible to reconstruct accurately two months later.

An ADR with an empty "Options considered" section scores nothing. If only one option was ever considered, that is itself the finding: say so and explain why the space was constrained (e.g. "mandated by the module specification").

## Template

```markdown
# ADR-0NN — Title

**Owner:** S_ · **Status:** Proposed | Accepted | Superseded · **Date:** YYYY-MM-DD

## Context
What forced a decision. Constraints in play.

## Options considered
| Option | Pros | Cons |
|---|---|---|

## Decision
The chosen option, in one sentence.

## Consequences
What this makes easy. What this makes hard. What it rules out.

## Status
Accepted / Superseded by ADR-0NN
```
