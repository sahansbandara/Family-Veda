# API Rules — Family Veda

Contract: `docs/API_CONTRACT.md`. Base path `/api/v1`.

## Required

- Every action is `async Task<ActionResult<T>>`. Explicitly assessed.
- **Request and response DTOs always.** An entity is never returned by a controller.
- FluentValidation on every request DTO → 400 with field-level errors.
- RFC 7807 Problem Details for every error, produced by one middleware.
- Pagination on every list endpoint: `?page=1&pageSize=20`, response carries `totalCount`.
- Filtering and sorting on every list endpoint: `?status=&from=&to=&sortBy=&sortDir=`.
- `201` carries a `Location` header. `202` for the long-running triage workflow.
- Swagger annotations sufficient for a stranger to call the endpoint.

## Status codes

| Code | Use |
|---|---|
| 200 | GET / PUT success |
| 201 | POST success + `Location` |
| 202 | Agent workflow accepted, poll for status |
| 204 | DELETE success |
| 400 | Validation failure |
| 401 | Missing or invalid token |
| 403 | Authenticated but not permitted (no grant / no consent) |
| 404 | Not found, **or not visible to the caller** |
| 409 | Business rule conflict |
| 422 | Agent workflow cannot proceed |
| 500 | Unhandled — logged, generic message returned |

Use 404 where the *existence* of a resource is itself private. A doctor without a grant must not be able to enumerate case IDs by comparing 403s and 404s.

## Forbidden

- Returning an entity, or a DTO that transitively exposes one.
- A controller touching `AppDbContext` directly.
- Any endpoint that authorises on `role == "DOCTOR"` alone — access is by grant (ADR-008).
- Any endpoint that lets a client reach the agents, Ollama, FCM or Twilio directly (invariants 3 and 4).
- Any endpoint exposing `draft_advisory` to a patient. Patients see `approvals.final_advisory` only.
- Stack traces, SQL, entity names or member names in an error body.
- Breaking an existing contract without announcing it at the Thursday integration meeting.

## Owner routes

| Owner | Routes |
|---|---|
| S1 | `/auth/*` `/families/*` `/members/*` `/consents/*` |
| S2 | `/records/*` `/lab-reports/*` `/vitals/*` `/hereditary-flags` |
| S3 | `/episodes/*` `/triage-cases/*` `/dashboard` `/notifications/*` |
| S4 | `/doctors/*` `/admin/doctors/*` approval actions `/familial-risk` `/audit` |

Do not add an endpoint under another member's prefix.
