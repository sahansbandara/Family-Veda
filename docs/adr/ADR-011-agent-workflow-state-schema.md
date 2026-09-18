# ADR-011 — Agent workflow-state schema

**Owner:** S3 · **Status:** Proposed (AI-drafted 2026-09-18 — owner must review, edit and accept) · **Date:** 2026-09-18

## Context

SE3090 §9.1 requires durable shared state: workflow ID, objective, plan, completed steps, tool results, validation results, errors, approval status and final outcome. The workflow runs asynchronously in a background worker, can be interrupted by a restart (Render free sleeps), and every step must be auditable and shown to the reviewing doctor. No hidden reasoning, passwords or tokens may be stored (§6).

## Options considered

| Option | Pros | Cons |
|---|---|---|
| In-memory state only | Simplest, fastest | Lost on restart; no audit; cannot prove steps to evaluator |
| One JSON blob per workflow | Flexible; one write | Cannot query or index steps; no FK integrity; hard to test concurrency |
| **Normalised relational entities with bounded JSON columns** (chosen) | FK integrity, indexes, per-step audit rows, restart recovery by status, queryable for dashboards | More tables and migrations |

## Decision

- `TriageCase` is the workflow: ID, member, `Status` state machine (`Submitted → Planning → ContextReady → Analysed → RiskAssessed → Validated → PendingDoctorReview → Claimed → Approved / ApprovedRevised / Rejected / Escalated / FailedSafe`), priority, per-agent structured outputs (`ContextOutputJson`, `AnalysisOutputJson`, `FamilialRiskOutputJson`, `DraftAdvisoryJson`), `FailureCode`, timestamps.
- `Episode` holds the objective (symptoms, duration, severity).
- `AgentTrace` is one row per step: step number, agent, status, input hash (not raw input), tools requested/allowed/denied, schema-valid flag, confidence, latency, token counts, model name, error code.
- `Approval`, `CaseAccessGrant` and `AuditLog` hold the human decision and access evidence.
- JSON columns only hold schema-validated agent output — never prompts or chain-of-thought.

## Consequences

**Makes easy:** restart recovery (worker re-queues by status); doctor sees full execution history; evaluation tests assert on rows; dashboard analytics from SQL.

**Makes hard:** every new step needs a status value and migration; JSON output shape must stay in sync with validators.

**Rules out:** storing raw prompts, model reasoning or credentials.

## Status

Proposed. Accept after S3 review.
