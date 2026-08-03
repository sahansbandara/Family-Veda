# Family Veda

> **Your family doctor, with your family's whole story.**

Longitudinal family health context and agentic clinical triage platform.

**SE3090 — Software Engineering Frameworks** · SLIIT Faculty of Computing · Assignment 1 · Group **SE_016** · submission `SE3090_SE016`

---

## What it does

Sri Lanka has family doctors, but they operate without patient history. Every consultation starts from zero, so patients bypass their GP and go straight to hospitals.

Family Veda closes that gap. A family maintains one shared account with individual member records, lab reports and vitals. When a member reports a complaint, a multi-agent workflow assembles their personal baseline, analyses deviations, checks consented hereditary signals across the family, and applies deterministic clinical safety rules. The result is a **prepared case file, not a diagnosis**. A verified doctor reviews it, revises it, and approves it. Only then does the patient see anything.

**The AI does context. The doctor does medicine.**

## Architecture

```
┌──────────────────────────┐        ┌──────────────────────────┐
│   FLUTTER MOBILE APP     │        │    REACT WEB APP         │
│  (Patient / Family)      │        │  (Doctor / Admin)        │
└───────────┬──────────────┘        └───────────┬──────────────┘
            │        HTTPS / REST / JSON        │
            │        JWT Bearer Authentication  │
            └──────────────┬────────────────────┘
                           ▼
      ┌────────────────────────────────────────────────┐
      │        ASP.NET CORE WEB API                    │
      │  Controllers · Services · Auth policies        │
      │  Consent enforcement · Case grant enforcement  │
      │  Audit logging · Agent orchestration           │
      │  TOOL DISPATCH LAYER (allow-list enforced)     │
      └───────┬───────────────────────────┬────────────┘
              │ EF Core                   │ internal call only
              ▼                           ▼
   ┌────────────────────┐    ┌──────────────────────────────┐
   │    POSTGRESQL 16   │    │   CONTROLLED AGENTIC AI      │
   │  20 tables         │    │   Coordinator / Planner      │
   │  EF Core migrations│    │    ├─ Extraction Agent       │
   └────────────────────┘    │    ├─ Context Agent          │
                             │    ├─ Analysis Agent         │
                             │    ├─ Familial Risk Agent    │
                             │    └─ Safety/Validation      │
                             │   Ollama (local model)       │
                             └──────────────┬───────────────┘
                                            ▼
                             ┌──────────────────────────────┐
                             │  FCM / Twilio Notifications  │
                             │  (called via ASP.NET Core)   │
                             └──────────────────────────────┘
```

