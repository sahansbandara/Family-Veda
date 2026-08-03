# Workflow: Commit

**Never commit on another member's behalf.** Individual marks depend on `git log --author`.

1. **Review the diff.** Every file — no blind `git add .`.
2. **Confirm no secrets.** No keys, tokens, connection strings, `.env`, `google-services.json`, keystores.
3. **Confirm ownership.** Every file is yours or a `⚠ SHARED` file edited inside your labelled block.
4. **Run the checks.** Tests green; `code-reviewer` run; `security-reviewer` run if this touches auth, consent, grants, input, endpoints, agent tools or audit.
5. **Clinical safety check** if this touches agents, advisories, rule tables or patient-visible content — see `rules/clinical-safety.md`.
6. **Ask approval before committing or pushing.**
7. **Conventional commit with your owner scope.**

## Message format

```
feat(s3): add coordinator planning step

Coordinator now validates the request shape, creates the TriageCase in
PLANNING, and emits trace step 0 before any agent runs.

Refs: agent/TODO.md W5
```

Types: `feat` `fix` `refactor` `test` `docs` `chore` `perf` `ci`
Scope: `s1` `s2` `s3` `s4` — your owner ref.

## Branch

Work on `feature/s<n>-<slug>`. PR into `develop`. Never push directly to `main` or `develop`.

## Before pushing

- [ ] `git pull origin develop` and resolve conflicts locally
- [ ] Tests still green after the merge
- [ ] Commit is small enough to review — a 40-file PR guarantees conflicts
