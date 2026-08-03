# Architecture — Family Veda

Source: blueprint §4. This document is the working reference; the blueprint is authoritative.

## Reference architecture

```
┌──────────────────────────┐        ┌──────────────────────────┐
│   FLUTTER MOBILE APP     │        │    REACT WEB APP         │
│  (Patient / Family)      │        │  (Doctor / Admin)        │
│                          │        │                          │
│ • Register / login       │        │ • Doctor case queue      │
│ • Family member switch   │        │ • Case detail + timeline │
│ • Submit complaint       │        │ • Agent trace viewer     │
│ • Upload lab report      │        │ • APPROVAL GATE          │
│   (CAMERA — device feat.)│        │ • Doctor verification    │
│ • Record vitals          │        │ • Family/consent admin   │
│ • Track case status      │        │ • Dashboards & reports   │
│ • Approved guidance      │        │ • Audit log viewer       │
└───────────┬──────────────┘        └───────────┬──────────────┘
            │                                    │
            │      HTTPS / REST / JSON           │
            │      JWT Bearer Authentication     │
            └──────────────┬─────────────────────┘
                           ▼
      ┌────────────────────────────────────────────────┐
      │        ASP.NET CORE WEB API  (mandatory)       │
      │────────────────────────────────────────────────│
      │  Controllers + DTOs + FluentValidation         │
      │  Application / Service layer                   │
      │  Authentication (JWT) + Authorization policies │
      │  Consent enforcement · Case grant enforcement  │
      │  Business rules · Audit logging                │
      │  Agent orchestration + TOOL DISPATCH LAYER     │
      └───────┬───────────────────────────┬────────────┘
              │ EF Core                    │ internal call only
              ▼                            ▼
   ┌────────────────────┐    ┌──────────────────────────────┐
   │    POSTGRESQL 16   │    │   CONTROLLED AGENTIC AI      │
   │────────────────────│    │──────────────────────────────│
   │ users, families,   │    │  Coordinator / Planner       │
   │ members, consents  │    │    ├─ Extraction Agent  (S2) │
   │ records, labs,     │    │    ├─ Context Agent     (S3) │
   │ vitals             │    │    ├─ Analysis Agent    (S3) │
   │ hereditary_flags   │    │    ├─ Familial Risk     (S4) │
   │ episodes, cases    │    │    └─ Safety/Validation (S4) │
   │ agent_traces       │    │                              │
   │ doctors, grants    │    │  Structured shared state     │
   │ approvals, audit   │    │  Allow-listed tools only     │
   │ EF Core migrations │    │  Ollama (local model)        │
   └────────────────────┘    │  Full execution traces       │
                             └──────────────┬───────────────┘
                                            │
                             ┌──────────────▼───────────────┐
                             │   THIRD-PARTY SERVICE        │
                             │   FCM / Twilio Notifications │
                             │   (called via ASP.NET Core)  │
                             └──────────────────────────────┘
```

## Non-negotiable integration rules

1. React and Flutter consume **the same** ASP.NET Core API. No second backend.
2. React and Flutter share **the same** database, identity, permissions and business rules.
3. The agentic subsystem is **never called directly** by a client. Only ASP.NET Core invokes it.
4. The third-party service is **never called directly** by a client.
5. **No agent holds database credentials.** Agents receive data only through allow-listed backend tools.
6. **No patient-visible output exists that has not passed the doctor approval gate.**

Each rule maps to an explicit specification requirement. Breaking one costs integration marks directly.

## Backend project structure

```
backend/
├── src/
│   ├── Api/               Controllers · Dtos · Validators · Middleware · Program.cs ⚠
│   ├── Application/       Services · Agents · Authorization policies
│   ├── Domain/            Entities · Enums · RuleTables
│   └── Infrastructure/    Persistence (AppDbContext ⚠, Configurations, Migrations ⚠, Seed)
│                          Agents (OllamaClient, ToolDispatcher, ToolRegistry)
│                          Ocr · External (FcmNotificationClient)
└── tests/
    ├── UnitTests/
    └── IntegrationTests/
```

Layer rule: `Api → Application → Domain`, with `Infrastructure` implementing interfaces declared in `Application` / `Domain`. A controller never touches `AppDbContext` directly.

Full file-by-file ownership map: blueprint §14.1.2.

