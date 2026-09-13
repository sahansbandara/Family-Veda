# ADR-008 — Access by grant, not by role

**Owner:** S4 · **Status:** Accepted · **Date:** 2026-08-06

## Context

The obvious authorisation model is role-based: a user with role `DOCTOR` may read patient data. That model is what most student projects implement, and it is wrong for this domain — a verified doctor has no legitimate reason to read the records of a family they are not treating.

The specification also asks for non-trivial authorisation. Role checks are trivial authorisation.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| **Per-case, time-bound grants in `case_access_grants`** (chosen) | Least privilege — access exists only for a specific case, for a specific window; expiry is automatic; every grant is individually auditable; revocation is one column | An extra table and an extra check on every clinical read; grant creation must be wired into case assignment |
| Role-based (`user.role == "DOCTOR"`) | Trivial to implement | Any verified doctor can read any patient. Indefensible, and scores as trivial authorisation |
| Doctor–family assignment only | Better than role-based; models a real GP relationship | Still standing access to a whole family indefinitely; does not handle pool claims or escalation; no natural expiry |

## Decision

**Authorisation for clinical data reads `case_access_grants`, never the user's role.**

```sql
SELECT * FROM case_access_grants
 WHERE triage_case_id = @caseId
   AND doctor_id      = @doctorId
   AND revoked_at IS NULL
   AND expires_at > now();
-- no row → 403
```

Grants are created by assignment or atomic pool claim. Emergency cases may enter a de-identified pool, but no clinical identifiers or push metadata are disclosed until a claim creates an active grant.

The role check does not disappear — it is layer 2 of four (see `docs/ARCHITECTURE.md`). Being `VERIFIED` is *necessary*; it is not *sufficient*.

## Consequences

**Makes easy**
- "Can any verified doctor see any patient?" has a one-word answer with a query behind it.
- Expiry is data, not code — no background job needed for the common case; the check reads `expires_at > now()`.
- The audit trail shows access beginning at the grant and ending at expiry, per doctor, per case.
- A `PENDING` doctor gets 403 everywhere clinical, because they can hold no grant.

**Makes hard**
- Every clinical read must join or check the grant. Centralised in `CaseGrantPolicy` [S4] so it cannot be forgotten per-controller.
- Case assignment logic becomes responsible for grant creation — assignment and authorisation are coupled by design.

**Rules out**
- Any endpoint that authorises on `role == DOCTOR` alone. This is a CRITICAL review finding if it ever appears.

## Status

Accepted. Covered by `CaseGrantTests` and priority test cases 1 and 8.
