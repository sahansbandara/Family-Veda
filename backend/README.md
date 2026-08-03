# backend — ASP.NET Core Web API

**ONE** solution. Not one per student. Scaffolded in W2.

.NET 8 (LTS) · C# 12 · EF Core 8 + Npgsql · PostgreSQL 16

## Target structure

Legend: `[S1]`–`[S4]` = sole owner, nobody else edits. `⚠ SHARED` = multiple owners, labelled-block convention.

```
backend/
├── src/
│   ├── Api/
│   │   ├── Controllers/
│   │   │   ├── AuthController.cs             [S1]
│   │   │   ├── FamiliesController.cs         [S1]
│   │   │   ├── MembersController.cs          [S1]
│   │   │   ├── RelationshipsController.cs    [S1]
│   │   │   ├── ConsentsController.cs         [S1]
│   │   │   ├── RecordsController.cs          [S2]
│   │   │   ├── LabReportsController.cs       [S2]
│   │   │   ├── VitalsController.cs           [S2]
│   │   │   ├── HereditaryFlagsController.cs  [S2]
│   │   │   ├── EpisodesController.cs         [S3]
│   │   │   ├── TriageCasesController.cs      [S3]
│   │   │   ├── DashboardController.cs        [S3]
│   │   │   ├── NotificationsController.cs    [S3]
│   │   │   ├── DoctorsController.cs          [S4]
│   │   │   ├── AdminDoctorsController.cs     [S4]
│   │   │   ├── ApprovalsController.cs        [S4]
│   │   │   ├── FamilialRiskController.cs     [S4]
│   │   │   └── AuditController.cs            [S4]
│   │   ├── Dtos/{Identity,Records,Triage,Clinical}/
│   │   ├── Validators/
│   │   ├── Middleware/ExceptionMiddleware.cs [S1]
│   │   └── Program.cs                        ⚠ SHARED
│   │
│   ├── Application/
│   │   ├── Services/
│   │   │   ├── AuthService.cs                [S1]
│   │   │   ├── FamilyService.cs              [S1]
│   │   │   ├── ConsentService.cs             [S1]
│   │   │   ├── RecordService.cs              [S2]
│   │   │   ├── LabExtractionService.cs       [S2]
│   │   │   ├── VitalsTrendService.cs         [S2]
│   │   │   ├── EpisodeService.cs             [S3]
│   │   │   ├── TriageOrchestrator.cs         [S3]
│   │   │   ├── NotificationService.cs        [S3]
│   │   │   ├── DoctorVerificationService.cs  [S4]
│   │   │   ├── ApprovalService.cs            [S4]
│   │   │   ├── FamilialRiskService.cs        [S4]
│   │   │   └── AuditService.cs               [S4]
│   │   ├── Agents/
│   │   │   ├── IAgent.cs                     ⚠ SHARED contract
│   │   │   ├── Coordinator.cs                [S3]
│   │   │   ├── ExtractionAgent.cs            [S2]
│   │   │   ├── ContextAgent.cs               [S3]
│   │   │   ├── AnalysisAgent.cs              [S3]
│   │   │   ├── FamilialRiskAgent.cs          [S4]
│   │   │   └── SafetyValidationAgent.cs      [S4]
│   │   └── Authorization/
│   │       ├── ConsentPolicy.cs              [S1]
│   │       ├── CaseGrantPolicy.cs            [S4]
│   │       └── FamilyScopePolicy.cs          [S1]
│   │
│   ├── Domain/
│   │   ├── Entities/                         grouped by owner
│   │   ├── Enums/
│   │   └── RuleTables/
│   │       ├── RedFlagSymptoms.cs            [S4]
│   │       ├── PaediatricVitalRanges.cs      [S4]
│   │       ├── InheritancePatterns.cs        [S4]
│   │       └── AllergyContraindications.cs   [S4]
│   │
│   └── Infrastructure/
│       ├── Persistence/
│       │   ├── AppDbContext.cs               ⚠ SHARED
│       │   ├── Configurations/               one file per entity
│       │   ├── Migrations/                   ⚠ SERIALISED — lock protocol
│       │   └── Seed/SyntheticFamilySeed.cs   [S2]
│       ├── Agents/
│       │   ├── OllamaClient.cs               [S3]
│       │   ├── ToolDispatcher.cs             [S1] ← allow-list enforcement
│       │   └── ToolRegistry.cs               [S1]
│       ├── Ocr/TesseractOcrService.cs        [S2]
│       └── External/FcmNotificationClient.cs [S3]
│
└── tests/
    ├── UnitTests/                            S1/S2/S3/S4 test classes
    └── IntegrationTests/
        ├── AuthFlowTests.cs                  [S1]
        ├── ConsentEnforcementTests.cs        [S1]
        ├── ExtractionAgentTests.cs           [S2]
        ├── TriageWorkflowTests.cs            [S3]
        ├── CaseGrantTests.cs                 [S4]
        └── ToolDenialTests.cs                [S4]
```

## Layer rule

`Api → Application → Domain`. `Infrastructure` implements interfaces declared in `Application` / `Domain`.

**A controller never touches `AppDbContext` directly.**

## Program.cs — labelled DI blocks

Different members edit different lines, so Git merges automatically. Add inside your block; never reorder.

```csharp
// ===== S1 — Identity, Family, Consent =====
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IConsentService, ConsentService>();
builder.Services.AddScoped<IToolDispatcher, ToolDispatcher>();

// ===== S2 — Records & Extraction =====
builder.Services.AddScoped<IRecordService, RecordService>();
builder.Services.AddScoped<ILabExtractionService, LabExtractionService>();

// ===== S3 — Triage & Orchestration =====
builder.Services.AddScoped<ITriageOrchestrator, TriageOrchestrator>();
builder.Services.AddSingleton<IOllamaClient, OllamaClient>();

// ===== S4 — Risk, Doctor, Approval =====
builder.Services.AddScoped<IFamilialRiskService, FamilialRiskService>();
builder.Services.AddScoped<IApprovalService, ApprovalService>();
```

## Migration protocol ⚠

```
1. Announce in the group chat: "taking migration lock, ~20 min"
2. git pull origin develop
3. dotnet ef migrations add 20260814_S2_AddLabReportsAndValues
4. dotnet ef database update        # verify
5. Commit and push immediately
6. Announce: "migration lock released"
```

Never two in flight. Never edit a migration someone already pushed — add a new one.

## Commands

```bash
dotnet restore
```

```bash
dotnet ef database update
```

```bash
dotnet run --project src/Api
```

```bash
dotnet test
```

Swagger: `https://localhost:5001/swagger`

## References

`docs/ARCHITECTURE.md` · `docs/DATABASE.md` · `docs/API_CONTRACT.md` · `docs/AGENTS_DESIGN.md` · `rules/csharp/`