## Why the agentic subsystem runs in-process

**Decision:** the agents run inside the ASP.NET Core process and call Ollama over HTTP on localhost.

**Reason:** invariants 3 and 5 are far easier to *prove* when the tool dispatch layer is a C# class the examiner can read, and the agents literally cannot construct a database connection. A separate agent service would need either its own credentials or its own copy of the tool layer, weakening both the security story and the "single integrated system" requirement.

**Trade-off:** agent code is C#, not Python. Accepted — the module mandates ASP.NET Core, and structured LLM calls over HTTP are unremarkable in C#.

## Request flow — a triage case

```
Flutter  POST /api/v1/episodes/{id}/triage
  → EpisodesController                                  [S3]
  → auth: JWT valid? member inside caller's family?
  → TriageOrchestrator.RunAsync(episodeId)              [S3]
      → create TriageCase (PLANNING), emit trace step 0
      → for each agent in the plan:
            ToolDispatcher.Invoke(agent, tool, args)    [S1]
                → is `tool` in this agent's allow-list?
                     no  → hard error, write tools_denied, halt
                     yes → consent check → data → audit row
            → agent output → JSON schema validation
            → persist trace step
      → SafetyValidationAgent (deterministic)           [S4]
            → red flag?  yes → ESCALATED, zero AI output
                         no  → VALIDATED
      → status = PENDING_DOCTOR_REVIEW
  → 202 Accepted; client polls /triage-cases/{id}/status
```

The gate is a **persisted status**, not a code convention. No method emits patient-visible content from any state other than `APPROVED` or `APPROVED_REVISED`.

## Authorisation layers

Four independent checks, applied in order. Each is separately testable.

| # | Layer | Question | Failure |
|---|---|---|---|
| 1 | Authentication | Is the JWT valid and unexpired? | 401 |
| 2 | Role policy | Is this endpoint open to this `user_type`? | 403 |
| 3 | Scope | Is the target member inside the caller's family, or does an unexpired `case_access_grant` exist? | 403 (404 where existence itself is private) |
| 4 | Consent | For a cross-profile read, is there a `GRANTED` consent for this data category? | 403 + audit row |

A `VERIFIED` doctor with no grant fails at layer 3. A doctor with a grant reading another member's hereditary flags without consent fails at layer 4.

## Frontend structure

### React (`web/`) — clinical and administrative

```
src/
├── pages/       auth/ family/ consents/ [S1] · records/ [S2]
│                dashboard/ traces/ [S3] · doctor/ admin/ audit/ [S4]
├── components/  shared/ ⚠ · family/ records/ triage/ clinical/
├── store/       index.ts ⚠ · slices/{auth,records,cases,doctor}Slice.ts
├── services/    api/ — one client file per owner
├── routes/      AppRouter.tsx ⚠
└── hooks/
```

### Flutter (`mobile/`) — patient and family operational

```
lib/
├── screens/     auth/ family/ [S1] · records/ vitals/ [S2]
│                triage/ notifications/ [S3] · risk/ emergency/ [S4]
├── widgets/     shared/ ⚠ · by owner
├── providers/   one file per owner
├── services/    api/ — one client file per owner
├── models/      mirrors backend DTOs
├── router/      app_router.dart ⚠
└── main.dart ⚠
```

The two surfaces serve deliberately different purposes — a specification requirement, not a stylistic choice. See `design.md`.

## Deployment topology

| Component | Where | Note |
|---|---|---|
| ASP.NET Core API | Render / Azure App Service (free tier) | HTTPS enforced, secrets in env only |
| PostgreSQL 16 | Neon / Supabase (free tier) | Connection string via env only |
| React | Vercel / Netlify | No custom domain purchase |
| Flutter | Signed APK with the report | Tested on a physical Android device |
| Ollama | **Local**, run during the demonstration | Not deployed; hardware requirements documented |

Ollama being local is a deliberate consequence of ADR-006 — health-data residency, zero cost, offline-capable demonstration. The report states plainly that the deployed API cannot run the agent workflow without a reachable Ollama instance, and that the demo runs it locally.

## Related documents

`docs/DATABASE.md` · `docs/API_CONTRACT.md` · `docs/AGENTS_DESIGN.md` · `docs/PERMISSIONS.md` · `docs/DEPLOYMENT.md` · `docs/adr/`
