# Workflow: Audit

Review of changed code. Severity model: `CLAUDE.md`.

1. **Review the changed files** — diff, not the whole repo.
2. **Run the checks below**, in this order. Clinical safety first: it is the only category that blocks unconditionally.
3. **List issues by severity.** Confidence-filtered above 80%. Zero findings is a valid outcome — do not manufacture issues.
4. **Fix only the approved scope.** Do not refactor adjacent code you happen to dislike.

## Checks

### Clinical safety — CRITICAL if any fail

- [ ] No diagnosis, drug, dosing, prescription or diet language introduced
- [ ] No code path emits patient-visible content from a non-approved state
- [ ] The deterministic red-flag check still runs before any LLM output could surface
- [ ] Familial claims carry caveats and `unknownParties`
- [ ] `is_biological = false` excluded from hereditary reasoning
- [ ] No real patient data in code, tests, seeds or screenshots

### Security

- [ ] No secrets, keys or connection strings
- [ ] Grant check on every clinical read; consent check on every cross-profile read
- [ ] Audit row written for every cross-profile read
- [ ] New agent tools default to denied and have a denial test
- [ ] Input validated; OCR and LLM output treated as untrusted
- [ ] No raw SQL, no unbounded query
- [ ] Error bodies leak nothing

### Correctness and design

- [ ] Layering respected (`Api → Application → Domain`)
- [ ] DTOs in and out; no entity exposed
- [ ] Explicit error handling; nothing swallowed
- [ ] Ownership respected; shared files edited inside the correct labelled block

### Frontend

- [ ] Loading, empty, error and success states on every data view
- [ ] Search, filter, sort and pagination on every list view
- [ ] Status conveyed by label + colour + icon
- [ ] Touch targets, focus visibility, contrast
- [ ] Unapproved AI content visually distinct and never on a patient screen

### Tests

- [ ] New behaviour has a test that failed before the change
- [ ] Coverage ≥ 80% on the touched service layer
- [ ] Affected priority test cases still pass

### Performance

- [ ] Indexed queries for the baseline, trend, queue and audit views
- [ ] `AsNoTracking()` on reads
- [ ] Agent context kept small (the two-stage model exists for this)
