---
name: database-migration
description: EF Core schema change under the Family Veda migration lock protocol.
allowed_tools: ["Bash", "Read", "Write", "Edit", "Grep", "Glob"]
---

# /database-migration

PostgreSQL 16 + EF Core 8. Schema: `docs/DATABASE.md`. Rules: `rules/database.md`.

> **Two simultaneous migrations produce conflicting model snapshots — the one failure that genuinely breaks this repository.** The lock is not optional.

## Pipeline

1. **Ownership** — is the table yours? S1 identity · S2 records · S3 triage · S4 doctor/approval/audit. If not, stop and ask.
2. **Model it in `docs/DATABASE.md` first** — columns, types, FKs, constraints, indexes. Review the design before generating anything.
3. **Take the lock** — announce in the group chat: *"taking migration lock, ~20 min"*.
4. **Pull** — `git pull origin develop`.
5. **Generate** — naming is `<date>_<owner>_<purpose>`.
6. **Apply and verify** — `dotnet ef database update` against a local database.
7. **Test** — the affected integration tests still pass; the synthetic seed still loads.
8. **Review** — `code-reviewer` and `security-reviewer` (schema changes are data-touching by definition).
9. **Commit and push immediately** — do not hold the lock overnight.
10. **Release the lock** — announce in the group chat. Everyone else pulls.

## Commands

```bash
cd backend && dotnet ef migrations add 20260814_S2_AddLabReportsAndValues
```

```bash
cd backend && dotnet ef database update
```

## Checklist

- [ ] `uuid` PK, `timestamptz` timestamps
- [ ] FK on every relationship
- [ ] `UNIQUE` / `CHECK` where a duplicate or self-reference would be a bug
- [ ] Index for the query that will actually run
- [ ] `IEntityTypeConfiguration<T>` in its own file
- [ ] `DbSet<>` added inside your labelled block in `AppDbContext.cs` ⚠ SHARED
- [ ] `docs/DATABASE.md` updated in the same PR
- [ ] Migration applies cleanly from an empty database

## Never

- Two migrations in flight.
- Editing a migration another member has already pushed — add a corrective one.
- Dropping a column or table without a group decision.
- Raw string SQL.
- Real patient data in a seed.
