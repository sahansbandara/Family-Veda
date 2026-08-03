# Workflow: Test

Plan: `docs/TESTING.md`. Coverage requirement: **80% on your own service layer.**

1. Run the layer you changed.
2. Report **exact** pass/fail counts and the coverage figure. Never paraphrase a test result.
3. Fix simple failures immediately.
4. Document unresolved failures with the exact error text — never claim green when it is not.

## Commands

```bash
cd backend && dotnet test
```

```bash
cd web && npm test -- --run
```

```bash
cd mobile && flutter test
```

```bash
cd mobile && flutter analyze
```

## Before a PR

- [ ] The layer you changed is green
- [ ] Coverage on your service layer ≥ 80%
- [ ] New behaviour has a test that failed before your change
- [ ] Any of the 8 priority cases affected by your change still pass
- [ ] `flutter analyze` clean if you touched mobile
- [ ] CI green on the pushed branch

## The 8 priority cases

Write these first; they map one-to-one onto viva questions.

1. Doctor without a grant → 403
2. Revoked consent removes flags from familial analysis
3. Turning 18 → `PENDING_REAFFIRMATION`
4. Familial Risk raw-record call denied and logged
5. Red flag → `ESCALATED`, no AI output
6. LLM timeout → safe failure, nothing patient-visible
7. Non-biological relationship excluded from hereditary reasoning
8. `PENDING` doctor → 403 on every clinical endpoint

## Rules

- Never assert on exact LLM prose. Assert on schema, structured fields, and the deterministic verdict.
- A flaky test is a broken test. Fix or delete — never retry-loop.
- Never mark anything verified without evidence.
