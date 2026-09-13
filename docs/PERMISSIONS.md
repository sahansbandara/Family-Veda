# Roles, Permissions and Access Model — Family Veda

Source: blueprint §5 and §12. Owner: S1 (identity, consent, family scope) and S4 (grants, doctor lifecycle, audit).

## Role definitions

| Role | Description | Can see |
|---|---|---|
| **Family Head** | Creator/administrator of the family account | Own record; minors' records in the family; family dashboard; consent settings for minors |
| **Family Member (18+)** | Adult member with independent rights | Own record only; own consent settings; can revoke sharing |
| **Doctor (VERIFIED)** | Licensed practitioner, admin-verified | Only cases with an active grant, only for the grant window |
| **Clinic Admin** | Platform administrator | Doctor verification queue; system config; **no clinical data** |
| **Agent (system)** | Non-human actor | Only what an allow-listed tool returns, always scoped |

Five roles. The specification requires at least three.

## Access principles

```
PRINCIPLE 1 — Data minimisation
   Give the minimum data that answers the question.

PRINCIPLE 2 — Access by grant, not by role
   Being a doctor grants nothing. A case grant grants access.

PRINCIPLE 3 — Consent crosses profiles, files do not
   Hereditary FLAGS may cross member boundaries.
   Raw records never do.

PRINCIPLE 4 — Every cross-profile read is audited
   No silent access. Ever.

PRINCIPLE 5 — Adults own their data
   At 18, consent authority transfers from guardian to member.
```

## Permission matrix

| Action | Family Head | Member 18+ | Doctor (granted) | Doctor (no grant) | Clinic Admin |
|---|:-:|:-:|:-:|:-:|:-:|
| Create family | ✔ | ✘ | ✘ | ✘ | ✘ |
| Add member | ✔ | ✘ | ✘ | ✘ | ✘ |
| View own record | ✔ | ✔ | n/a | n/a | n/a |
| View minor's record (own family) | ✔ | ✘ | ✘ | ✘ | ✘ |
| View adult member's record | ✘ | ✔ self | ✔ in case | ✘ | ✘ |
| Set consent for self | ✔ | ✔ | ✘ | ✘ | ✘ |
| Set consent for minor | ✔ | ✘ | ✘ | ✘ | ✘ |
| Submit episode | ✔ | ✔ | ✘ | ✘ | ✘ |
| View triage case | ✔ own family | ✔ own | ✔ granted only | ✘ | ✘ |
| View agent trace | ✘ | ✘ | ✔ | ✘ | ✔ metadata only |
| Approve / reject case | ✘ | ✘ | ✔ | ✘ | ✘ |
| Verify doctor | ✘ | ✘ | ✘ | ✘ | ✔ |
| View audit log | ✔ own family | ✔ own | ✘ | ✘ | ✔ system |

## Consent state machine

```
        ┌──────────────┐
        │  NOT_SET     │  (default — nothing shared)
        └──────┬───────┘
               │ member or guardian grants
               ▼
        ┌──────────────┐   revoke    ┌──────────────┐
        │   GRANTED    │ ──────────► │   REVOKED    │
        └──────┬───────┘             └──────┬───────┘
               │ member turns 18            │ re-grant
               ▼                            ▼
   ┌────────────────────────┐         ┌──────────────┐
   │ PENDING_REAFFIRMATION  │         │   GRANTED    │
   │ guardian consent no    │         └──────────────┘
   │ longer valid — treated │
   │ as NOT GRANTED         │
   └────────────────────────┘
```

**Business rule.** When a member reaches 18, all guardian-granted consents move to `PENDING_REAFFIRMATION` and are treated as **not granted** until the member personally confirms. Strong viva talking point and a required test case.

Consent categories: `HEREDITARY_FLAGS`, `VITALS_SUMMARY`, `CONDITIONS`. Granted per member, per category, independently.

## Access is by grant, not by role

```
 ❌ WRONG:  if (user.role == "DOCTOR") → allow

 ✔ RIGHT:  grant = SELECT * FROM case_access_grants
                    WHERE triage_case_id = @caseId
                      AND doctor_id      = @doctorId
                      AND revoked_at IS NULL
                      AND expires_at > now();
            if (grant == null) → 403
```

> **Viva line.** "Doctors do not have standing access to patient data. They receive time-bound, case-scoped grants that expire automatically and are individually audited."

## Doctor verification lifecycle

```
   Doctor self-registers (React)
   { name, NIC, SLMC reg no, specialty, qualification, certificate upload }
              │
              ▼
   ┌──────────────────────┐
   │ STATUS: PENDING      │  ◄── ZERO patient data access
   └──────────┬───────────┘
              │
   Clinic Admin reviews (React admin panel)
   • SLMC number checked manually against the public register
   • Certificate document viewed
              │
     ┌────────┼────────┬─────────────┐
     ▼        ▼        ▼             ▼
  APPROVE  REQUEST   REJECT       (later)
     │      _INFO      │          SUSPEND
     ▼        │        ▼             │
 ┌────────┐   │   ┌─────────┐   ┌──────────┐
 │VERIFIED│   │   │REJECTED │   │SUSPENDED │
 └───┬────┘   │   └─────────┘   └──────────┘
     │        └──► back to doctor for resubmission
     ▼
 Eligible for case assignment
 (still requires a per-case grant)
```

Every transition writes a `doctor_verification_log` row with actor and reason.

**Verification in v1 is manual.** No public SLMC API exists. Never claim otherwise.

## Case assignment model

```
 New case validated
       │
       ▼
 Family has a primary doctor?
       │
   yes ├──────────────────────► assign to primary doctor
       │                        create case_access_grant (expires_at = +48h)
       │                        SLA timer = 6 hours
       │                             │
       │                        responded within 6h?
       │                             │  no
       │                             ▼
   no  │                        release to SHARED POOL
       ├──────────────────────►      │
       ▼                             ▼
   SHARED POOL — any VERIFIED doctor may claim
       │                    grant created on claim
       ▼
   EMERGENCY priority → de-identified claim pool
                        + notify active-grant doctor only
```

## Agent permissions

Agents are actors with the narrowest scope in the system.

- An agent holds **no database credentials**.
- An agent can only call tools in its allow-list, enforced by `ToolDispatcher` [S1].
- A denied call is a hard error, written to `agent_traces.tools_denied`, and halts the workflow.
- Cross-profile agent reads (hereditary flags only) are consent-checked and audited exactly as a human read would be.

Full matrix: `docs/AGENTS_DESIGN.md`.

## Development-time approval model

Applies to coding agents working in this repository.

| Action | Risk | Approval required | Rollback |
|---|---|---|---|
| Read project files | Low | No | n/a |
| Edit a file the acting member owns | Low | No | git revert |
| Edit a `⚠ SHARED` file | Medium | Follow the labelled-block convention | git revert |
| Edit a file owned by another member | High | **Ask that member** | git revert |
| Generate an EF Core migration | High | **Migration lock announced in group chat** | New migration, never edit a pushed one |
| Change `package.json` / `pubspec.yaml` / `.csproj` versions | Medium | Announce in group chat first | git revert |
| Commit / push | Medium | Only the owning member, under their own account | git revert |
| Merge to `develop` | Medium | 1 peer review + green CI | Revert commit |
| Deploy | High | Group leader | Redeploy previous build |
| Change deployment or security settings | High | Group leader + S1 | Restore previous config |
| Anything violating a clinical safety rule | Critical | **Refused** | n/a |
