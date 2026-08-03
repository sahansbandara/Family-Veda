# API Specification

The written contract lives in [`docs/API_CONTRACT.md`](../API_CONTRACT.md). This directory holds the **generated** artefact.

| File | Source | Owner | Due |
|---|---|---|---|
| `openapi.yaml` | Exported from the running Swagger endpoint | S1 (export) · all (endpoints) | Drafted W1, exported W8 |

## Exporting

With the API running:

```bash
curl -s https://localhost:5001/swagger/v1/swagger.json -o docs/api/swagger.json
```

Convert to YAML if preferred, and commit as `openapi.yaml`.

## Rules

1. **W1 draft first.** The contract is agreed before the endpoints are written, so four authors build against the same shape.
2. **Re-export at the W8 gate**, after the last endpoint lands. The committed spec must match the deployed API.
3. A breaking change inside the semester is coordinated at the Thursday integration meeting and announced in the group chat — both clients land it in the same cycle.
4. No secrets, no real credentials, and no example bodies containing anything resembling real patient data.
