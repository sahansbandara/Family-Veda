# Database Rules — Family Veda

PostgreSQL 16 · EF Core 8 + Npgsql. Schema: `docs/DATABASE.md`.

## Migration protocol ⚠ — the one thing that genuinely breaks the repo

```
1. Announce in the group chat: "taking migration lock, ~20 min"
2. git pull origin develop
3. dotnet ef migrations add 20260814_S2_AddLabReportsAndValues
4. dotnet ef database update        # verify
5. Commit and push immediately
6. Announce: "migration lock released"
7. Everyone else: git pull before working
```

- **Never two migrations in flight.**
- **Never edit a migration another member has pushed** — add a new one.
- Naming: `<date>_<owner>_<purpose>`.

## Required

- One `DbContext`, one migration history, one connection string.
- Entity configuration in one file per entity under `Persistence/Configurations/`.
- Foreign keys on every relationship. Referential integrity here is a **security property** — authorisation is a query over these relationships.
- `UNIQUE` and `CHECK` constraints where a duplicate or self-reference would be a bug:
  - `consents`: `UNIQUE(member_id, data_category)`
  - `hereditary_flags`: `UNIQUE(member_id, condition_code)`
  - `relationships`: `UNIQUE(member_id, related_member_id)`, `CHECK (member_id <> related_member_id)`, `is_biological NOT NULL`
  - `agent_traces`: `UNIQUE(triage_case_id, step_number)`
  - `members`: `CHECK (date_of_birth <= CURRENT_DATE)`
- Indexes for the queries that actually run: `idx_vitals_member_time` (baseline), `idx_labvalues_analyte` (trends), `idx_cases_status_priority` (doctor queue), `idx_audit_subject_time` (audit viewer).
- `timestamptz`, never naive timestamps.
- `uuid` primary keys with `gen_random_uuid()`.

## `jsonb` — narrow and deliberate

Permitted: `episodes.symptoms`, `triage_cases.*_output`, `agent_traces.input_summary`/`output_summary`/`tools_*`, `audit_log.metadata`.

Everything with a relational obligation is a real column with a real constraint. Do not reach for `jsonb` to avoid a migration.

## Seed data

**Synthetic only.** One demo family of four plus 2 doctors and 1 admin (`docs/DATABASE.md`). No real patient data, no real NIC, no real SLMC numbers — ever, including in tests and screenshots.

## Forbidden

- A second database, or a per-student schema.
- Destructive migrations without group approval.
- Editing a pushed migration.
- Raw string SQL.
- Storing secrets, tokens, or full clinical content in `audit_log`.
