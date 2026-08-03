# C# / ASP.NET Core Patterns — Family Veda

## Controller

```csharp
[ApiController]
[Route("api/v1/members/{memberId:guid}/records")]
public sealed class RecordsController(IRecordService records) : ControllerBase   // [S2]
{
    [HttpGet]
    [ProducesResponseType(typeof(PagedResult<RecordResponse>), StatusCodes.Status200OK)]
    public async Task<ActionResult<PagedResult<RecordResponse>>> List(
        Guid memberId,
        [FromQuery] RecordQuery query,
        CancellationToken ct)
        => Ok(await records.ListAsync(memberId, query, ct));
}
```

Thin. No business logic, no `DbContext`, no manual authorisation — policies handle that.

## Service

```csharp
public sealed class ConsentService(AppDbContext db, IAuditService audit) : IConsentService  // [S1]
{
    public async Task<ConsentStatus> GetEffectiveStatusAsync(Guid memberId, DataCategory category, CancellationToken ct)
    {
        var consent = await db.Consents
            .AsNoTracking()
            .SingleOrDefaultAsync(c => c.MemberId == memberId && c.DataCategory == category, ct);

        // PENDING_REAFFIRMATION is treated as NOT granted until the member confirms.
        return consent?.Status is ConsentStatus.Granted ? ConsentStatus.Granted : ConsentStatus.NotSet;
    }
}
```

## Authorisation policy

```csharp
public sealed class CaseGrantPolicy(AppDbContext db) : ICaseGrantPolicy   // [S4]
{
    // Access is by grant, not by role (ADR-008).
    public Task<bool> HasAccessAsync(Guid caseId, Guid doctorId, CancellationToken ct)
        => db.CaseAccessGrants.AnyAsync(g =>
               g.TriageCaseId == caseId &&
               g.DoctorId == doctorId &&
               g.RevokedAt == null &&
               g.ExpiresAt > DateTimeOffset.UtcNow, ct);
}
```

## Tool dispatch — default deny

```csharp
public sealed class ToolDispatcher(IToolRegistry registry, IAuditService audit) : IToolDispatcher  // [S1]
{
    public async Task<ToolResult> InvokeAsync(AgentName agent, ToolName tool, ToolArgs args, CancellationToken ct)
    {
        if (!registry.IsAllowed(agent, tool))
        {
            await audit.ToolDeniedAsync(agent, tool, ct);
            throw new ToolDeniedException(agent, tool);   // hard error — the workflow halts
        }

        return await registry.Resolve(tool).ExecuteAsync(args, ct);
    }
}
```

`IsAllowed` returns `false` for anything not explicitly registered. Default deny is the whole point.

## Rule table — pure, deterministic

```csharp
public static class InheritancePatterns   // [S4]
{
    // Hardcoded and cited. Never LLM-generated. See docs/CLINICAL_SAFETY.md.
    public static InheritanceOutcome Evaluate(InheritancePattern pattern, int carrierParents) => pattern switch
    {
        InheritancePattern.AutosomalRecessive when carrierParents < 2 =>
            InheritanceOutcome.ScreeningIndicated("Both parents must be carriers; second-parent status required."),
        ...
    };
}
```

No I/O, no LLM, no DB. Pure function over data, table-driven tests.

## EF Core

- `AsNoTracking()` on every read query.
- Projection to a DTO in the query, not after materialisation.
- Entity configuration in `IEntityTypeConfiguration<T>`, one file per entity.
- Never lazy loading. Explicit `Include` or projection.
- Never raw string SQL.

## Anti-patterns

| Don't | Do |
|---|---|
| `DbContext` in a controller | Inject a service |
| Return an entity | Return a DTO |
| `if (user.IsInRole("DOCTOR"))` for clinical data | `CaseGrantPolicy` |
| `catch (Exception) { }` | Specific exception → `ExceptionMiddleware` |
| Secrets in `appsettings.json` | Environment variables |
| Business logic in a validator | Validator checks shape; service checks rules |
| An LLM call inside a rule table | Never (ADR-007) |
