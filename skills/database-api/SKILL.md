---
name: database-api
description: Use when changing the database schema, writing an EF Core migration, adding or changing an API endpoint, designing a DTO, or updating the API contract. Fires on "add a table", "migration", "new endpoint", "change the schema", "DbContext", "OpenAPI".
---

# Database and API

Stack is **already selected** — PostgreSQL 16 + EF Core 8, ASP.NET Core 8 (ADR-001, ADR-002). This skill is about changing it safely, not choosing it.

Schema: `docs/DATABASE.md` · Contract: `docs/API_CONTRACT.md` · Rules: `rules/database.md`, `rules/api.md`.

## Before any schema change

1. **Is the table yours?** S1 identity · S2 records · S3 triage · S4 doctor/approval/audit. If not, stop and ask.
2. **Take the migration lock.** Announce in the group chat. This is the one failure that genuinely breaks the repository.
3. **Model it in `docs/DATABASE.md` first.** Columns, types, FKs, constraints, indexes.

## Migration protocol ⚠

```
1. Announce: "taking migration lock, ~20 min"
2. git pull origin develop
3. dotnet ef migrations add 20260814_S2_AddLabReportsAndValues
4. dotnet ef database update        # verify it applies cleanly
5. Commit and push immediately
6. Announce: "migration lock released"
```

**Never two in flight. Never edit a migration someone already pushed** — add a corrective one.

## Schema checklist

- [ ] `uuid` PK with `gen_random_uuid()`
- [ ] `timestamptz`, never naive timestamps
- [ ] Foreign key on every relationship — referential integrity here is a **security property**
- [ ] `UNIQUE` / `CHECK` where a duplicate or self-reference would be a bug
- [ ] Index for the query that will actually run
- [ ] Entity configuration in its own `IEntityTypeConfiguration<T>` file
- [ ] `DbSet<>` added inside your labelled block in `AppDbContext.cs` ⚠ SHARED
- [ ] `docs/DATABASE.md` updated in the same PR

## `jsonb` — narrow and deliberate

Permitted only where the shape is genuinely variable: `episodes.symptoms`, `triage_cases.*_output`, `agent_traces.*`, `audit_log.metadata`. Anything with a relational obligation is a real column with a real constraint. Do not use `jsonb` to dodge a migration.

## Adding an endpoint

- [ ] Under **your** route prefix
- [ ] Request and response **DTOs** — never an entity
- [ ] FluentValidation validator → 400 with field-level errors
- [ ] `async Task<ActionResult<T>>`
- [ ] Correct status code (`docs/API_CONTRACT.md`) — 404 where existence itself is private
- [ ] Paged, filterable, sortable if it returns a list
- [ ] Authorisation: role policy **and** scope **and** consent where cross-profile
- [ ] Audit row if it reads cross-profile data
- [ ] Swagger annotation sufficient for a stranger to call it
- [ ] `docs/API_CONTRACT.md` updated in the same PR
- [ ] Integration test asserting both the success and the 403 path

## Never

- A second `DbContext`, connection string, or backend.
- An endpoint authorising on `role == "DOCTOR"` alone (ADR-008).
- Raw string SQL.
- An endpoint exposing `draft_advisory` to a patient.
- A contract change landed without announcing it at the Thursday integration meeting — both clients must move together.
