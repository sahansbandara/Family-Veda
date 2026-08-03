# Testing Plan — Family Veda

Source: blueprint §14.4–14.5. Owner of CI and the test strategy: **S1**. Every member owns their own tests.

## Coverage requirement

**80% minimum on each member's own service layer.** "Testing, CI and Git Workflow" is worth 8 individual marks and is judged on *your* tests, in *your* commits.

## Test layers

| Layer | Tool | Minimum scope |
|---|---|---|
| Backend unit | xUnit + Moq | Every service class · agent tool authorisation · deterministic rule tables |
| Backend integration | WebApplicationFactory + Testcontainers PostgreSQL | Auth flow · consent enforcement · case grant enforcement · full triage workflow |
| React | Vitest + React Testing Library | Reusable components · approval panel · guarded routes |
| Flutter | flutter_test | Widget tests for forms and the status stepper · provider tests |
| Manual | Documented test cases | Cross-platform workflow · device feature · error and emergency paths |

## The 8 priority test cases

**Write these first.** Each maps directly onto a viva question — if the test passes, the answer is demonstrable.

| # | Test | Owner | Maps to viva question |
|---|---|---|---|
| 1 | A doctor without a valid grant receives **403** on case access | S4 | "Can any verified doctor see any patient?" |
| 2 | A revoked consent removes that member's flags from familial analysis | S1 + S4 | "What does consent actually do?" |
| 3 | A member turning 18 moves guardian consents to `PENDING_REAFFIRMATION` | S1 | "What happens when a minor turns 18?" |
| 4 | The Familial Risk Agent's raw-record tool call is **denied and logged** in `tools_denied` | S1 + S4 | "Does the agent read the whole family's records?" |
| 5 | A red-flag symptom bypasses the queue, sets `ESCALATED`, and shows **no AI output** | S4 | "What does the AI do in an emergency?" |
| 6 | An LLM timeout produces a safe failure and **no patient-visible output** | S3 | "What if the LLM fails or hallucinates?" |
| 7 | A non-biological relationship is excluded from hereditary reasoning | S4 | "How do you handle adopted family members?" |
| 8 | A `PENDING` doctor receives **403 on every clinical endpoint** | S4 | "How do you verify a doctor is real?" |

## Integration test files

| File | Owner |
|---|---|
| `tests/IntegrationTests/AuthFlowTests.cs` | S1 |
| `tests/IntegrationTests/ConsentEnforcementTests.cs` | S1 |
| `tests/IntegrationTests/ExtractionAgentTests.cs` | S2 |
| `tests/IntegrationTests/TriageWorkflowTests.cs` | S3 |
| `tests/IntegrationTests/CaseGrantTests.cs` | S4 |
| `tests/IntegrationTests/ToolDenialTests.cs` | S4 |

## TDD workflow

```
RED     → write the failing test that expresses the requirement
GREEN   → the smallest change that makes it pass
REFACTOR→ clean up with the test still green
```

Use the `tdd-guide` agent. Do not write implementation before the test exists.

## Edge cases every service must cover

null · empty collection · invalid type · boundary value · error path · **expired grant** · **revoked consent** · **denied tool** · **LLM timeout** · **malformed LLM JSON** · large data set · special characters in names (Sinhala/Tamil scripts) · concurrent state transition on the same case.

## Testing the agentic subsystem

| What | How |
|---|---|
| Tool allow-list | Unit test per agent × per tool: permitted → allowed, everything else → `ToolDeniedException` **and** a `tools_denied` row |
| Deterministic rule tables | Table-driven tests. Same input, same output, every time |
| Schema validation | Feed a deliberately malformed LLM response; assert one retry then safe failure |
| LLM unavailability | Stub `IOllamaClient` to throw/timeout; assert `AGENT_FAILED` and no patient-visible output |
| Confidence threshold | Below threshold → case still reaches a doctor, marked `LOW_CONFIDENCE`, draft hidden |
| Prohibited content | Feed a draft containing "take 500 mg twice daily"; assert validation fails |
| Emergency ordering | Assert the red-flag check runs **before** any LLM output could be persisted |

**Never assert on exact LLM prose.** Assert on schema, on structured fields, and on what the deterministic layer decided.

## Manual test cases

Documented, repeatable, run before the W7 gate and again before the demo.

| # | Scenario | Expected |
|---|---|---|
| M1 | Full cross-platform workflow from a clean database | Completes unaided in under 10 minutes |
| M2 | Camera lab upload on a **physical Android device** | Image captured, uploaded, OCR attempted, values shown or manual entry offered |
| M3 | Ollama stopped mid-workflow | Safe-failure message on Flutter; nothing unapproved shown |
| M4 | Red-flag complaint submitted | Emergency screen, 1990 call action, zero AI text |
| M5 | Doctor grant expires while the case is open | Next action returns 403 |
| M6 | Consent revoked between two triage runs | Second run omits that member's flags |
| M7 | Offline / no network on mobile | Clear error and retry, no crash, no partial write |
| M8 | Push notification on case approval | Arrives on the device, deep-links to the approved guidance |

## CI pipeline

```yaml
on: [push, pull_request]

jobs:
  backend:
    - checkout
    - setup .NET 8
    - dotnet restore / build / test
    - upload coverage

  web:
    - setup Node
    - npm ci / lint / test / build

  mobile:
    - setup Flutter
    - flutter pub get / analyze / test
    - flutter build apk --debug

  quality:
    - fail if any job fails
    - post status to PR
```

Implementation: `.github/workflows/ci.yml` [S1]. **CI must be green before any merge into `develop`.** The W2 gate is CI green.

## Running tests locally

```bash
cd backend && dotnet test
```

```bash
cd web && npm test
```

```bash
cd mobile && flutter test
```

## Reporting

The consolidated report's testing section (6–10 pages) covers: strategy, the 8 priority cases with results, coverage figures per member, the manual test log, and what was **not** tested and why.
