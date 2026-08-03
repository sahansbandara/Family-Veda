# API Contract — Family Veda

ASP.NET Core Web API · base path `/api/v1` · source: blueprint §9.
The exported OpenAPI spec lives in `docs/api/openapi.yaml` and is generated from Swagger.

## Conventions

| Aspect | Rule |
|---|---|
| Base path | `/api/v1` |
| Auth | `Authorization: Bearer <JWT>` |
| Content type | `application/json` (multipart only for file upload) |
| Errors | RFC 7807 Problem Details |
| Pagination | `?page=1&pageSize=20`; response carries `totalCount` |
| Filtering | `?status=&from=&to=` |
| Sorting | `?sortBy=createdAt&sortDir=desc` |
| Async | Every action is `async Task<ActionResult<T>>` |
| DTOs | Request and response DTOs always — **entities are never exposed** |
| Validation | FluentValidation → 400 with field-level errors |

## Status code policy

| Code | Used for |
|---|---|
| 200 | Successful GET / PUT |
| 201 | Successful POST, with a `Location` header |
| 202 | Accepted — long-running agent workflow started |
| 204 | Successful DELETE |
| 400 | Validation failure |
| 401 | Missing or invalid token |
| 403 | Authenticated but not permitted (no grant / no consent) |
| 404 | Not found, **or not visible to the caller** |
| 409 | Business rule conflict (e.g. duplicate SLMC number) |
| 422 | Agent workflow cannot proceed |
| 500 | Unhandled — logged, generic message returned |

> 404 is deliberately used where the *existence* of a resource is itself private. A doctor with no grant must not be able to enumerate case IDs by comparing 403s and 404s.

## Error shape (RFC 7807)

```json
{
  "type": "https://familyveda.app/errors/consent-required",
  "title": "Consent required",
  "status": 403,
  "detail": "No GRANTED consent exists for data category HEREDITARY_FLAGS.",
  "instance": "/api/v1/members/6f1c.../familial-risk",
  "traceId": "00-4bf92f...-01"
}
```

No stack traces, no SQL, no entity names, no member names in error bodies.

---

## S1 — Identity, Family, Consent

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/auth/register` | Register family user |
| POST | `/auth/login` | Obtain JWT |
| POST | `/auth/refresh` | Refresh token |
| GET | `/families/me` | Current user's family |
| POST | `/families` | Create family |
| PUT | `/families/{id}` | Update family |
| GET | `/families/{id}/members` | List members (paged) |
| POST | `/families/{id}/members` | Add member |
| GET | `/members/{id}` | Member detail |
| PUT | `/members/{id}` | Update member |
| DELETE | `/members/{id}` | Remove member |
| GET | `/members/{id}/relationships` | Relationship graph |
| POST | `/members/{id}/relationships` | Add relationship (`isBiological` required) |
| GET | `/members/{id}/consents` | Consent settings |
| PUT | `/members/{id}/consents/{category}` | Grant / revoke |
| POST | `/members/{id}/consents/reaffirm` | 18+ reaffirmation |

## S2 — Health Records and Extraction

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/members/{id}/records` | List records (paged, filtered, sorted) |
| POST | `/members/{id}/records` | Create record |
| PUT | `/records/{id}` | Update record |
| DELETE | `/records/{id}` | Delete record |
| GET | `/members/{id}/lab-reports` | List lab reports |
| POST | `/members/{id}/lab-reports` | Upload (multipart) |
| GET | `/lab-reports/{id}` | Report detail + parsed values |
| POST | `/lab-reports/{id}/extract` | Trigger the Extraction Agent |
| GET | `/members/{id}/vitals` | Vitals series |
| POST | `/members/{id}/vitals` | Record vitals |
| GET | `/members/{id}/vitals/trends` | Computed trends |
| GET | `/members/{id}/hereditary-flags` | Flags for member |

## S3 — Episodes, Triage, Notifications

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/members/{id}/episodes` | Submit complaint |
| GET | `/members/{id}/episodes` | Episode history |
| POST | `/episodes/{id}/triage` | Start the agentic workflow → 202 |
| GET | `/triage-cases/{id}` | Case detail |
| GET | `/triage-cases/{id}/status` | Poll status |
| GET | `/triage-cases/{id}/traces` | Agent traces |
| GET | `/families/{id}/triage-cases` | Family case list |
| GET | `/families/{id}/dashboard` | Aggregated dashboard |
| POST | `/notifications/subscribe` | Register device token |

## S4 — Risk, Doctor, Approval, Audit

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/doctors/register` | Doctor self-registration |
| GET | `/doctors/me` | Doctor profile + verification status |
| GET | `/admin/doctors?status=PENDING` | Verification queue |
| POST | `/admin/doctors/{id}/verify` | Approve |
| POST | `/admin/doctors/{id}/request-info` | Request more info |
| POST | `/admin/doctors/{id}/reject` | Reject |
| POST | `/admin/doctors/{id}/suspend` | Suspend |
| GET | `/doctors/me/cases` | Assigned case queue |
| POST | `/triage-cases/{id}/claim` | Claim from the shared pool |
| POST | `/triage-cases/{id}/approve` | Approve |
| POST | `/triage-cases/{id}/revise` | Revise and approve |
| POST | `/triage-cases/{id}/reject` | Reject |
| POST | `/triage-cases/{id}/escalate` | Escalate |
| GET | `/members/{id}/familial-risk` | Risk assessment |
| GET | `/audit?subjectMemberId=` | Audit trail |

---

## Endpoints that must never exist

| Would-be endpoint | Why it is forbidden |
|---|---|
| `GET /triage-cases/{id}/draft-advisory` for a patient | The draft is pre-approval AI output. Invariant 6 |
| Anything that lets a client call Ollama or an agent directly | Invariant 3 |
| Anything that lets a client call FCM or Twilio directly | Invariant 4 |
| `POST /prescriptions` | RULE 6 — no prescriptions, in v1 or ever in this scope |
| `GET /families/{id}/all-records` for an agent | Raw records never cross member boundaries |
| Any endpoint authorising on `role == DOCTOR` alone | ADR-008 — access is by grant |

## Authorisation notes per endpoint family

| Family | Check |
|---|---|
| `/auth/*` | Anonymous. Rate-limited |
| `/families/*` `/members/*` | Caller is the family head, or the member themselves (18+). Minors' data → head only |
| `/records/*` `/lab-reports/*` `/vitals/*` | Family scope, or an unexpired case grant covering the member |
| `/triage-cases/{id}/*` (doctor actions) | Unexpired `case_access_grant` **and** `verification_status = VERIFIED` |
| `/admin/*` | `user_type = ADMIN`. **Admins never see clinical data** |
| `/members/{id}/familial-risk` | Family scope or grant, **plus** `HEREDITARY_FLAGS` consent per contributing member |
| `/audit` | Family head for own family · member for self · admin for system |

## Versioning

`/api/v1` is fixed for the assignment. Breaking changes inside the semester are coordinated at the Thursday integration meeting and announced in the group chat — both clients must land the change in the same integration cycle.
