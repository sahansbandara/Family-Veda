---
name: database-migration
description: Database schema changes with migration files.
allowed_tools: ["Bash", "Read", "Write", "Edit", "Grep", "Glob"]
---

# /database-migration

Use this workflow for database schema changes.

## Goal

Database schema changes with migration files, type generation, and verification.

## Pipeline

1. **Analyze** — Review current schema and understand the change needed.
2. **Plan** — Design the migration. Consider rollback strategy.
3. **Create** — Write migration file with up and down operations.
4. **Types** — Generate/update TypeScript types from new schema.
5. **Test** — Verify migration applies cleanly. Test rollback.
6. **Review** — Use **code-reviewer** and **security-reviewer** for data-touching changes.

## Common Files

- `**/schema.*`
- `migrations/*`
- `supabase/migrations/*`

## Typical Commit Signals

- Create migration file
- Update schema definitions
- Generate/update types

## Notes

- Always include rollback (down) migration.
- Never drop columns/tables without data backup plan.
- Test migration on a branch/preview environment first.
