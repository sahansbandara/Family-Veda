# Backend Rules — Family Veda

ASP.NET Core 8 · C# 12. Structure: `backend/README.md`. Stack detail: `rules/csharp/`.

## Layering

```
Api → Application → Domain
Infrastructure implements interfaces declared in Application / Domain
```

- A controller calls a service. It never touches `AppDbContext`.
- A service depends on interfaces, never on concrete infrastructure types.
- `Domain` depends on nothing.
- `Domain/RuleTables/` contains **no** I/O, no LLM call, no DB access. Pure functions over data.

## Required

- Constructor injection everywhere; register in `Program.cs` inside your labelled block.
- One service per business concern, owned by one member.
- Explicit error handling. Never swallow an exception silently.
- Structured logging without secrets, tokens, or clinical content.
- Audit row on every cross-profile read (`AuditService`, S4).
- Consent check before any cross-profile read (`ConsentPolicy`, S1).
- Case grant check before any doctor clinical read (`CaseGrantPolicy`, S4).
- 80%+ unit coverage on your own service layer.

## The four authorisation layers — in order

| # | Layer | Failure |
|---|---|---|
| 1 | Authentication — valid, unexpired JWT | 401 |
| 2 | Role policy — is this endpoint open to this `user_type`? | 403 |
| 3 | Scope — family membership, or an unexpired `case_access_grant` | 403 / 404 |
| 4 | Consent — `GRANTED` for this data category | 403 + audit row |

Being `VERIFIED` is necessary, never sufficient.

## Agent boundary

- Only ASP.NET Core invokes the agents. No client path reaches them (invariant 3).
- Only ASP.NET Core calls FCM/Twilio. No client path reaches them (invariant 4).
- Agents receive data **only** through `ToolDispatcher`. No agent holds a connection string (invariant 5).
- A denied tool call is a hard error, written to `agent_traces.tools_denied`, and halts the workflow.

## Forbidden

- Raw string SQL. EF Core parameterises; hand-built SQL does not.
- A second `DbContext`, a second connection string, or a second backend.
- Business logic in a controller.
- Catching `Exception` and continuing.
- Any code path emitting patient-visible content from a state other than `APPROVED` / `APPROVED_REVISED`.
- Secrets in `appsettings.json`. Environment variables only.
- Editing a file tagged with another member's ref.
