# Logs

Working scratch space for agent-run records and session notes during development. **Contents are gitignored** — only this README is committed.

## Never store here

- passwords, password hashes, JWTs, refresh tokens
- API keys, connection strings, FCM server keys, Twilio credentials
- private keys or certificates
- **any real patient data**
- full clinical record content, full advisory text, or OCR raw text

## Not the same as the audit log

`audit_log` is a database table, is part of the product, and is a graded deliverable. See `docs/AUDIT_LOGGING.md`. This directory is developer scratch space and is not part of the submission.

## Agent run note format

```markdown
# Run — YYYY-MM-DD HH:MM

**Task:**
**Component / owner:**
**Preflight:** superpowers=[…] · headroom=[on|absent] · caveman=[on|off]

## What changed

## Checks run

## Risks / follow-ups
```
