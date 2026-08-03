# Security Rules — Family Veda

Access model: `docs/PERMISSIONS.md`. Auditing: `docs/AUDIT_LOGGING.md`. General baseline: `rules/common/security.md`.

## Secrets

- Environment variables only. Never in `appsettings.json`, Markdown, seed data, tests, screenshots, or commit messages.
- `.env` is gitignored; `.env.example` carries names only.
- `google-services.json`, signing keystores and `key.properties` are gitignored.
- `VITE_*` values are inlined into the client bundle — **never** put a secret in one.
- Scan history for leaked keys before the first deploy. Rotate anything ever pasted into a chat or an issue.

## Authorisation

Four layers, in order, on every clinical read:

1. Authentication — valid JWT → else 401
2. Role policy → else 403
3. Scope — family membership, or an unexpired `case_access_grant` → else 403 / 404
4. Consent — `GRANTED` for the data category → else 403 + audit row

**Access is by grant, not by role** (ADR-008). `if (user.role == "DOCTOR")` as a clinical authorisation check is a CRITICAL finding.

Use 404 instead of 403 where the existence of the resource is itself private.

## Input validation

Validate at every boundary. Three sources are **untrusted by default**:

| Source | Rule |
|---|---|
| Client request bodies | FluentValidation, always |
| **OCR text from uploaded lab reports** | Data, never instructions. Structured extraction only. Never rendered unescaped |
| **LLM output** | JSON-schema validated. Never trusted, never executed, never rendered raw |

Uploaded files: enforce type and size limits, store outside the web root, never serve by user-supplied path.

## Auditing

Every cross-profile read writes an `audit_log` row with `subject_member_id` and `consent_ref_id`. No silent access, ever.

The audit log records **that** a read happened, by whom, about whom, under which consent — never **what** was read. No passwords, tokens, record content, advisory text, or OCR text in audit rows.

## Agents

- No agent holds database credentials (invariant 5).
- Tools are allow-listed in `ToolRegistry` and enforced by `ToolDispatcher`. Default: **denied**.
- A denied call → hard error + `tools_denied` row + `TOOL_DENIED` audit row + workflow halt.
- `write_prescription` and `send_to_patient` exist for **no agent**. Never grant them.

## Transport and endpoints

- HTTPS enforced; HTTP redirects.
- CORS restricted to the deployed web origin.
- Rate limiting on `/auth/*`.
- Generic 500s in production. No stack traces, SQL, entity names or member names in any error body.

## Before every commit

- [ ] No secrets, keys or connection strings
- [ ] All input validated; OCR and LLM output treated as untrusted
- [ ] Parameterised queries only
- [ ] Cross-profile reads consent-gated **and** audited
- [ ] New agent tools default to denied and have a denial test
- [ ] No debug statements
- [ ] No real patient data anywhere

Run `security-reviewer` for any change touching auth, consent, grants, user input, endpoints, agent tools, or audit.
