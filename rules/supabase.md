# Supabase Backend Rules

Supabase is an optional backend candidate, not the default for every project.

## Select Supabase when

- PostgreSQL fits the data model.
- The project needs rapid authentication and authorization.
- Realtime database events are useful.
- File storage is required.
- Generated REST/GraphQL APIs reduce unnecessary backend work.
- Vector/embedding storage is useful.
- A web/mobile MVP needs a managed backend quickly.

## Do not select Supabase when

- The existing project already has a suitable database/backend.
- MongoDB better fits the existing data model and migration cost is unjustified.
- Spring Boot or another backend owns complex business logic.
- The project requires database behavior that conflicts with the platform.
- Vendor dependency is unacceptable and self-hosting is not planned.
- The project handles sensitive data without a reviewed security model.

## Required architecture rules

- Define schema before implementation.
- Use migrations.
- Enable Row Level Security where client access exists.
- Write explicit RLS policies.
- Keep service-role keys server-side only.
- Never expose privileged keys in frontend code.
- Separate development, staging, and production.
- Add indexes for expected queries.
- Define backups and export strategy.
- Avoid embedding business-critical logic only in client code.
- Document exit/migration strategy.

## Decision output

```text
SUPABASE DECISION:
- Selected: yes/no
- Reason:
- Required features:
- Schema fit:
- Auth model:
- RLS plan:
- Storage:
- Realtime:
- Backup:
- Exit strategy:
```
