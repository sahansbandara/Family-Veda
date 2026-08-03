# C# Testing — Family Veda

xUnit + Moq · WebApplicationFactory + Testcontainers PostgreSQL. Plan: `docs/TESTING.md`.

**80% minimum coverage on your own service layer.** Worth 8 individual marks.

## Structure

```
backend/tests/
├── UnitTests/           one test class per service / agent / rule table
└── IntegrationTests/    AuthFlowTests [S1] · ConsentEnforcementTests [S1]
                         ExtractionAgentTests [S2] · TriageWorkflowTests [S3]
                         CaseGrantTests [S4] · ToolDenialTests [S4]
```

Naming: `MethodName_Scenario_ExpectedResult`.

```csharp
[Fact]
public async Task GetEffectiveStatus_WhenPendingReaffirmation_ReturnsNotGranted() { … }
```

## AAA

```csharp
// Arrange
var member = SeedMember(age: 18, consent: ConsentStatus.PendingReaffirmation);

// Act
var status = await sut.GetEffectiveStatusAsync(member.Id, DataCategory.HereditaryFlags, default);

// Assert
Assert.Equal(ConsentStatus.NotSet, status);
```

## Unit tests

- Mock at the interface boundary (`IOllamaClient`, `IToolDispatcher`, `IAuditService`).
- Rule tables are **table-driven** with `[Theory]` + `[InlineData]` / `MemberData`. Same input, same output, proven.
- No database in a unit test. If you need one, it is an integration test.

## Integration tests

- `WebApplicationFactory<Program>` + Testcontainers PostgreSQL. A real schema, a real migration run.
- Each test gets a clean database or a transaction rollback. No cross-test state.
- Assert on status codes and DTO shape, not on internals.

## Testing the agents

| What | How |
|---|---|
| Tool allow-list | Per agent × per tool: permitted → allowed; everything else → `ToolDeniedException` **and** a `tools_denied` row |
| Schema validation | Feed malformed JSON; assert one retry, then safe failure |
| LLM unavailable | Stub `IOllamaClient` to throw/timeout; assert `AGENT_FAILED` and **no patient-visible output** |
| Deterministic rules | `[Theory]` over the whole table |
| Prohibited content | Feed "take 500 mg twice daily"; assert validation fails |
| Emergency ordering | Assert the red-flag check runs **before** any LLM output is persisted |
| Confidence | Below threshold → `LOW_CONFIDENCE`, draft hidden |

**Never assert on exact LLM prose.** Assert on schema, structured fields, and the deterministic verdict.

## The 8 priority tests — write these first

1. Doctor without a grant → 403 [S4]
2. Revoked consent removes flags from familial analysis [S1+S4]
3. Turning 18 → `PENDING_REAFFIRMATION` [S1]
4. Familial Risk raw-record call denied and logged [S1+S4]
5. Red flag → `ESCALATED`, no AI output [S4]
6. LLM timeout → safe failure, nothing patient-visible [S3]
7. Non-biological relationship excluded from hereditary reasoning [S4]
8. `PENDING` doctor → 403 on every clinical endpoint [S4]

## Edge cases every service covers

null · empty · invalid type · boundary · error path · expired grant · revoked consent · denied tool · LLM timeout · malformed LLM JSON · large data set · Sinhala/Tamil characters in names · concurrent transition on the same case.

## Rules

- TDD: RED → GREEN → REFACTOR. Test before implementation.
- No `Thread.Sleep` in tests. Use deterministic clocks and fakes.
- A flaky test is a broken test. Fix it or delete it — never retry-loop it.
- Never mark anything verified without pasting the output.
