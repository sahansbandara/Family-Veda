# ADR-002 — Relational database and ORM

**Owner:** S2 · **Status:** Accepted · **Date:** 2026-08-06

## Context

The data model has hard referential requirements: a consent row must point at exactly one member and one data category; a hereditary flag must point at real evidence; a case access grant must point at a real case and a real doctor; the relationship graph must be traversable to compute biological lineage. Authorisation decisions are queries over these relationships, so referential integrity is a **security property**, not just tidiness.

PostgreSQL is mandated by the specification. This ADR records why it fits and what a document store would have cost.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| **PostgreSQL 16 + EF Core 8/Npgsql** (chosen) | Enforced FKs, CHECK constraints and UNIQUE constraints; `jsonb` for agent outputs where the shape is genuinely variable; strong indexing for the baseline and trend queries; real migration history | Migration conflicts if two authors generate migrations concurrently (mitigated by the lock protocol) |
| MongoDB / document store | Flexible schema for agent outputs | No enforced referential integrity — a consent could reference a deleted member, and an authorisation check would silently pass. **Disqualifying.** Also not permitted |
| PostgreSQL + Dapper | Full SQL control, minimal overhead | Hand-written migrations; four authors sharing hand-rolled SQL is a conflict surface; loses EF Core's change tracking and configuration-per-entity |

## Decision

**PostgreSQL 16 with EF Core 8 + Npgsql**, one `DbContext`, one migration history, entity configuration in one file per entity.

`jsonb` is used deliberately and narrowly: `episodes.symptoms`, the four `triage_cases.*_output` columns, `agent_traces.input_summary` / `output_summary` / `tools_*`, and `audit_log.metadata`. Everything with a relational obligation is a real column with a real constraint.

## Consequences

**Makes easy**
- Authorisation queries (`case_access_grants`, `consents`) are indexed relational lookups with guaranteed-valid foreign keys.
- `UNIQUE(member_id, data_category)` on `consents` and `UNIQUE(member_id, condition_code)` on `hereditary_flags` make duplicate-state bugs impossible rather than merely unlikely.
- `CHECK (member_id <> related_member_id)` prevents a self-relationship corrupting hereditary reasoning.
- One migration history is a single, reviewable schema story for the report.

**Makes hard**
- Concurrent migrations break the model snapshot. This is the single biggest repository risk (T1) and is why the migration lock protocol exists.
- Agent output shape changes require either a `jsonb` change (cheap) or a migration (locked).

**Rules out**
- Per-member schemas or per-student databases. Invariant 2.

## Status

Accepted.
