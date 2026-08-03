# Audit Logging — Family Veda

Owner: **S4**. Table: `audit_log`. Principle 4 of the access model: *every cross-profile read is audited. No silent access. Ever.*

## Why this exists

Two of the strongest claims in the report depend on this table:

1. "Every cross-profile access is consented and audited" — the audit row records **which consent** authorised the read.
2. "Access is by grant, not by role" — the audit trail shows a doctor's access starting at the grant and ending at expiry.

Without the `consent_ref_id` link, both claims are assertions rather than evidence.

## Row shape

| Field | Type | Note |
|---|---|---|
| `id` | uuid | PK |
| `actor_user_id` | uuid, nullable | **null = system or agent** |
| `actor_type` | enum | `USER`, `DOCTOR`, `ADMIN`, `AGENT`, `SYSTEM` |
| `action` | varchar(100) | e.g. `CROSS_PROFILE_FLAG_READ` |
| `resource_type` / `resource_id` | varchar / uuid | what was touched |
| `subject_member_id` | uuid, nullable | **whose data** — the person the row is about |
| `consent_ref_id` | uuid, nullable | which consent authorised it |
| `ip_address` | inet | |
| `metadata` | jsonb | tool name, agent name, case id, grant id |
| `created_at` | timestamptz | NOT NULL |

Indexes: `idx_audit_subject_time` · `idx_audit_actor_time`

## What must be audited

| Event | `action` | Written by |
|---|---|---|
| Cross-profile hereditary flag read | `CROSS_PROFILE_FLAG_READ` | ToolDispatcher [S1] |
| Relationship graph read by an agent | `RELATIONSHIP_GRAPH_READ` | ToolDispatcher [S1] |
| Doctor opens a case | `CASE_VIEWED` | ApprovalsController [S4] |
| Doctor views a member timeline | `MEMBER_TIMELINE_VIEWED` | [S4] |
| Doctor approves / revises / rejects / escalates | `CASE_DECIDED` | ApprovalService [S4] |
| Case grant created | `GRANT_CREATED` | [S4] |
| Case grant revoked or expired | `GRANT_REVOKED` / `GRANT_EXPIRED` | [S4] |
| Consent granted / revoked / reaffirmed | `CONSENT_CHANGED` | ConsentService [S1] |
| Consent auto-moved to `PENDING_REAFFIRMATION` at 18 | `CONSENT_REAFFIRMATION_REQUIRED` | [S1] |
| Doctor verification transition | `DOCTOR_VERIFICATION_CHANGED` | [S4] |
| Login success / failure | `LOGIN_SUCCESS` / `LOGIN_FAILED` | AuthService [S1] |
| Denied tool call | `TOOL_DENIED` | ToolDispatcher [S1] |
| Agent workflow started / completed / failed | `TRIAGE_STARTED` / `TRIAGE_COMPLETED` / `TRIAGE_FAILED` | [S3] |
| Emergency escalation | `EMERGENCY_ESCALATED` | [S4] |
| Notification sent | `NOTIFICATION_SENT` | [S3] |

## What must never be written to the audit log

- Passwords, password hashes, JWTs, refresh tokens
- Full record content, full advisory text, or OCR raw text
- Any value that would let someone reconstruct clinical data from the audit table alone
- Real patient identifiers of any kind

The audit log records **that** a read happened, by whom, about whom, under which consent — not **what** was read.

## Denied tool calls

A denied tool call is recorded in two places, deliberately:

1. `agent_traces.tools_denied` — visible in the doctor's Agent Trace panel and in the demo.
2. `audit_log` with `action = TOOL_DENIED`, `actor_type = AGENT`, and the agent and tool names in `metadata`.

The trace proves it to the examiner; the audit log proves it to an auditor.

## Retention

Full project lifetime. The database and all audit rows are retained until at least **21 October 2026** so the evaluator can inspect them.

## Audit Log Viewer (React, S4)

Shows, for a family head or admin: who accessed what, when, and under which consent. Filterable by subject member, actor, action and date range. Paginated. This screen is where the "no silent access" claim is demonstrated live.

## Development-time logging (`logs/`)

Separate concern. Agent run logs and session notes go in `logs/` and are gitignored. Never put credentials or clinical content there either.