Full diagram and reasoning: [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

## The agentic workflow

```
Flutter complaint → Coordinator → Context Agent → Analysis Agent
  → Familial Risk Agent → Safety/Validation Agent (deterministic)
  → ⏸ DOCTOR APPROVAL GATE ⏸ → notification → patient
```

| Agent | Scope | Reads raw records | Uses LLM | Owner |
|---|---|---|---|---|
| Extraction | One member | ✔ own member | ✔ | S2 |
| Context | One member | ✔ own member | ✔ structuring | S3 |
| Analysis | One member | ✔ own member | ✔ trend reasoning | S3 |
| Familial Risk | Family — **flags only** | ✘ hard denied at dispatch | ✔ signal wording | S4 |
| Safety / Validation | Case output | ✘ | ✘ **deterministic** | S4 |

Design detail: [`docs/AGENTS_DESIGN.md`](docs/AGENTS_DESIGN.md).

## Safety position

- The system **never diagnoses**. It assembles context.
- No AI output reaches a patient without licensed doctor approval — enforced architecturally, with no bypass path.
- Clinical safety checks are deterministic rule tables, never LLM judgement.
- Family history yields a **screening indication**, never a diagnosis.
- In an emergency the system deliberately shows a referral and **zero AI output**.
- **Synthetic data only.** No real patient data is used anywhere in this project.

Full boundaries: [`docs/CLINICAL_SAFETY.md`](docs/CLINICAL_SAFETY.md).

## Repository layout

```
Family-Veda/
├── backend/     ONE ASP.NET Core solution (Api · Application · Domain · Infrastructure + tests)
├── web/         ONE React 18 application (Vite)
├── mobile/      ONE Flutter 3.x application
├── docs/        blueprint · adr/ · diagrams/ · api/ · ai-disclosure/ · individual-reports/
├── agent/       BRIEF · TODO · MEMORY · DECISIONS
├── rules/       coding and safety rules by scope
├── skills/      project-scoped agent skills
├── workflows/   build · test · commit · deploy · audit · handoff · human-approval
└── .github/     workflows/ci.yml · pull_request_template.md
```

One application, four authors — **not** a folder per student. Reasoning: blueprint §14.1.1.

## Tech stack

| Layer | Technology |
|---|---|
| Backend | ASP.NET Core Web API, C# 12, .NET 8 (LTS) |
| ORM | EF Core 8 + Npgsql |
| Database | PostgreSQL 16 |
| Web | React 18 (Vite) · React Router · Redux Toolkit |
| Mobile | Flutter 3.x · go_router · Riverpod · flutter_secure_storage |
| LLM | Ollama (local) — `llama3.1:8b` |
| OCR | Tesseract / Google ML Kit on-device |
| CI | GitHub Actions |
| Testing | xUnit + Moq · Vitest + RTL · flutter_test · Testcontainers |
| Notifications | Firebase Cloud Messaging (fallback: Twilio SMS) |

## Local setup

### Prerequisites

- .NET 8 SDK
- PostgreSQL 16 (local or Docker)
- Node.js 20+
- Flutter 3.x with an Android toolchain
- [Ollama](https://ollama.com) with `llama3.1:8b` pulled
- Tesseract (if running server-side OCR)

### 1. Database

```bash
createdb familyveda
```

### 2. Environment

```bash
cp .env.example .env
```

Fill in the values locally. **Never commit `.env`.** Variable reference: [`docs/ENV_VARS.md`](docs/ENV_VARS.md).

### 3. Backend

```bash
cd backend && dotnet restore && dotnet ef database update && dotnet run --project src/Api
```

Swagger UI: `https://localhost:5001/swagger`

### 4. Ollama

```bash
ollama pull llama3.1:8b && ollama serve
```

### 5. Web

```bash
cd web && npm ci && npm run dev
```

### 6. Mobile

```bash
cd mobile && flutter pub get && flutter run
```

> Setup commands are written against the structure defined in blueprint §14.1.2. They become runnable as each project is scaffolded during W2.

## Testing

```bash
cd backend && dotnet test
```

```bash
cd web && npm test
```

```bash
cd mobile && flutter test
```

Test plan and the 8 priority cases: [`docs/TESTING.md`](docs/TESTING.md).

## Team

| Ref | IT Number | Name | Component |
|---|---|---|---|
| S1 | IT23544154 | Samaranayaka S.G.V.S | Family, Identity & Consent · CI · tool-permission layer |
| S2 | IT24101875 | Fernando K.R.N | Health Records & Extraction · OCR · Extraction Agent |
| S3 | IT24100551 | Karunathilaka K.D.J.C (**Group Leader**) | Triage & Orchestration · Coordinator, Context, Analysis Agents |
| S4 | IT24100559 | W.M.S.S.B. Wasala | Familial Risk & Clinical Approval · Safety rule tables |

## Documentation

| Document | Contents |
|---|---|
| [`docs/Family_Veda_Project_Blueprint.md`](docs/Family_Veda_Project_Blueprint.md) | Full blueprint — the source of truth |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | System architecture and integration rules |
| [`docs/DATABASE.md`](docs/DATABASE.md) | Schema, 20 tables, state machines, seed policy |
| [`docs/API_CONTRACT.md`](docs/API_CONTRACT.md) | Endpoints, conventions, status codes |
| [`docs/AGENTS_DESIGN.md`](docs/AGENTS_DESIGN.md) | Agents, tool permission matrix, traces |
| [`docs/CLINICAL_SAFETY.md`](docs/CLINICAL_SAFETY.md) | Advice boundaries, emergency path, genetics framing |
| [`docs/PERMISSIONS.md`](docs/PERMISSIONS.md) | Roles, access principles, permission matrix |
| [`docs/AUDIT_LOGGING.md`](docs/AUDIT_LOGGING.md) | What is audited and how |
| [`docs/TESTING.md`](docs/TESTING.md) | Test plan and priority cases |
| [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) | Hosting and the evaluator access package |
| [`docs/TIMELINE.md`](docs/TIMELINE.md) | Nine-week plan, gates, contingencies |
| [`docs/RISK_REGISTER.md`](docs/RISK_REGISTER.md) | Risks and mitigations |
| [`docs/VIVA_PREP.md`](docs/VIVA_PREP.md) | Viva questions, phrasing, memory hooks |
| [`docs/FUTURE_WORK.md`](docs/FUTURE_WORK.md) | Deliberate deferrals with reserved extension points |
| [`docs/adr/`](docs/adr/) | ADR-001 … ADR-009 |

## AI use disclosure

Development uses AI assistance at Level 4 (permitted, disclosed, verified). The final demonstration and viva are Level 1 — no external AI assistants; only the submitted application's own agentic subsystem runs.

Each member maintains `docs/ai-disclosure/S<n>.md`. Individual reflections are **never AI-generated**.

## Licence and data policy

Academic coursework. All clinical framing is for a university software engineering project and **does not constitute medical guidance**. All data used is synthetic.
