# FAMILY VEDA

## Longitudinal Family Health Context & Agentic Clinical Triage Platform

### SE3090 — Software Engineering Frameworks · Assignment 1 · Group SE_016

---

| Field | Detail |
|---|---|
| **Project name** | Family Veda |
| **Tagline** | Your family doctor, with your family's whole story. |
| **Module** | SE3090 — Software Engineering Frameworks |
| **Institution** | SLIIT — Faculty of Computing |
| **Programme** | BSc (Hons) IT — Software Engineering / Artificial Intelligence |
| **Academic level** | Year 3, Semester 1 (2026) |
| **Group ID** | SE_016 |
| **Lab group** | Y3.S1.SE.WE.01.01 |
| **Assignment** | Assignment 1 — Group Full-Stack and Agentic AI Project |
| **Weighting** | 25% of module · 100 marks (30 group + 70 individual) |
| **Duration** | 31 July 2026 → 30 September 2026 (9 weeks) |
| **Due** | Wednesday 30 September 2026, 11:50 PM |
| **Submission name** | `SE3090_SE016` |
| **Evaluation** | 10-minute demonstration + 20-minute viva |
| **Mandatory stack** | ASP.NET Core Web API · PostgreSQL · React · Flutter · Agentic AI |
| **AI use** | Level 4 during development (disclosed) · Level 1 during demo and viva |
| **Access maintained until** | 21 October 2026 |

---

## Project Name and Description

**Name:** **Family Veda** — *vedā* (වෙදා) is the Sinhala word for the traditional healer or doctor. The name states the product's thesis directly: this is the family's doctor, restored to the position of knowing the whole family over time.

**Pronunciation:** *VAY-daa* (වෙදා). Not to be confused with *vaeda* (වැඩ), meaning "work".

**One-line description**

> Family Veda gives Sri Lankan family doctors the longitudinal patient context they currently lack, using a controlled multi-agent AI system that assembles each member's health history, detects deviations from their personal baseline, and surfaces consented familial risk signals — with every output requiring licensed doctor approval before it reaches a patient.

**Elevator description (use in the report and the demo video intro)**

> Sri Lanka has family doctors, but they operate without patient history. Every consultation starts from zero, so patients bypass their GP and go straight to hospitals. Family Veda closes that gap. A family maintains one shared account with individual member records, lab reports and vitals. When a member reports a complaint, a four-agent workflow assembles their personal baseline, analyses deviations, checks consented hereditary signals across the family, and applies deterministic clinical safety rules. The result is a prepared case file, not a diagnosis. A verified doctor reviews it, revises it, and approves it. Only then does the patient see anything. The AI does context; the doctor does medicine.

**Alternative names considered** (documented for the report's naming rationale)

| Name | Note |
|---|---|
| **Family Veda** | ✔ **Selected.** Names the role the product restores — the family's doctor. Locally rooted, immediately meaningful to Sri Lankan users, and readable to an English-speaking evaluator |
| Pavula Care | *pavula* = family; describes the account structure rather than the clinical value |
| Kulaya Health | *kulaya* = lineage; carries unwanted caste connotation |
| VedaCare | Cleaner in English, but loses the "family" half of the thesis |
| MedLink Family | Descriptive and forgettable |

---

# Table of Contents

| § | Section |
|---|---|
| 1 | [Team and Component Allocation](#1-team-and-component-allocation) |
| 2 | [Problem Statement and Domain Justification](#2-problem-statement-and-domain-justification) |
| 3 | [Scope — Frozen](#3-scope--frozen) |
| 4 | [System Architecture](#4-system-architecture) |
| 5 | [Roles, Permissions and Access Model](#5-roles-permissions-and-access-model) |
| 6 | [Agentic AI Subsystem Design](#6-agentic-ai-subsystem-design) |
| 7 | [AI Advice Boundaries and Emergency Handling](#7-ai-advice-boundaries-and-emergency-handling) |
| 8 | [Database Design](#8-database-design) |
| 9 | [API Contract](#9-api-contract) |
| 10 | [React Web Application](#10-react-web-application) |
| 11 | [Flutter Mobile Application](#11-flutter-mobile-application) |
| 12 | [Doctor Enrolment and Verification](#12-doctor-enrolment-and-verification) |
| 13 | [Nine-Week Timeline](#13-nine-week-timeline) |
| 14 | [Git, CI/CD and Testing](#14-git-cicd-and-testing) |
| 15 | [Deployment](#15-deployment) |
| 16 | [Architecture Decision Records](#16-architecture-decision-records) |
| 17 | [Safety, Ethics and AI Disclosure](#17-safety-ethics-and-ai-disclosure) |
| 18 | [Future Work — Deliberate Deferrals](#18-future-work--deliberate-deferrals) |
| 19 | [Marks Mapping](#19-marks-mapping) |
| 20 | [Viva Preparation Pack](#20-viva-preparation-pack) |
| 21 | [Risk Register](#21-risk-register) |
| 22 | [Deliverables Checklist](#22-deliverables-checklist) |
| A | [One-Page Summary](#appendix-a--one-page-summary) |
| B | [Glossary](#appendix-b--glossary) |

---

# 1. Team and Component Allocation

## 1.1 Group SE_016

| Ref | IT Number | Name | Component | Role note |
|---|---|---|---|---|
| **S1** | IT23544154 | Samaranayaka S.G.V.S | **Family, Identity & Consent** | + Testing/CI lead |
| **S2** | IT24101875 | Fernando K.R.N | **Health Records & Extraction** | + OCR pipeline |
| **S3** | IT24100551 | Karunathilaka K.D.J.C | **Triage & Agent Orchestration** | **Group Leader** · + notification service |
| **S4** | IT24100559 | W.M.S.S.B. Wasala | **Familial Risk & Clinical Approval** | + deterministic rule tables |

> Allocation is a proposal to be confirmed in the Week 1 group meeting. What is **not** negotiable: every member owns one business component and delivers it across all five technologies.

## 1.2 The Allocation Rule

```
❌ WRONG SPLIT              ✔ CORRECT SPLIT
──────────────────         ──────────────────────────────
A = backend                A = one business feature,
B = frontend                   built across API + DB +
C = mobile                     React + Flutter + Agent
D = AI                     (same for B, C, D)
```

**Why:** 70 of 100 marks are individual, and every individual rubric band reads *"the student can explain, test, modify, or debug"* their contribution. A member who only did frontend can answer only one of six individual criteria.

## 1.3 Allocation Matrix

| | **S1 — Samaranayaka** | **S2 — Fernando** | **S3 — Karunathilaka** | **S4 — Wasala** |
|---|---|---|---|---|
| **Business component** | Family accounts, members, relationships, consent, authentication | Health records, lab reports, OCR, vitals, hereditary flag extraction | Episodes, triage workflow, agent orchestration, notifications | Familial risk, doctor lifecycle, approval gate, audit |
| **API** | `/auth/*` `/families/*` `/members/*` `/consents/*` | `/records/*` `/lab-reports/*` `/vitals/*` `/hereditary-flags` | `/episodes/*` `/triage-cases/*` `/dashboard` `/notifications/*` | `/doctors/*` `/admin/doctors/*` `/approve` `/familial-risk` `/audit` |
| **DB tables** | `users` `families` `members` `relationships` `consents` | `health_records` `lab_reports` `lab_values` `vitals` `hereditary_flags` | `episodes` `triage_cases` `agent_traces` | `doctors` `doctor_verification_log` `family_doctor_assignments` `case_access_grants` `approvals` `audit_log` |
| **React** | Family management, consent management | Record browser, lab viewer, trend charts | Family dashboard, case list | Doctor queue, case detail, **approval panel**, verification queue, audit viewer |
| **Flutter** | Register/login, family setup, member switcher | **Camera lab upload (device feature)**, record entry, vitals | Complaint submission, status tracker, notifications | Risk view, screening recommendations, approved guidance |
| **Agents** | — (owns the tool-permission enforcement layer) | **Extraction Agent** | **Coordinator + Context + Analysis Agents** | **Familial Risk + Safety/Validation Agents** |
| **Extra** | CI pipeline, JWT policies | OCR, file storage | Third-party notifications, tool dispatch | Rule tables, audit strategy |

## 1.4 Workload Balance

| Component | API | DB | React | Flutter | Agents | Special |
|---|:-:|:-:|:-:|:-:|:-:|---|
| S1 Family/Identity | ●● | ●● | ●● | ●●● | — | CI + auth layer |
| S2 Records | ●● | ●●● | ●● | ●● | 1 | OCR |
| S3 Triage | ●● | ●● | ● | ●● | 3 | Notifications |
| S4 Risk/Approval | ●●● | ●●● | ●●● | ● | 2 | Rule tables |

**On S1 having no agent:** S1 owns the tool-permission enforcement layer that every agent depends on, plus the CI pipeline. Both are directly assessed. S1's individual report must state this explicitly so the examiner sees the agentic contribution.

## 1.5 Shared Obligations (every member)

- [ ] Unit tests for own service layer
- [ ] At least 2 pull request reviews per week
- [ ] Own ADR contributions
- [ ] Own individual report section and reflection (**never AI-generated**)
- [ ] Own AI-use disclosure log, updated weekly
- [ ] Able to demo, modify and debug own component live in the viva

---

# 2. Problem Statement and Domain Justification

## 2.1 The Gap

Sri Lanka has a functioning network of family doctors. Patients still bypass them for hospitals and private specialists, even for routine complaints — fever, weight concerns, blood sugar checks, lab report interpretation.

The reason is not availability. It is **loss of continuity**.

```
CURRENT REALITY
──────────────────────────────────────────────
Visit 1  →  Doctor A   →  paper record   →  lost
Visit 2  →  Doctor B   →  starts at zero →  lost
Visit 3  →  Hospital   →  starts at zero →  lost

Every consultation begins with no history.
The doctor has no baseline for this patient.
The patient perceives no added value in the GP.
──────────────────────────────────────────────
```

A family doctor's core professional advantage is knowing the patient **over time** and knowing the **family**. Without a record system, that advantage does not exist in practice.

## 2.2 The Proposition

```
FAMILY VEDA MODEL
──────────────────────────────────────────────
One family account, individual member records
        ↓
Longitudinal history: records, labs, vitals
        ↓
Member reports a complaint (mobile)
        ↓
Four agents assemble: personal baseline, trends,
   deviations, consented familial risk signals
        ↓
Doctor receives a prepared, structured case
        ↓
Doctor revises. Doctor approves. Doctor is accountable.
        ↓
Patient receives doctor-approved guidance only.
──────────────────────────────────────────────
```

## 2.3 Positioning Statement

> Family Veda does not diagnose. It closes the **context gap**. The AI performs context assembly, trend analysis and deviation flagging. Clinical judgement, decision and accountability remain entirely with the licensed doctor, enforced architecturally through a mandatory approval gate.

## 2.4 Specification Fit

| Specification requirement | How Family Veda satisfies it |
|---|---|
| At least three user roles | Five: Family Head, Family Member (18+), Doctor, Clinic Admin, Agent |
| One major business component per student | Four naturally separable components (§1) |
| CRUD plus business-specific operations | Members, records, lab reports, episodes, triage cases, approvals |
| Status workflows | Triage case lifecycle · doctor verification lifecycle · consent lifecycle |
| Search, filter, sort, pagination, reporting | Record browser, doctor queue, family dashboard, audit viewer |
| Different React and Flutter purposes | React = clinical/administrative · Flutter = patient/family operational |
| One complete cross-platform workflow | Flutter submission → agents → React approval → Flutter result |
| Meaningful third-party service | Notification service (FCM or Twilio) via backend |
| Non-trivial authorisation | Family-scoped, consent-gated, case-scoped, time-bound grants |
| Multi-step agentic problem | Longitudinal context assembly is inherently multi-step, multi-source |
| Genuine human approval gate | Clinically mandatory, architecturally unbypassable |

---

# 3. Scope — Frozen

> **Scope discipline rule.** Scope froze at the end of Week 5. Any idea raised after that point goes to §18 Future Work and receives zero lines of code. This rule exists because the assessed core (agentic workflow, integrated system, deployment, documentation) is worth 100 marks and the deferred features are worth zero.

## 3.1 In Scope — v1

| # | Capability | Owner |
|---|---|---|
| 1 | Family account with member profiles and biological relationships | S1 |
| 2 | Role-based authentication and authorisation (5 roles) | S1 |
| 3 | Granular consent management (per member, per data category) | S1 |
| 4 | Health record repository: conditions, allergies, medications, surgeries | S2 |
| 5 | Lab report upload with camera capture and OCR extraction | S2 |
| 6 | Structured hereditary flag extraction from records | S2 |
| 7 | Vitals recording and trend computation | S2 |
| 8 | Episode/complaint submission from mobile | S3 |
| 9 | Agentic triage workflow (Coordinator + 4 agents) | S3 + S4 |
| 10 | Agent trace persistence and viewer | S3 |
| 11 | Deterministic clinical safety validation | S4 |
| 12 | Familial risk signal detection across consented profiles | S4 |
| 13 | Doctor review, revise, approve, reject, escalate workflow | S4 |
| 14 | Doctor self-registration and admin verification | S4 + S1 |
| 15 | Time-bound, case-scoped access grants | S4 |
| 16 | Full audit logging of cross-profile access | S4 |
| 17 | Push/SMS notification on case status change | S3 |
| 18 | Family health dashboard and reporting | S3 |
| 19 | Emergency red-flag detection and safe-failure path | S4 |

## 3.2 Out of Scope — v1

| Excluded | Reason |
|---|---|
| Appointment booking and doctor scheduling | ~1.5 weeks of work, zero rubric marks. Extension point reserved (§18) |
| Payment / billing | Zero rubric marks; regulatory exposure disproportionate to an academic prototype |
| External calendar sync (Google/Outlook OAuth) | Zero rubric marks; OAuth integration cost |
| Live video consultation (WebRTC) | High cost; async consultation already satisfies the cross-platform workflow requirement |
| Personalised meal plans, diet targets, exercise prescriptions | **Clinical nutrition therapy.** Unsafe without a clinician; zero rubric marks (§7) |
| Direct urgent medical advice from the AI | **Architecturally prohibited.** Emergency path deliberately shows no AI output (§7) |
| Automated SLMC registry verification | No public API exists. Manual admin verification in v1 |
| Pharmacy / e-prescription dispensing | Regulated; outside academic scope |
| Wearable device integration | Scope creep |
| Real patient data of any kind | Ethical and legal risk. Synthetic seed data only |

---

# 4. System Architecture

## 4.1 Reference Architecture

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
   │    POSTGRESQL      │    │   CONTROLLED AGENTIC AI      │
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

## 4.2 Non-Negotiable Integration Rules

1. React and Flutter consume **the same** ASP.NET Core API. No second backend.
2. React and Flutter share **the same** database, identity, permissions and business rules.
3. The Agentic AI subsystem is **never called directly** by a client. Only ASP.NET Core invokes it.
4. The third-party service is **never called directly** by a client.
5. No agent holds database credentials. Agents receive data only through allow-listed backend tools.
6. No patient-visible output exists that has not passed the doctor approval gate.

## 4.3 Technology Stack

| Layer | Technology | Target |
|---|---|---|
| Backend | ASP.NET Core Web API, C# 12 | .NET 8 (LTS) |
| ORM | Entity Framework Core + Npgsql | EF Core 8 |
| Database | PostgreSQL | 16 |
| Web | React (Vite) + React Router | React 18 |
| Web state | Redux Toolkit (ADR-004) | — |
| Mobile | Flutter / Dart | Flutter 3.x |
| Mobile routing | go_router | — |
| Mobile state | Riverpod (ADR-005) | — |
| Secure storage | flutter_secure_storage | — |
| LLM runtime | Ollama, local (ADR-006) | llama3.1:8b |
| OCR | Tesseract / Google ML Kit on-device | — |
| API docs | Swagger / OpenAPI | built-in |
| CI | GitHub Actions | — |
| Testing | xUnit, Vitest + RTL, flutter_test | — |
| Notifications | Firebase Cloud Messaging (fallback: Twilio SMS) | — |

---

# 5. Roles, Permissions and Access Model

## 5.1 Role Definitions

| Role | Description | Can see |
|---|---|---|
| **Family Head** | Creator/administrator of the family account | Own record; minors' records in the family; family dashboard; consent settings for minors |
| **Family Member (18+)** | Adult member with independent rights | Own record only; own consent settings; can revoke sharing |
| **Doctor (VERIFIED)** | Licensed practitioner, admin-verified | Only cases with an active grant, only for the grant window |
| **Clinic Admin** | Platform administrator | Doctor verification queue; system config; **no clinical data** |
| **Agent (system)** | Non-human actor | Only what an allow-listed tool returns, always scoped |

## 5.2 Access Principles

```
PRINCIPLE 1 — Data minimisation
   Give the minimum data that answers the question.

PRINCIPLE 2 — Access by grant, not by role
   Being a doctor grants nothing. A case grant grants access.

PRINCIPLE 3 — Consent crosses profiles, files do not
   Hereditary FLAGS may cross member boundaries.
   Raw records never do.

PRINCIPLE 4 — Every cross-profile read is audited
   No silent access. Ever.

PRINCIPLE 5 — Adults own their data
   At 18, consent authority transfers from guardian to member.
```

## 5.3 Permission Matrix

| Action | Family Head | Member 18+ | Doctor (granted) | Doctor (no grant) | Clinic Admin |
|---|:-:|:-:|:-:|:-:|:-:|
| Create family | ✔ | ✘ | ✘ | ✘ | ✘ |
| Add member | ✔ | ✘ | ✘ | ✘ | ✘ |
| View own record | ✔ | ✔ | n/a | n/a | n/a |
| View minor's record (own family) | ✔ | ✘ | ✘ | ✘ | ✘ |
| View adult member's record | ✘ | ✔ self | ✔ in case | ✘ | ✘ |
| Set consent for self | ✔ | ✔ | ✘ | ✘ | ✘ |
| Set consent for minor | ✔ | ✘ | ✘ | ✘ | ✘ |
| Submit episode | ✔ | ✔ | ✘ | ✘ | ✘ |
| View triage case | ✔ own family | ✔ own | ✔ granted only | ✘ | ✘ |
| View agent trace | ✘ | ✘ | ✔ | ✘ | ✔ metadata only |
| Approve / reject case | ✘ | ✘ | ✔ | ✘ | ✘ |
| Verify doctor | ✘ | ✘ | ✘ | ✘ | ✔ |
| View audit log | ✔ own family | ✔ own | ✘ | ✘ | ✔ system |

## 5.4 Consent State Machine

```
        ┌──────────────┐
        │  NOT_SET     │  (default — nothing shared)
        └──────┬───────┘
               │ member or guardian grants
               ▼
        ┌──────────────┐   revoke    ┌──────────────┐
        │   GRANTED    │ ──────────► │   REVOKED    │
        └──────┬───────┘             └──────┬───────┘
               │ member turns 18            │ re-grant
               ▼                            ▼
   ┌────────────────────────┐         ┌──────────────┐
   │ PENDING_REAFFIRMATION  │         │   GRANTED    │
   │ guardian consent no    │         └──────────────┘
   │ longer valid — treated │
   │ as NOT GRANTED         │
   └────────────────────────┘
```

> **Business rule.** When a member reaches 18, all guardian-granted consents move to `PENDING_REAFFIRMATION` and are treated as **not granted** until the member personally confirms. Strong viva talking point.

---

# 6. Agentic AI Subsystem Design

## 6.1 Why This Is Agentic, Not a Chatbot

| Specification requirement | Family Veda implementation |
|---|---|
| Accepts a domain objective | "Assess this member's complaint against their longitudinal baseline" |
| Plans multiple steps | Coordinator produces an ordered plan of agent invocations |
| Delegates to distinct agents | 4 agents with different scopes, tools, inputs and outputs |
| Uses controlled tools | Explicit allow-list per agent, enforced at dispatch — not advisory |
| Persists structured state | `triage_cases`, `agent_traces`, `hereditary_flags` |
| Deterministic validation | Rule tables and reference ranges — not LLM judgement |
| Pauses for authorised approval | Mandatory doctor approval gate with no bypass path |
| Records observability evidence | Per-step trace: input hash, tools requested/denied, output, confidence, latency, tokens |
| Returns auditable result or safe failure | Approved advisory, or explicit safe-failure referral |

## 6.2 Full Workflow

```
   FLUTTER — member submits complaint
   { memberId, symptoms[], vitals{}, durationDays, attachments[] }
                    │
                    ▼
   ┌────────────────────────────────────────────────────────┐
   │  COORDINATOR / PLANNER                          (S3)   │
   │  • Validates request shape                             │
   │  • Creates TriageCase (status: PLANNING)               │
   │  • Produces ordered execution plan                     │
   │  • Emits trace step 0                                  │
   └────────────────────┬───────────────────────────────────┘
                        ▼
   ┌────────────────────────────────────────────────────────┐
   │  AGENT 1 — CONTEXT AGENT      (S3)   scope: ONE member │
   │  Tools: read_member_profile, read_member_vitals,        │
   │         read_member_episodes, read_member_conditions    │
   │  DENIED: any other member, any family-wide read         │
   │  Output: MemberContext {                                │
   │      baselineVitals, chronicConditions, allergies,      │
   │      medications, recentEpisodes[], age, sex }          │
   │  Status → CONTEXT_READY                                 │
   └────────────────────┬───────────────────────────────────┘
                        ▼
   ┌────────────────────────────────────────────────────────┐
   │  AGENT 2 — ANALYSIS AGENT     (S3)   scope: ONE member │
   │  Tools: read_lab_trends, compute_deviation              │
   │  Task: Is this complaint consistent with this person's  │
   │        own baseline, or is it a deviation?              │
   │  Output: AnalysisFindings {                             │
   │      deviations[], trendSummary, recurrencePattern,     │
   │      timeline[], confidence }                           │
   │  Status → ANALYSED                                      │
   └────────────────────┬───────────────────────────────────┘
                        ▼
   ┌────────────────────────────────────────────────────────┐
   │  AGENT 3 — FAMILIAL RISK AGENT (S4)  scope: FAMILY     │
   │  Tools: read_consented_hereditary_flags,                │
   │         read_relationship_graph,                        │
   │         lookup_inheritance_pattern                      │
   │  DENIED: read raw records of ANY member  ◄── critical  │
   │  Task: Do consented family flags create a screening     │
   │        indication for this member?                      │
   │  Output: FamilialRiskSignal {                           │
   │      signals[], inheritanceNote,                        │
   │      screeningRecommendations[], unknownParties[] }     │
   │  Status → RISK_ASSESSED                                 │
   └────────────────────┬───────────────────────────────────┘
                        ▼
   ┌────────────────────────────────────────────────────────┐
   │  AGENT 4 — SAFETY / VALIDATION AGENT (S4)              │
   │  ⚠ DETERMINISTIC. No LLM decision. Rule tables only.   │
   │  Checks:                                                │
   │   ▸ Red-flag symptom table    → EMERGENCY override      │
   │   ▸ Age-adjusted vital ranges → out-of-range flag       │
   │   ▸ Allergy contraindication table                      │
   │   ▸ Duration thresholds (fever > 3 days in a child)     │
   │   ▸ Output JSON schema validation                       │
   │   ▸ Prohibited-content check: no diagnosis language,    │
   │     no drug dosing, no prescription, no meal plan       │
   │  Any red flag → BYPASS queue → immediate escalation     │
   │  Status → VALIDATED  or  ESCALATED                      │
   └────────────────────┬───────────────────────────────────┘
                        ▼
        ┌───────────────────────────────────┐
        │  STATE PERSISTED  → PostgreSQL    │
        │  TriageCase + all AgentTrace rows │
        └───────────────┬───────────────────┘
                        ▼
        ╔═══════════════════════════════════════════╗
        ║   ⏸  DOCTOR APPROVAL GATE  ⏸              ║
        ║   Status: PENDING_DOCTOR_REVIEW           ║
        ║   No code path bypasses this state.       ║
        ║                                           ║
        ║   REACT — doctor sees:                    ║
        ║    • member timeline                      ║
        ║    • flagged deviations                   ║
        ║    • familial risk signals + caveats      ║
        ║    • draft advisory (never patient-shown) ║
        ║    • full agent trace, every step         ║
        ║    • confidence and stated unknowns       ║
        ║                                           ║
        ║   Doctor actions:                         ║
        ║    ✔ APPROVE          → APPROVED          ║
        ║    ✎ REVISE + approve → APPROVED_REVISED  ║
        ║    ↩ REQUEST_INFO     → AWAITING_INFO     ║
        ║    ✘ REJECT           → REJECTED          ║
        ║    🚨 ESCALATE        → ESCALATED         ║
        ╚═══════════════════════════════════════════╝
                        │
                        ▼
        Notification (third-party) → Flutter
        Member receives DOCTOR-APPROVED guidance only.
```

## 6.3 Agent Comparison Table — *viva critical*

| | Context Agent | Analysis Agent | Familial Risk Agent | Safety Agent |
|---|---|---|---|---|
| **Owner** | S3 | S3 | S4 | S4 |
| **Scope** | One member | One member | Family (flags only) | Case output |
| **Reads raw records** | ✔ own member | ✔ own member | ✘ **hard denied** | ✘ |
| **Reads other members** | ✘ | ✘ | ✔ flags only, consented | ✘ |
| **Uses LLM** | ✔ structuring | ✔ trend reasoning | ✔ signal wording | ✘ **deterministic** |
| **Primary output** | MemberContext | AnalysisFindings | FamilialRiskSignal | ValidationVerdict |
| **Can halt workflow** | ✘ | ✘ | ✘ | ✔ emergency override |

> This table is the single strongest evidence that the agents are **distinct**, not one prompt renamed four times. Every member memorises it.

## 6.4 Tool Permission Matrix

| Tool | Extraction | Context | Analysis | Familial Risk | Safety |
|---|:-:|:-:|:-:|:-:|:-:|
| `read_member_profile(memberId)` | ✔ self | ✔ self | ✘ | ✘ | ✘ |
| `read_member_vitals(memberId)` | ✘ | ✔ self | ✔ self | ✘ | ✘ |
| `read_member_episodes(memberId)` | ✘ | ✔ self | ✔ self | ✘ | ✘ |
| `read_raw_record(recordId)` | ✔ self | ✔ self | ✔ self | ✘ **denied** | ✘ |
| `ocr_extract(fileUrl)` | ✔ | ✘ | ✘ | ✘ | ✘ |
| `write_hereditary_flag(...)` | ✔ | ✘ | ✘ | ✘ | ✘ |
| `read_lab_trends(memberId)` | ✘ | ✘ | ✔ self | ✘ | ✘ |
| `compute_deviation(series, baseline)` | ✘ | ✘ | ✔ | ✘ | ✘ |
| `read_consented_hereditary_flags(familyId)` | ✘ | ✘ | ✘ | ✔ | ✘ |
| `read_relationship_graph(familyId)` | ✘ | ✘ | ✘ | ✔ | ✘ |
| `lookup_inheritance_pattern(condition)` | ✘ | ✘ | ✘ | ✔ | ✘ |
| `validate_against_rules(payload)` | ✘ | ✘ | ✘ | ✘ | ✔ |
| `write_prescription` | ✘ | ✘ | ✘ | ✘ | ✘ **exists for no agent** |
| `send_to_patient` | ✘ | ✘ | ✘ | ✘ | ✘ **doctor-approved only** |

> Enforcement lives in the backend tool-dispatch layer (owned by S1), not in the prompt. A denied call returns a hard error and is written to `agent_traces.tools_denied` as a violation. **Demonstrate this live in the viva** — very few groups will be able to.

## 6.5 Two-Stage Data Model

```
STAGE 1 — EXTRACTION (isolated, per member)          [S2]
┌──────────────────────────────────────────────────┐
│  Extraction Agent — runs on lab report upload    │
│  scope: ONE member                               │
│  input: that member's lab reports and records    │
│  process: OCR → parse → identify hereditary-     │
│           relevant findings → structure          │
│  output row → hereditary_flags:                  │
│    { memberId, conditionCode, status,            │
│      evidenceRef, confidence, extractedAt }      │
│                                                  │
│  ⚠ Raw record content NEVER leaves this stage.   │
└─────────────────────┬────────────────────────────┘
                      ▼
        ┌──────────────────────────────┐
        │ PostgreSQL: hereditary_flags │
        │ small · structured           │
        │ consent-gated · audit-logged │
        └─────────────┬────────────────┘
                      ▼
STAGE 2 — FAMILIAL ANALYSIS (family-wide)            [S4]
┌──────────────────────────────────────────────────┐
│  Familial Risk Agent                             │
│  scope: FAMILY, but flags table ONLY             │
│  input: consented flags + relationship graph     │
│  deterministic: inheritance pattern table        │
│  output: risk signal + screening recommendation  │
│                                                  │
│  ⚠ raw-record tool DENIED at dispatch layer.     │
└──────────────────────────────────────────────────┘
```

**Justification (viva).** A hereditary risk assessment needs roughly 20 tokens of structured fact per relative, not 8,000 tokens of raw history. Passing full records would increase privacy exposure, enlarge the hallucination surface, bloat LLM context and add no analytical capability. **Flags cross profile boundaries; files do not.**

## 6.6 Familial Risk — Correct Genetic Framing

> **Never claim inheritance. Claim a screening indication.**

| ❌ Wrong output | ✔ Correct output |
|---|---|
| "Son has thalassaemia because his father does" | "First-degree relative is a confirmed β-thalassaemia carrier. Maternal carrier status is unknown. Screening (HbA2, full blood count) is indicated before any conclusion." |
| "This condition is inherited automatically" | "Autosomal recessive: both parents must be carriers for the condition to manifest. One carrier parent alone is insufficient." |
| "Your son will have hair loss like his father" | "Androgenetic alopecia is polygenic with contributions from both parental lines. No predictive claim can be made." |

**Inheritance reference table** — hardcoded, cited, deterministic, **not LLM-generated**:

| Pattern | One carrier/affected parent | Both carriers | System output |
|---|---|---|---|
| Autosomal recessive (β-thalassaemia, cystic fibrosis) | 0% affected · 50% carrier | 25% affected · 50% carrier | Screening indicated; second-parent status required |
| Autosomal dominant (Huntington's, familial hypercholesterolaemia) | 50% affected | — | Screening indicated |
| X-linked recessive (haemophilia, G6PD deficiency) | Depends on child's sex and which parent | — | Screening indicated; sex-specific note |
| Polygenic / multifactorial (type 2 diabetes, hypertension, alopecia) | Increased relative risk only | — | Risk factor noted; **no predictive claim** |

> **Design detail.** `relationships.is_biological` is mandatory. Adoptive and step relationships must be excluded from hereditary reasoning. Strong viva point.

## 6.7 Safe Failure Behaviour

| Failure mode | System behaviour |
|---|---|
| LLM unavailable or times out | `AGENT_FAILED`; member sees "Please consult your doctor directly"; no partial output |
| Output fails schema validation | Retry once; second failure → safe failure path |
| Red-flag symptom detected | Bypass queue → `ESCALATED` → immediate doctor broadcast + emergency guidance |
| Confidence below threshold | Case still goes to a doctor, marked `LOW_CONFIDENCE`, draft advisory hidden |
| Denied tool call attempted | Hard error, logged as violation, workflow halts |
| No doctor available within SLA | Escalate to shared pool; if still unassigned → advise in-person care |
| OCR fails on a lab report | Report stored, `ocr_status = FAILED`, manual entry offered; no guessed values |

> **Under no failure condition does the system show an unapproved AI output to a patient.**

## 6.8 Observability — Trace Record

```
agent_traces row:
{
  traceId, triageCaseId, stepNumber,
  agentName, agentVersion,
  inputSummary, inputHash (SHA-256),
  toolsRequested[], toolsAllowed[], toolsDenied[],
  outputSummary, outputSchemaValid,
  confidence, latencyMs, tokenCount,
  modelName, status, errorMessage,
  createdAt
}
```

This is what the doctor's Agent Trace panel renders and what is shown to the examiner during the demonstration.

---

# 7. AI Advice Boundaries and Emergency Handling

## 7.1 What the AI May and May Not Produce

| ✔ Permitted | ❌ Prohibited |
|---|---|
| Explain a lab report factually ("HbA1c 7.2, reference below 5.7, above range") | Personalised meal plans or calorie targets |
| Show trends across a member's own reports | Personalised behavioural prescriptions ("do this, don't do that") |
| Flag deviation from the member's own baseline | Drug names, doses, or prescriptions |
| Recommend a screening test | Diagnosis or probable-diagnosis language |
| Surface consented familial risk signals | Any urgent medical advice delivered without doctor approval |
| Draft an advisory **for doctor review** | Any output shown to a patient before approval |

**Rationale for excluding meal plans.** A dietary plan for a diabetic, renal, pregnant or paediatric patient is clinical nutrition therapy. An incorrect plan causes real harm, it carries zero rubric marks, and it cannot be defended in a viva. Generic, sourced public-health information may be included **only** as part of a doctor-approved advisory.

## 7.2 Emergency Path — Deliberately AI-Silent

```
   Member reports symptoms
            ↓
   SAFETY AGENT — deterministic red-flag table
   (chest pain, breathing difficulty, altered
    consciousness, uncontrolled bleeding, seizure,
    fever > 3 days in a child under 5, etc.)
            │
      HIT   ├──► ⚠ EMERGENCY SCREEN
            │    "Seek immediate in-person medical care."
            │    • Emergency number 1990 (Suwa Seriya)
            │    • Nearest hospital list
            │    • Case broadcast to all verified doctors
            │    • Family Head notified immediately
            │    ✘ NO AI-generated guidance shown. NONE.
            │
      MISS  └──► normal triage → doctor approval gate
```

> **Viva line.** "In an emergency our system deliberately says less, not more. The red-flag check is deterministic and runs before any LLM output could reach the user. Silence plus a referral is the safe failure mode; AI advice in an emergency is not."

## 7.3 Required Disclaimers

**In-app, both platforms, persistently visible on any advisory screen:**

> This is a clinical decision-support tool. It does not provide medical diagnosis. All guidance is reviewed and approved by a licensed doctor before you receive it. In an emergency, seek immediate in-person medical care.

**In the report:** an explicit ethics section stating the synthetic-data policy, the non-diagnostic positioning, and the approval-gate architecture.

---

# 8. Database Design

## 8.1 Entity Relationship Overview

```
                        ┌──────────┐
                        │  users   │
                        └────┬─────┘
             ┌───────────────┼───────────────┐
             ▼               ▼               ▼
       ┌──────────┐   ┌───────────┐   ┌───────────┐
       │ families │   │  doctors  │   │  admins   │
       └────┬─────┘   └─────┬─────┘   └───────────┘
            │ 1:N            │
            ▼                │
      ┌───────────┐          │
      │  members  │          │
      └─────┬─────┘          │
            │                │
   ┌────────┼────────┬───────┼──────────┬─────────────┐
   ▼        ▼        ▼       │          ▼             ▼
┌──────┐ ┌──────┐ ┌──────┐   │   ┌───────────┐ ┌──────────────┐
│health│ │ lab  │ │vitals│   │   │relation-  │ │  consents    │
│_recs │ │_repts│ │      │   │   │  ships    │ │              │
└──┬───┘ └──┬───┘ └──────┘   │   └───────────┘ └──────────────┘
   │        │ 1:N            │
   │        ▼                │
   │   ┌──────────┐          │
   │   │lab_values│          │
   │   └────┬─────┘          │
   └────┬───┘                │
        ▼                    │
┌────────────────┐           │
│hereditary_flags│           │
└────────────────┘           │
                             │
      ┌───────────┐          │
      │ episodes  │          │
      └─────┬─────┘          │
            ▼                │
   ┌────────────────┐        │
   │  triage_cases  │◄───────┘  assignment + grant
   └───┬────────┬───┘
       │        │
       ▼        ▼
┌────────────┐ ┌──────────────┐   ┌────────────────────┐
│agent_traces│ │  approvals   │   │ case_access_grants │
└────────────┘ └──────────────┘   └────────────────────┘

           ┌─────────────┐
           │  audit_log  │  ← written from everywhere
           └─────────────┘
```

## 8.2 Identity and Family — Owner S1

### `users`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK, default `gen_random_uuid()` |
| email | varchar(255) | UNIQUE, NOT NULL |
| password_hash | varchar(255) | NOT NULL |
| full_name | varchar(200) | NOT NULL |
| phone | varchar(20) | |
| user_type | enum | NOT NULL — `FAMILY_USER`, `DOCTOR`, `ADMIN` |
| is_active | boolean | NOT NULL, default true |
| created_at / updated_at | timestamptz | NOT NULL |

Indexes: `idx_users_email` (unique), `idx_users_type`

### `families`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| family_name | varchar(150) | NOT NULL |
| head_user_id | uuid | FK → users(id), NOT NULL |
| primary_doctor_id | uuid | FK → doctors(id), NULLABLE |
| created_at / updated_at | timestamptz | NOT NULL |

### `members`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| family_id | uuid | FK → families(id) ON DELETE CASCADE, NOT NULL |
| user_id | uuid | FK → users(id), NULLABLE (minors have no login) |
| full_name | varchar(200) | NOT NULL |
| date_of_birth | date | NOT NULL, CHECK ≤ CURRENT_DATE |
| sex | enum | `MALE`, `FEMALE`, `OTHER` |
| blood_group | varchar(5) | |
| guardian_member_id | uuid | FK → members(id), NULLABLE |
| created_at / updated_at | timestamptz | NOT NULL |

Indexes: `idx_members_family`, `idx_members_dob`

### `relationships`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| family_id | uuid | FK → families(id) |
| member_id | uuid | FK → members(id) |
| related_member_id | uuid | FK → members(id) |
| relation_type | enum | `PARENT`, `CHILD`, `SIBLING`, `SPOUSE` |
| **is_biological** | boolean | NOT NULL — **critical for genetic reasoning** |

Constraints: `UNIQUE(member_id, related_member_id)`, `CHECK (member_id <> related_member_id)`

### `consents`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id), NOT NULL |
| data_category | enum | `HEREDITARY_FLAGS`, `VITALS_SUMMARY`, `CONDITIONS` |
| status | enum | `NOT_SET`, `GRANTED`, `REVOKED`, `PENDING_REAFFIRMATION` |
| granted_by_user_id | uuid | FK → users(id) |
| granted_at / revoked_at / expires_at | timestamptz | NULLABLE |

Constraint: `UNIQUE(member_id, data_category)`

## 8.3 Health Records — Owner S2

### `health_records`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id), NOT NULL |
| record_type | enum | `CONDITION`, `ALLERGY`, `MEDICATION`, `SURGERY`, `IMMUNISATION` |
| title | varchar(200) | NOT NULL |
| description | text | |
| onset_date | date | |
| is_chronic | boolean | default false |
| recorded_by_user_id | uuid | FK → users(id) |
| created_at / updated_at | timestamptz | NOT NULL |

Indexes: `idx_records_member_type`, `idx_records_member_created`

### `lab_reports`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id), NOT NULL |
| report_type | varchar(100) | `FBC`, `FBS`, `HbA1c`, `LIPID`, `HB_ELECTROPHORESIS` |
| report_date | date | NOT NULL |
| file_url | varchar(500) | |
| file_type | enum | `IMAGE`, `PDF` |
| ocr_status | enum | `PENDING`, `PROCESSING`, `COMPLETED`, `FAILED` |
| ocr_raw_text | text | |
| uploaded_by_user_id | uuid | FK → users(id) |
| created_at | timestamptz | NOT NULL |

### `lab_values`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| lab_report_id | uuid | FK → lab_reports(id) ON DELETE CASCADE |
| analyte_code | varchar(50) | `HB`, `WBC`, `HBA2`, `MCV`, `GLUCOSE_F` |
| value | numeric(10,3) | NOT NULL |
| unit | varchar(20) | NOT NULL |
| reference_low / reference_high | numeric(10,3) | |
| is_abnormal | boolean | |

Index: `idx_labvalues_analyte` — supports trend queries

### `vitals`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id) |
| recorded_at | timestamptz | NOT NULL |
| height_cm / weight_kg | numeric(6,2) | |
| bmi | numeric(5,2) | computed |
| temperature_c | numeric(4,1) | |
| systolic_bp / diastolic_bp | integer | |
| pulse_bpm | integer | |
| blood_sugar_mgdl | numeric(6,2) | |
| source | enum | `SELF_REPORTED`, `CLINIC`, `LAB` |

Index: `idx_vitals_member_time` — the baseline query index

### `hereditary_flags` ⭐ *two-stage bridge table*

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id), NOT NULL |
| condition_code | varchar(50) | NOT NULL — e.g. `BETA_THAL_CARRIER` |
| condition_name | varchar(200) | NOT NULL |
| inheritance_pattern | enum | `AUTOSOMAL_RECESSIVE`, `AUTOSOMAL_DOMINANT`, `X_LINKED`, `POLYGENIC` |
| status | enum | `CONFIRMED`, `SUSPECTED`, `RULED_OUT` |
| evidence_ref | uuid | FK → lab_reports(id) or health_records(id) |
| evidence_type | enum | `LAB_REPORT`, `HEALTH_RECORD`, `CLINICIAN_ENTERED` |
| confidence | numeric(3,2) | 0.00–1.00 |
| extracted_by | varchar(50) | `EXTRACTION_AGENT` or `MANUAL` |
| verified_by_doctor_id | uuid | FK → doctors(id), NULLABLE |
| created_at | timestamptz | NOT NULL |

Constraint: `UNIQUE(member_id, condition_code)` · Indexes: `idx_flags_member`, `idx_flags_condition`

## 8.4 Triage and Agents — Owner S3

### `episodes`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id), NOT NULL |
| submitted_by_user_id | uuid | FK → users(id) |
| chief_complaint | varchar(300) | NOT NULL |
| symptoms | jsonb | array of symptom codes |
| duration_days | integer | |
| severity_self | integer | CHECK 1–10 |
| notes | text | |
| created_at | timestamptz | NOT NULL |

### `triage_cases`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| episode_id | uuid | FK → episodes(id), NOT NULL |
| member_id | uuid | FK → members(id), NOT NULL |
| status | enum | see state machine §8.6 |
| priority | enum | `ROUTINE`, `URGENT`, `EMERGENCY` |
| assigned_doctor_id | uuid | FK → doctors(id), NULLABLE |
| assigned_at | timestamptz | |
| sla_expires_at | timestamptz | assigned_at + 6 hours |
| context_output | jsonb | Agent 1 |
| analysis_output | jsonb | Agent 2 |
| familial_risk_output | jsonb | Agent 3 |
| validation_output | jsonb | Agent 4 |
| draft_advisory | text | never patient-visible unapproved |
| overall_confidence | numeric(3,2) | |
| created_at / updated_at | timestamptz | NOT NULL |

Indexes: `idx_cases_status_priority`, `idx_cases_doctor`, `idx_cases_member`

### `agent_traces`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| triage_case_id | uuid | FK → triage_cases(id) ON DELETE CASCADE |
| step_number | integer | NOT NULL |
| agent_name / agent_version | varchar | NOT NULL |
| input_summary | jsonb | |
| input_hash | varchar(64) | SHA-256 |
| tools_requested / tools_denied | jsonb | arrays — **violations visible here** |
| output_summary | jsonb | |
| output_schema_valid | boolean | |
| confidence | numeric(3,2) | |
| latency_ms / token_count | integer | |
| model_name | varchar(100) | |
| status | enum | `SUCCESS`, `FAILED`, `DENIED`, `TIMEOUT` |
| error_message | text | |
| created_at | timestamptz | NOT NULL |

Constraint: `UNIQUE(triage_case_id, step_number)`

## 8.5 Doctor, Approval and Audit — Owner S4

### `doctors`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| user_id | uuid | FK → users(id), UNIQUE, NOT NULL |
| slmc_reg_no | varchar(30) | UNIQUE, NOT NULL |
| specialty / qualification | varchar | |
| certificate_url | varchar(500) | |
| verification_status | enum | `PENDING`, `VERIFIED`, `INFO_REQUESTED`, `REJECTED`, `SUSPENDED` |
| verified_by_user_id | uuid | FK → users(id), NULLABLE |
| verified_at | timestamptz | NULLABLE |
| created_at / updated_at | timestamptz | NOT NULL |

### `doctor_verification_log`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| doctor_id | uuid | FK → doctors(id) |
| action | enum | `SUBMITTED`, `APPROVED`, `INFO_REQUESTED`, `REJECTED`, `SUSPENDED`, `REINSTATED` |
| actor_user_id | uuid | FK → users(id) |
| reason | text | |
| created_at | timestamptz | NOT NULL |

### `family_doctor_assignments`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| family_id | uuid | FK → families(id) |
| doctor_id | uuid | FK → doctors(id) |
| is_primary | boolean | NOT NULL |
| assigned_at / revoked_at | timestamptz | |

### `case_access_grants` ⭐ *the security story table*

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| triage_case_id | uuid | FK → triage_cases(id) |
| doctor_id | uuid | FK → doctors(id) |
| granted_at | timestamptz | NOT NULL |
| expires_at | timestamptz | NOT NULL |
| revoked_at | timestamptz | NULLABLE |
| granted_reason | enum | `PRIMARY_DOCTOR`, `POOL_CLAIM`, `ESCALATION` |

> Authorisation checks read this table, **not** the user's role.

### `approvals`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| triage_case_id | uuid | FK → triage_cases(id) |
| doctor_id | uuid | FK → doctors(id) |
| decision | enum | `APPROVED`, `APPROVED_REVISED`, `INFO_REQUESTED`, `REJECTED`, `ESCALATED` |
| doctor_notes | text | |
| final_advisory | text | what the patient actually receives |
| decided_at | timestamptz | NOT NULL |

### `audit_log`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| actor_user_id | uuid | FK → users(id), NULLABLE (null = system/agent) |
| actor_type | enum | `USER`, `DOCTOR`, `ADMIN`, `AGENT`, `SYSTEM` |
| action | varchar(100) | e.g. `CROSS_PROFILE_FLAG_READ` |
| resource_type / resource_id | varchar / uuid | |
| subject_member_id | uuid | FK → members(id), NULLABLE |
| consent_ref_id | uuid | FK → consents(id), NULLABLE |
| ip_address | inet | |
| metadata | jsonb | |
| created_at | timestamptz | NOT NULL |

Indexes: `idx_audit_subject_time`, `idx_audit_actor_time`

## 8.6 Triage Case State Machine

```
        SUBMITTED
            │
            ▼
        PLANNING ────────────────► AGENT_FAILED
            │                          │
            ▼                          ▼
      CONTEXT_READY              safe-failure notice
            │                    "consult doctor directly"
            ▼
        ANALYSED
            │
            ▼
      RISK_ASSESSED
            │
            ▼
        VALIDATED ──── red flag ──► ESCALATED
            │                          │
            ▼                          ▼
  PENDING_DOCTOR_REVIEW ◄──────────────┘
            │
   ┌────────┼────────┬──────────────┬────────────┐
   ▼        ▼        ▼              ▼            ▼
APPROVED  APPROVED  AWAITING_INFO  REJECTED   ESCALATED
          _REVISED     │
            │          │ member responds
            ▼          ▼
        DELIVERED   (back to PENDING_DOCTOR_REVIEW)
            │
            ▼
         CLOSED
```

## 8.7 Seed Data Policy

**Synthetic data only. No real patient records under any circumstances.**

Seed one demonstration family of four with clinically plausible, internally consistent history:

| Member | Profile | Demonstrates |
|---|---|---|
| Father, 46 | Confirmed β-thalassaemia carrier (elevated HbA2), type 2 diabetes | Hereditary flag source |
| Mother, 42 | Carrier status **unknown** | `unknownParties` output |
| Son, 12 | Recurrent fever, mild anaemia on FBC | The live demo triage case |
| Daughter, 19 | Recently turned 18 | `PENDING_REAFFIRMATION` consent rule |

Plus: 2 doctors (1 `VERIFIED`, 1 `PENDING`) and 1 clinic admin — demonstrates the verification workflow live.

---

# 9. API Contract

## 9.1 Conventions

| Aspect | Rule |
|---|---|
| Base path | `/api/v1` |
| Auth | `Authorization: Bearer <JWT>` |
| Content type | `application/json` |
| Errors | RFC 7807 Problem Details |
| Pagination | `?page=1&pageSize=20`, response carries `totalCount` |
| Filtering | `?status=&from=&to=` |
| Sorting | `?sortBy=createdAt&sortDir=desc` |
| Async | All actions `async Task<ActionResult<T>>` |
| DTOs | Request and response DTOs always — entities never exposed |
| Validation | FluentValidation → 400 with field-level errors |

## 9.2 Status Code Policy

| Code | Used for |
|---|---|
| 200 | Successful GET / PUT |
| 201 | Successful POST with `Location` header |
| 204 | Successful DELETE |
| 400 | Validation failure |
| 401 | Missing or invalid token |
| 403 | Authenticated but not permitted (no grant / no consent) |
| 404 | Not found, or not visible to the caller |
| 409 | Business rule conflict (e.g. duplicate SLMC number) |
| 422 | Agent workflow cannot proceed |
| 500 | Unhandled — logged, generic message returned |

## 9.3 Endpoints by Owner

### S1 — Identity, Family, Consent

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/auth/register` | Register family user |
| POST | `/auth/login` | Obtain JWT |
| POST | `/auth/refresh` | Refresh token |
| GET | `/families/me` | Current user's family |
| POST | `/families` | Create family |
| PUT | `/families/{id}` | Update family |
| GET | `/families/{id}/members` | List members (paged) |
| POST | `/families/{id}/members` | Add member |
| GET | `/members/{id}` | Member detail |
| PUT | `/members/{id}` | Update member |
| DELETE | `/members/{id}` | Remove member |
| GET | `/members/{id}/relationships` | Relationship graph |
| POST | `/members/{id}/relationships` | Add relationship |
| GET | `/members/{id}/consents` | Consent settings |
| PUT | `/members/{id}/consents/{category}` | Grant / revoke |
| POST | `/members/{id}/consents/reaffirm` | 18+ reaffirmation |

### S2 — Health Records and Extraction

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/members/{id}/records` | List records (paged, filtered) |
| POST | `/members/{id}/records` | Create record |
| PUT | `/records/{id}` | Update record |
| DELETE | `/records/{id}` | Delete record |
| GET | `/members/{id}/lab-reports` | List lab reports |
| POST | `/members/{id}/lab-reports` | Upload (multipart) |
| GET | `/lab-reports/{id}` | Report detail + parsed values |
| POST | `/lab-reports/{id}/extract` | Trigger Extraction Agent |
| GET | `/members/{id}/vitals` | Vitals series |
| POST | `/members/{id}/vitals` | Record vitals |
| GET | `/members/{id}/vitals/trends` | Computed trends |
| GET | `/members/{id}/hereditary-flags` | Flags for member |

### S3 — Episodes, Triage, Notifications

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/members/{id}/episodes` | Submit complaint |
| GET | `/members/{id}/episodes` | Episode history |
| POST | `/episodes/{id}/triage` | Start agentic workflow |
| GET | `/triage-cases/{id}` | Case detail |
| GET | `/triage-cases/{id}/status` | Poll status |
| GET | `/triage-cases/{id}/traces` | Agent traces |
| GET | `/families/{id}/triage-cases` | Family case list |
| GET | `/families/{id}/dashboard` | Aggregated dashboard |
| POST | `/notifications/subscribe` | Register device token |

### S4 — Risk, Doctor, Approval, Audit

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/doctors/register` | Doctor self-registration |
| GET | `/doctors/me` | Doctor profile + status |
| GET | `/admin/doctors?status=PENDING` | Verification queue |
| POST | `/admin/doctors/{id}/verify` | Approve |
| POST | `/admin/doctors/{id}/request-info` | Request more info |
| POST | `/admin/doctors/{id}/reject` | Reject |
| POST | `/admin/doctors/{id}/suspend` | Suspend |
| GET | `/doctors/me/cases` | Assigned case queue |
| POST | `/triage-cases/{id}/claim` | Claim from pool |
| POST | `/triage-cases/{id}/approve` | Approve |
| POST | `/triage-cases/{id}/revise` | Revise and approve |
| POST | `/triage-cases/{id}/reject` | Reject |
| POST | `/triage-cases/{id}/escalate` | Escalate |
| GET | `/members/{id}/familial-risk` | Risk assessment |
| GET | `/audit?subjectMemberId=` | Audit trail |

---

# 10. React Web Application

## 10.1 Purpose

React is the **clinical and administrative** surface. It is deliberately not a patient app — the specification requires React and Flutter to serve different, meaningful purposes.

## 10.2 Screen Inventory

| # | Screen | Role | Owner | Key features |
|---|---|---|---|---|
| 1 | Login / Register | All | S1 | JWT, role-based redirect |
| 2 | Doctor Case Queue | Doctor | S4 | Table, filter by priority/status, sort, pagination, SLA countdown |
| 3 | Case Detail | Doctor | S4 | Member timeline, deviation flags, familial signals, draft advisory |
| 4 | Agent Trace Viewer | Doctor | S3 | Step-by-step trace, tools requested/denied, confidence, latency |
| 5 | Approval Panel | Doctor | S4 | Approve / Revise / Request info / Reject / Escalate |
| 6 | Doctor Profile | Doctor | S4 | Verification status, credentials |
| 7 | Doctor Verification Queue | Admin | S4 | Pending list, certificate viewer, approve/reject |
| 8 | Family Management | Family Head | S1 | Members CRUD, relationships |
| 9 | Consent Management | Head / Member | S1 | Per-category toggles, reaffirmation prompts |
| 10 | Record Browser | Family | S2 | Search, filter, sort, paginate |
| 11 | Lab Report Viewer | Family | S2 | Parsed values, reference ranges, trend chart |
| 12 | Family Health Dashboard | Family Head | S3 | Vitals trends, case history, flag summary |
| 13 | Audit Log Viewer | Head / Admin | S4 | Who accessed what, when, under which consent |
| 14 | System Reports | Admin | S3 | Usage, agent performance, SLA compliance |

## 10.3 Required Technical Features

- Functional components and Hooks only
- React Router with **protected routes** and role guards
- Reusable component library: `<DataTable>` `<StatusBadge>` `<TimelineChart>` `<TraceStep>` `<ConfirmDialog>` `<EmptyState>` `<ErrorBoundary>`
- Redux Toolkit for auth/session and case queue state (ADR-004)
- Loading, empty, success and error states on every data view
- Client-side validation mirroring server rules
- Responsive layout, accessible markup (labels, focus order, contrast)
- Search, filter, sort and pagination on every list view

## 10.4 Component Tree

```
<App>
 ├── <AuthProvider>
 ├── <Router>
 │    ├── /login                  → <LoginPage>                [S1]
 │    ├── /doctor        [guard: DOCTOR + VERIFIED]
 │    │    ├── /queue             → <CaseQueue>                [S4]
 │    │    │                        ├── <FilterBar>
 │    │    │                        ├── <DataTable>
 │    │    │                        └── <Pagination>
 │    │    └── /cases/:id         → <CaseDetail>               [S4]
 │    │                             ├── <MemberTimeline>       [S2]
 │    │                             ├── <DeviationPanel>       [S3]
 │    │                             ├── <FamilialRiskPanel>    [S4]
 │    │                             ├── <AgentTraceViewer>     [S3]
 │    │                             └── <ApprovalPanel>        [S4]
 │    ├── /admin         [guard: ADMIN]
 │    │    ├── /doctors           → <VerificationQueue>        [S4]
 │    │    └── /reports           → <SystemReports>            [S3]
 │    └── /family        [guard: FAMILY_HEAD | MEMBER]
 │         ├── /members           → <MemberManagement>         [S1]
 │         ├── /consents          → <ConsentManagement>        [S1]
 │         ├── /records           → <RecordBrowser>            [S2]
 │         ├── /dashboard         → <FamilyDashboard>          [S3]
 │         └── /audit             → <AuditLogViewer>           [S4]
 └── <ErrorBoundary>
```

---

# 11. Flutter Mobile Application

## 11.1 Purpose

Flutter is the **patient and family operational** surface — a different purpose from React, as the specification requires.

## 11.2 Screen Inventory

| # | Screen | Owner | Key features |
|---|---|---|---|
| 1 | Onboarding / Login | S1 | Secure token storage (`flutter_secure_storage`) |
| 2 | Family Setup | S1 | Create family, add members |
| 3 | Member Switcher | S1 | Active-profile selector, persisted |
| 4 | Home / Member Summary | S3 | Latest vitals, active cases, alerts |
| 5 | Submit Complaint | S3 | Symptom picker, duration, severity slider, notes |
| 6 | **Upload Lab Report** | S2 | **Camera / image picker — the device feature** |
| 7 | Record Vitals | S2 | Weight, BP, temperature, blood sugar |
| 8 | Records List | S2 | Search, filter by type, sort, paginate |
| 9 | Case Status Tracker | S3 | Live stepper matching the state machine |
| 10 | Approved Guidance | S4 | Doctor-approved advisory only |
| 11 | Familial Risk & Screening | S4 | Consented signals + screening recommendations |
| 12 | Consent Settings | S1 | Grant/revoke own sharing |
| 13 | Notifications | S3 | Push inbox |
| 14 | Emergency Screen | S4 | Red-flag path — referral only, no AI output |

## 11.3 Required Technical Features

- Reusable widgets: `MemberCard` `StatusStepper` `VitalTile` `SymptomChip` `EmptyStateView` `ErrorRetryView`
- `go_router` navigation with auth redirect guards
- Riverpod state management (ADR-005)
- Registration, login, logout, secure token storage, protected screens
- Forms with validation, search, filtering, transactions, status tracking, history
- Responsive layouts; loading, empty and error states everywhere
- Device feature: camera / image picker for lab report capture
- Push notifications on case status change

## 11.4 Cross-Platform Workflow — the demo centrepiece

```
 FLUTTER                    BACKEND + AGENTS               REACT
─────────────────────────────────────────────────────────────────────
 1. Father uploads
    son's FBC report  ──►  OCR + Extraction Agent   [S2]
    via camera  [S2]        → hereditary_flags row

 2. Father submits
    "son, 12, fever    ──►  Coordinator → Context →  [S3]
     3 days"  [S3]          Analysis → Familial Risk [S4]
                            → Safety (deterministic) [S4]
                                    │
                            red flag? → ESCALATED
                                    │
                            PENDING_DOCTOR_REVIEW ──────►  3. Doctor
                                                              opens case [S4]
                                                              sees timeline,
                                                              deviations,
                                                              familial signal,
                                                              agent trace [S3]
                                                                   │
                            ◄──────────────────────────────  4. Doctor
                                                              REVISES and
                                                              APPROVES [S4]
 5. Push notification ◄──   Notification service [S3]
    Father opens
    approved guidance
    + screening advice [S4]
─────────────────────────────────────────────────────────────────────
      All four members' work appears in one continuous workflow.
```

> **Demo instruction.** This exact sequence is the 10-minute demonstration. Rehearse it end to end at least five times before evaluation day.

---

# 12. Doctor Enrolment and Verification

## 12.1 Verification Workflow

```
   Doctor self-registers (React)
   { name, NIC, SLMC reg no, specialty,
     qualification, certificate upload }
              │
              ▼
   ┌──────────────────────┐
   │ STATUS: PENDING      │  ◄── ZERO patient data access
   └──────────┬───────────┘
              │
   Clinic Admin reviews (React admin panel)
   • SLMC number checked manually against the public register
   • Certificate document viewed
              │
     ┌────────┼────────┬─────────────┐
     ▼        ▼        ▼             ▼
  APPROVE  REQUEST   REJECT       (later)
     │      _INFO      │          SUSPEND
     ▼        │        ▼             │
 ┌────────┐   │   ┌─────────┐   ┌──────────┐
 │VERIFIED│   │   │REJECTED │   │SUSPENDED │
 └───┬────┘   │   └─────────┘   └──────────┘
     │        └──► back to doctor for resubmission
     ▼
 Eligible for case assignment
 (still requires a per-case grant)
```

Every transition writes a `doctor_verification_log` row with actor and reason.

## 12.2 Case Assignment Model

```
 New case validated
       │
       ▼
 Family has a primary doctor?
       │
   yes ├──────────────────────► assign to primary doctor
       │                        create case_access_grant
       │                        (expires_at = +48h)
       │                        SLA timer = 6 hours
       │                             │
       │                        responded within 6h?
       │                             │  no
       │                             ▼
   no  │                        release to SHARED POOL
       ├──────────────────────►      │
       ▼                             ▼
   SHARED POOL — any VERIFIED doctor may claim
       │                    grant created on claim
       ▼
   EMERGENCY priority → immediate pool broadcast
                        + notify all verified doctors
```

## 12.3 Access Is by Grant, Not by Role

```
 ❌ WRONG:  if (user.role == "DOCTOR") → allow

 ✔ RIGHT:  grant = SELECT * FROM case_access_grants
                    WHERE case_id = @caseId
                      AND doctor_id = @doctorId
                      AND revoked_at IS NULL
                      AND expires_at > now()
            if (grant == null) → 403
```

> **Viva line.** "Doctors do not have standing access to patient data. They receive time-bound, case-scoped grants that expire automatically and are individually audited."

## 12.4 Adoption Strategy (report only — not built)

| Aspect | Position |
|---|---|
| Pilot | 2–3 partner GP practices, free tier during pilot |
| Doctor value proposition | Pre-assembled patient context shortens consultation time and restores continuity |
| Verification in v1 | Manual, admin-mediated against the public SLMC register |
| Verification future work | Automated registry integration — no public API currently exists |
| Revenue (future) | Per-consultation fee split; not implemented |

> **Honesty rule.** If asked how SLMC numbers are verified: *manually, by a clinic admin, because no public API exists.* Never claim an integration that does not exist.

---

# 13. Nine-Week Timeline

## 13.1 Week-by-Week Plan

| Week | Dates | Theme | Deliverables | Gate |
|---|---|---|---|---|
| **W1** | Jul 31 – Aug 6 | Foundation | Group charter; repo + branch strategy; ER diagram final; OpenAPI contract drafted; wireframes; ADR-001; **domain and scope frozen**; component allocation confirmed | Contract signed off by all 4 |
| **W2** | Aug 7 – 13 | Skeleton | ASP.NET Core running; EF Core migrations applied; JWT auth working (S1); React shell + routing; Flutter shell + navigation; **GitHub Actions CI green** | 🚦 **CI green** |
| **W3** | Aug 14 – 20 | Core CRUD | All members' endpoints implemented and Swagger-tested; DB tables with constraints and indexes; first PRs merged with review | All endpoints return 2xx in Swagger |
| **W4** | Aug 21 – 27 | Frontend wiring | React screens bound to API; Flutter screens bound to API; protected routes both sides; validation; loading/empty/error states | 🚦 **End-to-end login + record create on both platforms** |
| **W5** | Aug 28 – Sep 3 | Agents I | Ollama running; **tool dispatch layer with allow-list enforcement (S1)**; Extraction Agent producing flags (S2); Context Agent (S3); traces persisting | Extraction + Context produce persisted output. **SCOPE FREEZE** |
| **W6** | Sep 4 – 10 | Agents II | Analysis Agent (S3); Familial Risk Agent (S4); Safety Agent + rule tables (S4); approval gate wired to React; notification service | 🚦 **Full workflow runs end to end** |
| **W7** | Sep 11 – 17 | Integration & quality | Cross-platform workflow verified; unit + integration tests; device feature complete; security pass; emergency path tested; bug fixes | Cross-platform demo runs unaided |
| **W8** | Sep 18 – 24 | Deploy & document | All components deployed; APK built and tested on a physical device; consolidated report written; ADRs finalised; AI disclosure logs; 10-minute demo video recorded | 🚦 **Deployed and reachable by evaluator** |
| **W9** | Sep 25 – 30 | Freeze & viva | **Code freeze Sep 26**; mock viva ×2; each member rehearses explain + modify + debug; final proofread; **submit Sep 29** | Submitted one day early |

## 13.2 Contingency Rules

| Trigger | Action |
|---|---|
| W4 gate missed | Cut dashboard charts and the Flutter notification inbox. Core CRUD is non-negotiable |
| W6 gate missed | Cut the **Familial Risk Agent**; ship 3 agents. Document as a deliberate scope reduction. Three well-executed agents outscore four broken ones |
| W8 gate missed | Deploy backend + database + React minimum; ship Flutter as APK only. Never skip deployment entirely |
| A member is 2+ weeks behind by W5 | Escalate to the lecturer-in-charge **in writing**. Do not absorb silently — individual marks are individual |
| New feature proposed after W5 | Goes to §18 Future Work. Zero lines of code |

## 13.3 Weekly Ritual

```
EVERY MONDAY — 30 minutes
  ▸ Each member: what shipped, what is blocked
  ▸ Update the gate board
  ▸ Reassign if anyone is behind

EVERY THURSDAY — 30 minutes
  ▸ Integration check: does main still build and run?
  ▸ Merge outstanding PRs
  ▸ Demo whatever exists, however small

EVERY SUNDAY — individual, 15 minutes
  ▸ Update own AI-use disclosure log
  ▸ Update own individual report section
  ▸ (Do NOT leave the report to Week 8)
```

---

# 14. Git, CI/CD and Testing

## 14.1 Repository Structure

### 14.1.1 The Rejected Structure — read this first

A folder-per-student layout was considered and **rejected**. It must not be used.

```
❌ REJECTED — DO NOT BUILD THIS
SE3090_SE016/
├── S1_Samaranayaka/
│   ├── backend/  web/  mobile/
├── S2_Fernando/
│   ├── backend/  web/  mobile/
├── S3_Karunathilaka/
│   ├── backend/  web/  mobile/
└── S4_Wasala/
    ├── backend/  web/  mobile/
```

**Why this fails, concretely:**

| Consequence | Impact |
|---|---|
| Four `Program.cs`, four DbContexts, four connection strings | Violates the specification's integrated-system rule: React and Flutter must use **the same** API, database, identity, permissions and business rules |
| No shared `users` table or shared JWT | S4's doctor cannot open S3's case. Login is meaningless across features |
| Cross-platform workflow cannot execute | The Flutter → agents → React → Flutter demonstration (§11.4) is physically impossible |
| Four applications to deploy | Deployment and documentation marks lost |
| Agents cannot reach shared state | `hereditary_flags` written by S2 unreachable by S4's Familial Risk Agent — the two-stage model collapses |

> The marking rubric's lowest band for agentic AI reads *"the feature is only a chatbot or disconnected prototype."* A folder-per-student repository produces disconnected prototypes by construction. This structure is a direct route to the 2-mark band.

**The concern behind the idea is legitimate** — members want to work without merge conflicts and want their contribution to be visible. Neither is solved by folders. Conflicts are solved by file-level separation and branch discipline (§14.1.3–14.1.5). Visibility is solved by Git: the examiner reads `git log --author`, not directory names. **Traceable individual contribution means commits, not folders.**

### 14.1.2 The Correct Structure — one application, four authors

```
SE3090_SE016/
│
├── backend/                          ← ONE ASP.NET Core solution
│   ├── src/
│   │   ├── Api/
│   │   │   ├── Controllers/
│   │   │   │   ├── AuthController.cs             [S1]
│   │   │   │   ├── FamiliesController.cs         [S1]
│   │   │   │   ├── MembersController.cs          [S1]
│   │   │   │   ├── RelationshipsController.cs    [S1]
│   │   │   │   ├── ConsentsController.cs         [S1]
│   │   │   │   ├── RecordsController.cs          [S2]
│   │   │   │   ├── LabReportsController.cs       [S2]
│   │   │   │   ├── VitalsController.cs           [S2]
│   │   │   │   ├── HereditaryFlagsController.cs  [S2]
│   │   │   │   ├── EpisodesController.cs         [S3]
│   │   │   │   ├── TriageCasesController.cs      [S3]
│   │   │   │   ├── DashboardController.cs        [S3]
│   │   │   │   ├── NotificationsController.cs    [S3]
│   │   │   │   ├── DoctorsController.cs          [S4]
│   │   │   │   ├── AdminDoctorsController.cs     [S4]
│   │   │   │   ├── ApprovalsController.cs        [S4]
│   │   │   │   ├── FamilialRiskController.cs     [S4]
│   │   │   │   └── AuditController.cs            [S4]
│   │   │   ├── Dtos/{Identity,Records,Triage,Clinical}/
│   │   │   ├── Validators/
│   │   │   ├── Middleware/ExceptionMiddleware.cs [S1]
│   │   │   └── Program.cs                        ⚠ SHARED
│   │   │
│   │   ├── Application/
│   │   │   ├── Services/
│   │   │   │   ├── AuthService.cs                [S1]
│   │   │   │   ├── FamilyService.cs              [S1]
│   │   │   │   ├── ConsentService.cs             [S1]
│   │   │   │   ├── RecordService.cs              [S2]
│   │   │   │   ├── LabExtractionService.cs       [S2]
│   │   │   │   ├── VitalsTrendService.cs         [S2]
│   │   │   │   ├── EpisodeService.cs             [S3]
│   │   │   │   ├── TriageOrchestrator.cs         [S3]
│   │   │   │   ├── NotificationService.cs        [S3]
│   │   │   │   ├── DoctorVerificationService.cs  [S4]
│   │   │   │   ├── ApprovalService.cs            [S4]
│   │   │   │   ├── FamilialRiskService.cs        [S4]
│   │   │   │   └── AuditService.cs               [S4]
│   │   │   │
│   │   │   ├── Agents/
│   │   │   │   ├── IAgent.cs                     ⚠ SHARED contract
│   │   │   │   ├── Coordinator.cs                [S3]
│   │   │   │   ├── ExtractionAgent.cs            [S2]
│   │   │   │   ├── ContextAgent.cs               [S3]
│   │   │   │   ├── AnalysisAgent.cs              [S3]
│   │   │   │   ├── FamilialRiskAgent.cs          [S4]
│   │   │   │   └── SafetyValidationAgent.cs      [S4]
│   │   │   │
│   │   │   └── Authorization/
│   │   │       ├── ConsentPolicy.cs              [S1]
│   │   │       ├── CaseGrantPolicy.cs            [S4]
│   │   │       └── FamilyScopePolicy.cs          [S1]
│   │   │
│   │   ├── Domain/
│   │   │   ├── Entities/
│   │   │   │   ├── User.cs Family.cs Member.cs
│   │   │   │   │   Relationship.cs Consent.cs    [S1]
│   │   │   │   ├── HealthRecord.cs LabReport.cs
│   │   │   │   │   LabValue.cs Vital.cs
│   │   │   │   │   HereditaryFlag.cs             [S2]
│   │   │   │   ├── Episode.cs TriageCase.cs
│   │   │   │   │   AgentTrace.cs                 [S3]
│   │   │   │   └── Doctor.cs CaseAccessGrant.cs
│   │   │   │       Approval.cs AuditLog.cs       [S4]
│   │   │   ├── Enums/
│   │   │   └── RuleTables/
│   │   │       ├── RedFlagSymptoms.cs            [S4]
│   │   │       ├── PaediatricVitalRanges.cs      [S4]
│   │   │       ├── InheritancePatterns.cs        [S4]
│   │   │       └── AllergyContraindications.cs   [S4]
│   │   │
│   │   └── Infrastructure/
│   │       ├── Persistence/
│   │       │   ├── AppDbContext.cs               ⚠ SHARED
│   │       │   ├── Configurations/               one file per entity
│   │       │   ├── Migrations/                   ⚠ SERIALISED
│   │       │   └── Seed/SyntheticFamilySeed.cs   [S2]
│   │       ├── Agents/
│   │       │   ├── OllamaClient.cs               [S3]
│   │       │   ├── ToolDispatcher.cs             [S1] ← allow-list enforcement
│   │       │   └── ToolRegistry.cs               [S1]
│   │       ├── Ocr/TesseractOcrService.cs        [S2]
│   │       └── External/FcmNotificationClient.cs [S3]
│   │
│   └── tests/
│       ├── UnitTests/{S1,S2,S3,S4 test classes}
│       └── IntegrationTests/
│           ├── AuthFlowTests.cs                  [S1]
│           ├── ConsentEnforcementTests.cs        [S1]
│           ├── ExtractionAgentTests.cs           [S2]
│           ├── TriageWorkflowTests.cs            [S3]
│           ├── CaseGrantTests.cs                 [S4]
│           └── ToolDenialTests.cs                [S4]
│
├── web/                              ← ONE React application
│   ├── src/
│   │   ├── pages/
│   │   │   ├── auth/                             [S1]
│   │   │   ├── family/                           [S1]
│   │   │   ├── consents/                         [S1]
│   │   │   ├── records/                          [S2]
│   │   │   ├── dashboard/                        [S3]
│   │   │   ├── traces/                           [S3]
│   │   │   ├── doctor/                           [S4]
│   │   │   ├── admin/                            [S4]
│   │   │   └── audit/                            [S4]
│   │   ├── components/
│   │   │   ├── shared/                           ⚠ review required
│   │   │   │   DataTable · StatusBadge · EmptyState
│   │   │   │   ConfirmDialog · ErrorBoundary
│   │   │   └── {family,records,triage,clinical}/  by owner
│   │   ├── store/
│   │   │   ├── index.ts                          ⚠ SHARED
│   │   │   └── slices/{auth,records,cases,doctor}Slice.ts
│   │   ├── services/api/                         one client file per owner
│   │   ├── routes/AppRouter.tsx                  ⚠ SHARED
│   │   └── hooks/
│   ├── tests/
│   └── package.json                              ⚠ SHARED
│
├── mobile/                           ← ONE Flutter application
│   ├── lib/
│   │   ├── screens/
│   │   │   ├── auth/                             [S1]
│   │   │   ├── family/                           [S1]
│   │   │   ├── records/                          [S2]
│   │   │   ├── vitals/                           [S2]
│   │   │   ├── triage/                           [S3]
│   │   │   ├── notifications/                    [S3]
│   │   │   ├── risk/                             [S4]
│   │   │   └── emergency/                        [S4]
│   │   ├── widgets/
│   │   │   ├── shared/                           ⚠ review required
│   │   │   └── {by owner}/
│   │   ├── providers/                            one file per owner
│   │   ├── services/api/                         one client file per owner
│   │   ├── models/                               mirrors backend DTOs
│   │   ├── router/app_router.dart                ⚠ SHARED
│   │   └── main.dart                             ⚠ SHARED
│   ├── test/
│   └── pubspec.yaml                              ⚠ SHARED
│
├── docs/
│   ├── adr/                          ADR-001 … ADR-009
│   ├── diagrams/                     ER, architecture, workflow
│   ├── api/                          exported OpenAPI spec
│   ├── ai-disclosure/                S1.md S2.md S3.md S4.md
│   └── individual-reports/           S1.md S2.md S3.md S4.md
│
├── .github/
│   ├── workflows/ci.yml
│   └── pull_request_template.md
├── .gitignore
└── README.md                         setup + evaluator access
```

**Legend:** `[S1]`–`[S4]` = sole owner, no one else edits. `⚠ SHARED` = multiple members touch it; follow §14.1.3.

### 14.1.3 Shared Files — the only real conflict surface

Seven files are touched by more than one member. Everything else has exactly one owner.

| File | Coordinator | Rule |
|---|---|---|
| `backend/src/Api/Program.cs` | S1 | Add DI registrations inside your own labelled block only |
| `backend/src/Infrastructure/Persistence/AppDbContext.cs` | S1 | Add your `DbSet<>` lines only. Never reorder existing lines |
| `backend/src/Application/Agents/IAgent.cs` | S3 | Interface changes require group agreement — every agent implements it |
| `web/src/store/index.ts` | S3 | Register your slice; do not touch others' |
| `web/src/routes/AppRouter.tsx` | S1 | Add your route block; do not restructure guards |
| `mobile/lib/router/app_router.dart` | S1 | Add your route block only |
| `package.json` / `pubspec.yaml` | S1 | Announce in the group chat before adding a dependency |

**Labelled-block convention** — different members edit different lines, so Git merges automatically:

```csharp
// Program.cs
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

### 14.1.4 Migration Protocol ⚠

Two members generating EF Core migrations simultaneously produces conflicting model snapshots and is the one failure that genuinely breaks the repository. This is a far greater risk than ordinary merge conflicts.

```
┌──────────────────────────────────────────────┐
│  MIGRATION PROTOCOL — mandatory              │
│                                              │
│  1. Announce in the group chat:              │
│     "taking migration lock, ~20 min"         │
│  2. git pull origin develop                  │
│  3. dotnet ef migrations add <Name>          │
│  4. dotnet ef database update  (verify)      │
│  5. Commit + push immediately                │
│  6. Announce: "migration lock released"      │
│  7. Everyone else: git pull before working   │
│                                              │
│  ✘ Never two migrations in flight at once.   │
│  ✘ Never edit a migration another member     │
│    has already pushed — add a new one.       │
└──────────────────────────────────────────────┘
```

Migration naming: `20260814_S2_AddLabReportsAndValues` — date, owner, purpose.

### 14.1.5 Daily Working Rules

| # | Rule | Reason |
|---|---|---|
| 1 | Work only on your own branch: `feature/s2-lab-ocr` | Isolation without fragmentation |
| 2 | `git pull origin develop` **every morning** before writing code | Prevents week-long divergence |
| 3 | Small, frequent PRs. A 40-file PR guarantees conflicts | Merge pain scales super-linearly with PR size |
| 4 | Never edit a file marked with another member's tag — ask them | Ownership is the conflict-prevention mechanism |
| 5 | On shared files, **add lines; never reorganise** | Reformatting turns a clean merge into a conflict |
| 6 | Take the migration lock before any schema change | §14.1.4 |
| 7 | New shared component → PR review by at least one other member | Shared code is everyone's problem |

> **Proof of individual work is `git log --author="<name>"`, not folder names.** Every member commits their own code under their own account. Never commit on another member's behalf, even to "help them catch up" — it destroys the evidence their individual marks depend on.

## 14.2 Branch Strategy

```
main ──────────────────────────────────────────►  protected, always deployable
  │
  └── develop ─────────────────────────────────►  integration branch
        ├── feature/s1-consent-management
        ├── feature/s2-lab-ocr-extraction
        ├── feature/s3-agent-orchestration
        └── feature/s4-approval-gate
```

**Rules**

1. No direct pushes to `main` or `develop`.
2. Every feature branch → PR into `develop`.
3. PR requires **1 approving review** from another member.
4. CI must pass before merge.
5. Conventional commits: `feat(s3): add coordinator planning step`.
6. `develop` → `main` at each weekly gate.

> Traceable individual contribution is assessed. Each member's commit history must clearly show their own work. **Never commit on another member's behalf.**

## 14.3 CI Pipeline

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

## 14.4 Testing Plan

| Layer | Tool | Minimum coverage |
|---|---|---|
| Backend unit | xUnit + Moq | Every service class; agent tool authorisation; deterministic rule tables |
| Backend integration | WebApplicationFactory + Testcontainers PostgreSQL | Auth flow; consent enforcement; case grant enforcement; full triage workflow |
| React | Vitest + React Testing Library | Reusable components; approval panel; guarded routes |
| Flutter | flutter_test | Widget tests for forms and status stepper; provider tests |
| Manual | Documented test cases | Cross-platform workflow; device feature; error and emergency paths |

## 14.5 Priority Test Cases

These map directly to viva questions — write them first.

1. A doctor without a valid grant receives 403 on case access.
2. A revoked consent removes that member's flags from familial analysis.
3. A member turning 18 moves guardian consents to `PENDING_REAFFIRMATION`.
4. The Familial Risk Agent's raw-record tool call is denied and logged in `tools_denied`.
5. A red-flag symptom bypasses the normal queue and sets `ESCALATED` with no AI output shown.
6. An LLM timeout produces a safe failure and no patient-visible output.
7. A non-biological relationship is excluded from hereditary reasoning.
8. A `PENDING` doctor receives 403 on every clinical endpoint.

---

# 15. Deployment

| Component | Platform | Notes |
|---|---|---|
| ASP.NET Core API | Render / Azure App Service (free tier) | HTTPS enforced; secrets in environment variables, never committed |
| PostgreSQL | Neon / Supabase (free tier) | Connection string via environment only |
| React web | Vercel / Netlify | `familyveda.vercel.app` — no custom domain purchase needed |
| Flutter | Signed APK submitted with the report | Tested on at least one physical Android device |
| Ollama | Local, run during the demonstration | Hardware requirements documented in the deployment report |

**Evaluator access package (required):**

- [ ] Deployed web URL
- [ ] API base URL + Swagger URL
- [ ] Repository link with evaluator access granted
- [ ] APK download link
- [ ] Test credentials for every role: Family Head · Member 18+ · Doctor (verified) · Doctor (pending) · Clinic Admin
- [ ] Reproducible local setup instructions in `README.md`
- [ ] Access maintained until **at least 21 October 2026**

---

# 16. Architecture Decision Records

Format: **Context → Options → Decision → Consequences → Status**

| ADR | Title | Owner | Core decision |
|---|---|---|---|
| ADR-001 | Backend framework selection | S1 | ASP.NET Core Web API — mandated; justify against Node/Spring on static typing, tooling, built-in DI, EF Core |
| ADR-002 | Relational database and ORM | S2 | PostgreSQL + EF Core; relational over document store given referential integrity and consent constraints |
| ADR-003 | Two-stage familial data model | S4 | Flags cross profiles, raw records do not. **Rejected alternative:** full family record access for the agent |
| ADR-004 | React state management | S3 | Redux Toolkit over Context API — cross-cutting case queue and auth state |
| ADR-005 | Flutter state management | S2 | Riverpod over Provider/Bloc — compile-time safety and testability |
| ADR-006 | Local LLM via Ollama | S3 | Local inference over hosted API — data residency, cost, offline demonstration, health-data privacy |
| ADR-007 | Deterministic safety layer | S4 | Rule tables over LLM judgement for clinical safety — reproducibility and auditability |
| ADR-008 | Access by grant, not by role | S4 | `case_access_grants` over role-based access — least privilege |
| ADR-009 | Async consultation over video | S3 | Rejected WebRTC — scope; async already satisfies the cross-platform workflow requirement |

---

# 17. Safety, Ethics and AI Disclosure

## 17.1 Non-Negotiable Safety Rules

```
RULE 1 ▸ The system never diagnoses.
RULE 2 ▸ No AI output reaches a patient without doctor approval.
RULE 3 ▸ The approval gate is architectural — there is no bypass path.
RULE 4 ▸ Clinical safety checks are deterministic, never LLM judgement.
RULE 5 ▸ Family history yields a SCREENING INDICATION, never a diagnosis.
RULE 6 ▸ No drug names, no dosing, no prescriptions, no meal plans.
RULE 7 ▸ Synthetic data only. No real patient data, ever.
RULE 8 ▸ Every cross-profile access is consented and audited.
RULE 9 ▸ On any uncertainty, the system defers to in-person care.
RULE 10 ▸ In an emergency the system shows a referral, not AI output.
```

## 17.2 AI Use Disclosure

| Phase | Level | Rule |
|---|---|---|
| Development | Level 4 | AI assistance permitted, **must be disclosed and verified** |
| Final demonstration | Level 1 | No external AI assistants, chatbots, IDE copilots or agentic coding tools |
| Viva | Level 1 | Same. Only the submitted application's own agentic subsystem may run |

Each member maintains `docs/ai-disclosure/S<n>.md` recording: which tool, which task, what was generated, what was verified and changed.

> **Hard rule.** The individual reflection must not be AI-generated. The specification states an AI-generated reflection receives no credit.

---

# 18. Future Work — Deliberate Deferrals

> Write these into the report exactly in this style. "Deliberately deferred, with the extension point identified" reads as engineering maturity. "We ran out of time" reads as a failure.

## 18.1 Appointment Scheduling

Deferred. Booking is orthogonal to the assessed agentic workflow and would have consumed approximately three weeks across availability modelling, slot management, conflict handling and notification flows. The architecture reserves the extension point: `doctor_availability` and `appointments` tables with `appointments.triage_case_id` as a nullable foreign key, so a doctor approving a case can offer a slot without schema change.

```
Reserved schema (not implemented):

doctor_availability
  id, doctor_id FK, day_of_week, start_time,
  end_time, slot_minutes, is_active

appointments
  id, doctor_id FK, member_id FK, family_id FK,
  scheduled_at, duration_minutes,
  status ENUM(REQUESTED, CONFIRMED, DECLINED,
              COMPLETED, CANCELLED, NO_SHOW),
  triage_case_id FK NULLABLE,   ← links to the agentic flow
  created_at, updated_at

Privacy constraint (design already decided):
  Families see OPEN slots only. A doctor's booked
  slots are other patients' information and must
  never be exposed.
```

## 18.2 Payment and Settlement

Deferred deliberately. Handling real transactions for medical services in an academic prototype carries regulatory and data-protection exposure disproportionate to its value, and contributes nothing to the assessed criteria. Version 1 assumes clinic-side settlement — payment occurs outside the platform, as it does today in Sri Lankan GP practice.

## 18.3 External Calendar Synchronisation

Deferred. Google Calendar and Outlook integration requires OAuth consent flows, token refresh handling and per-provider API differences. A lower-cost interim path is identified: generating an `.ics` file for download, which requires no OAuth and no stored third-party credentials. Not implemented in v1.

## 18.4 Live Video Consultation

Deferred. WebRTC signalling, TURN server provisioning and media handling represent substantial engineering cost. The asynchronous doctor review workflow already satisfies the cross-platform workflow requirement and is a better fit for a context-assembly product, where the value lies in preparation rather than real-time presence.

## 18.5 Personalised Lifestyle and Nutrition Guidance

Deferred on safety grounds, not scope grounds. Dietary plans and exercise prescriptions for diabetic, renal, paediatric or pregnant patients constitute clinical nutrition therapy and require a qualified clinician. Version 1 permits only generic, sourced public-health information, and only within a doctor-approved advisory.

## 18.6 Automated SLMC Verification

Deferred. No public API to the Sri Lanka Medical Council register currently exists. Version 1 uses manual, admin-mediated verification against the public register, with the full decision trail recorded in `doctor_verification_log`.

## 18.7 Additional Deferred Items

| Item | Reason |
|---|---|
| Wearable device integration | Scope; no rubric contribution |
| Pharmacy / e-prescription dispensing | Regulated domain |
| Multi-language UI (Sinhala/Tamil) | Valuable for real deployment; not assessed |
| Offline-first mobile sync | Significant complexity; not assessed |
| Doctor-to-doctor referral network | Natural v2 extension of `case_access_grants` |

---

# 19. Marks Mapping

| Contribution | Criterion | Marks | Family Veda evidence |
|---|---|---:|---|
| Group | Component Design and Business Logic | 10 | 4 distinct business components; 3 status workflows; 5 roles; consent state machine |
| Group | Integrated Architecture, Agent Orchestration, State | 10 | Single backend/DB/identity; 4 distinct agents; persisted state; tool allow-list; approval gate; traces |
| Group | Documentation and Deployment | 10 | Consolidated report; 9 ADRs; deployed URLs; APK; reproducible setup; AI disclosure |
| Individual | ASP.NET Core REST API | 10 | Owned endpoints, DTOs, validation, async, status codes, exception handling |
| Individual | PostgreSQL and Data Modelling | 10 | Owned tables, FKs, constraints, indexes, migrations, seed data |
| Individual | React Web Application | 10 | Owned screens, reusable components, guards, states, validation |
| Individual | Flutter Mobile Application | 10 | Owned screens, widgets, routing, secure storage, device feature |
| Individual | Agentic AI Contribution | 12 | Owned agent(s), tools, state, validation, traces |
| Individual | API Integration, Security, Cross-Platform | 10 | Consent enforcement, case grants, audit, cross-platform workflow |
| Individual | Testing, CI and Git Workflow | 8 | Own tests, PR reviews, commit history, CI participation |
| | **Total** | **100** | scaled to 25% of the module |

## 19.1 Cut Priority

| Priority | Item | Cut? |
|---|---|---|
| 1 | Agentic workflow end to end | **Never** |
| 2 | Working integrated system across all four stacks | **Never** |
| 3 | Deployment + consolidated report | **Never** |
| 4 | Testing and CI | Reduce, do not drop |
| 5 | Familial Risk Agent (4th agent) | Cut only if the W6 gate is missed |
| 6 | Dashboard charts, analytics depth, UI polish | **Cut first** |

---

# 20. Viva Preparation Pack

## 20.1 Questions Every Member Must Answer

| # | Question | Answer direction |
|---|---|---|
| 1 | Is this a chatbot? | No. Four agents with distinct scopes, tools and outputs; persisted state machine; deterministic validation; mandatory approval gate; full traces. Show the agent comparison table (§6.3) |
| 2 | What makes your agents *distinct*? | Different scope (member vs family), different tool allow-lists, different output schemas; one is fully deterministic. Show the tool permission matrix (§6.4) |
| 3 | Your AI touches medical data. Justify it. | It does not diagnose. It assembles context. No output reaches a patient without licensed doctor approval, enforced architecturally |
| 4 | Does the agent read the whole family's records? | No. Raw records stay member-scoped. Only consented structured hereditary flags cross profile boundaries. The familial agent's raw-record tool is denied at the dispatch layer |
| 5 | Father is a thalassaemia carrier — does the son have it? | No. Autosomal recessive requires both parents to be carriers. One carrier parent gives 0% affected, 50% carrier. Our output reports `unknownParties` and recommends screening |
| 6 | What is deterministic validation? | Fixed rule tables, reference ranges and JSON schema checks. Same input, same output. Not LLM judgement |
| 7 | What if the LLM fails or hallucinates? | Schema validation, one retry, then safe failure. Patient sees "consult your doctor directly", never a partial or unapproved output |
| 8 | What does the AI do in an emergency? | Deliberately less. A deterministic red-flag check runs before any LLM output could surface. The user sees a referral and emergency contacts, not AI guidance |
| 9 | Why no meal plans or lifestyle advice? | Clinical nutrition therapy requires a clinician. Generic public-health information only, and only inside a doctor-approved advisory |
| 10 | How do you verify a doctor is real? | Manual admin verification against the public SLMC register in v1. Automated registry integration is future work — no public API exists |
| 11 | Can any verified doctor see any patient? | No. Access is by time-bound, case-scoped grant in `case_access_grants`, not by role. Grants expire and are audited |
| 12 | What happens when a minor turns 18? | Guardian-granted consents move to `PENDING_REAFFIRMATION` and are treated as not granted until the member personally confirms |
| 13 | Where is real patient data? | Nowhere. Synthetic seed data only, stated in the report's ethics section |
| 14 | Show me your individual contribution. | Open your commits, your endpoints in Swagger, your React screen, your Flutter screen, your agent, your tests |
| 15 | Modify this now. | Be able to add a validation rule, change a status transition, or add a field end to end within five minutes |
| 16 | Why Redux Toolkit / Riverpod / Ollama? | Point to the ADR and give the trade-off in one sentence |
| 17 | What did you cut, and why? | §18. Named deferrals with reasons and reserved extension points — not omissions |

## 20.2 Phrases to Use

> "context assembly, not clinical conclusion"
> "data minimisation — flags cross profiles, files do not"
> "access by grant, not by role"
> "the approval gate is architectural, not procedural"
> "deterministic validation, not LLM judgement"
> "screening indication, not diagnosis"
> "safe failure — the patient sees nothing unapproved"
> "deliberately deferred, with the extension point reserved"

## 20.3 Phrases to Never Use

> ❌ "Our AI is better than a doctor"
> ❌ "The AI diagnoses the patient"
> ❌ "The son inherits the father's condition"
> ❌ "We'd just call the SLMC API"
> ❌ "The AI has access to all the family's data"
> ❌ "The AI gives urgent advice when no doctor is available"
> ❌ "We didn't have time so we skipped tests"

---

# 21. Risk Register

| # | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| R1 | Agent workflow not working by W6 | Medium | **Critical** | Hard gate at W6; contingency is 3 agents instead of 4 |
| R2 | Ollama too slow on team hardware | Medium | High | Test in W5 on the actual demo machine; smaller model; cache context |
| R3 | OCR accuracy poor on Sri Lankan lab report formats | High | Medium | Manual correction UI as fallback; OCR is assistive, never authoritative |
| R4 | Integration left until the end | Medium | **Critical** | W4 gate forces end-to-end integration at the halfway point |
| R5 | A member underperforms | Medium | High | Weekly checkpoints; written escalation to the lecturer by W5 |
| R6 | Free-tier hosting sleeps or fails during evaluation | Medium | High | Deploy in W8, verify daily in W9; local fallback ready |
| R7 | Examiner challenges the genetics framing | **High** | High | §6.6 memorised by all four members |
| R8 | Scope creep | High | High | Feature freeze at W5; new ideas go to §18 |
| R9 | A member cannot explain their own component | Medium | **Critical** | Mock viva ×2 in W9; each member demos to the group first |
| R10 | Report written in the last week | High | High | 15 minutes every Sunday, per member, from W1 |
| R11 | Demo fails live | Medium | High | Rehearse ×5; recorded video as backup; seeded demo data pre-loaded |

---

# 22. Deliverables Checklist

## 22.1 Submission Package

- [ ] **One** consolidated PDF report (not separate group and individual PDFs)
  - [ ] Group Report: technical (10–15p), testing (6–10p), agentic AI evaluation (5–8p), performance (3–5p), deployment (3–5p), ADRs (3–6p)
  - [ ] Individual Report × 4, each with a personal reflection (**never AI-generated**)
- [ ] Repository link with evaluator access
- [ ] Deployment links: API, Swagger, React web
- [ ] Flutter APK
- [ ] 10-minute demonstration video
- [ ] Test credentials for all five roles
- [ ] AI usage disclosure logs (one per member)
- [ ] Named `SE3090_SE016`
- [ ] Submitted by the group leader (Karunathilaka K.D.J.C) through CourseWeb
- [ ] Submitted by **29 September** (one day early)
- [ ] Access maintained until **21 October 2026**

## 22.2 Technical Readiness

- [ ] React and Flutter use the same API, database, identity and permissions
- [ ] At least three user roles enforced (we have five)
- [ ] CRUD plus business operations on every component
- [ ] Status workflows implemented and demonstrable
- [ ] Search, filter, sort, pagination, reporting present
- [ ] One complete cross-platform workflow demonstrable end to end
- [ ] Device feature working on a physical device
- [ ] Third-party service integrated through the backend
- [ ] Agentic workflow satisfies **every** minimum acceptance element
- [ ] Tool allow-list enforced and a denied call demonstrable live
- [ ] Deterministic validation demonstrable
- [ ] Approval gate demonstrable with no bypass
- [ ] Emergency red-flag path demonstrable
- [ ] Agent traces visible in the UI
- [ ] Safe failure demonstrable
- [ ] Tests passing; CI green on `main`
- [ ] Every member can explain, test, modify and debug their own contribution

---

# Appendix A — One-Page Summary

```
PROJECT  ▸ FAMILY VEDA
           "Your family doctor, with your family's whole story."
           Group SE_016 · Y3.S1.SE.WE.01.01

PROBLEM  ▸ Sri Lankan family doctors lack longitudinal patient
           context. Every visit starts from zero. Patients
           therefore bypass GPs for hospitals.

SOLUTION ▸ Family-scoped longitudinal health record + agentic
           triage that assembles personal baseline context and
           consented familial risk signals BEFORE consultation.

ROLE     ▸ AI  = context assembly, trend analysis, flagging
           DOC = clinical decision + accountability (approval gate)

AGENTS   ▸ Extraction (on upload)
           → Context (member) → Analysis (member)
           → Familial Risk (family, FLAGS ONLY)
           → Safety/Validation (DETERMINISTIC)
           → ⏸ DOCTOR APPROVAL ⏸ → patient

DATA     ▸ Two-stage: raw records stay member-scoped.
           Only consented structured flags cross profiles.
           "FLAGS CROSS, FILES DON'T."

ACCESS   ▸ By time-bound case grant, not by role.
           Every cross-profile read audited.

EMERGENCY▸ Deterministic red-flag → referral only.
           ZERO AI output shown. Silence is the safe mode.

TEAM     ▸ S1 Samaranayaka  Family/Identity/Consent + CI
           S2 Fernando      Records/Labs/OCR + Extraction Agent
           S3 Karunathilaka Triage/Orchestration + Context+Analysis
                            (GROUP LEADER)
           S4 Wasala        Risk/Doctor/Approval + Familial+Safety

GATES    ▸ W2 CI green │ W4 end-to-end CRUD │ W5 SCOPE FREEZE
           W6 full agent workflow │ W8 deployed │ W9 submit early

REPO     ▸ ONE app, four authors. NOT a folder per person.
           Files tagged by owner │ 7 shared files only
           Migration lock announced in chat, one at a time
           Proof of work = git log, not folder names

CUT ORDER▸ UI polish → analytics → 4th agent → NEVER core workflow

DEFERRED ▸ Booking · payment · calendar sync · video ·
           meal plans · SLMC API
           (documented as deliberate, with extension points)

NEVER SAY▸ "AI better than doctor" · "AI diagnoses"
           "father's condition passes to son automatically"
           "agent reads all family data"
           "AI gives urgent advice when no doctor is available"
```

**Memory hooks**

| Hook | Meaning |
|---|---|
| **P-A-V-A** | Prepare · Analyse · Validate · Approve. AI does the first three; the doctor does the fourth |
| **FLAGS CROSS, FILES DON'T** | The two-stage data model |
| **P-V-G** | Pending · Verified · Grant. Access comes from the grant, not the role |
| **GATE OR GONE** | If it did not pass the approval gate, the patient never sees it |
| **2-4-6-8** | W2 CI green · W4 CRUD end-to-end · W6 agents complete · W8 deployed |
| **S-R-S** | Signal not diagnosis · Recessive needs both · Share flags not files |

---

# Appendix B — Glossary

| Term | Meaning |
|---|---|
| **Agentic AI** | A system where an LLM plans multiple steps, delegates to distinct agents, uses controlled tools, persists state, and pauses for human approval — as opposed to a single-prompt chatbot |
| **Approval gate** | The `PENDING_DOCTOR_REVIEW` state that no code path bypasses. Nothing reaches a patient without passing it |
| **Autosomal recessive** | An inheritance pattern requiring two copies of a variant. Both parents must be carriers for a child to be affected |
| **Case access grant** | A time-bound, case-scoped permission record. Our authorisation reads this, not the user's role |
| **Consent category** | A named class of shareable data (`HEREDITARY_FLAGS`, `VITALS_SUMMARY`, `CONDITIONS`) that a member grants or revokes independently |
| **Context gap** | The core problem: a doctor consulting without the patient's history |
| **Deterministic validation** | Validation from fixed rule tables, reference ranges and schemas. Same input, same output. Never LLM judgement |
| **Hereditary flag** | A small structured record `{member, condition, status, evidence, confidence}` extracted from a raw record. The only clinical data permitted to cross member boundaries |
| **Longitudinal record** | A member's health data tracked over time, enabling baseline and deviation analysis |
| **Red flag** | A symptom or value in the deterministic emergency table that immediately escalates a case and suppresses all AI output |
| **Safe failure** | Any failure path where the system deliberately produces a referral instead of an output |
| **Screening indication** | A recommendation to test — the only familial-risk output permitted. Never a diagnosis |
| **Tool allow-list** | The per-agent set of permitted backend tools, enforced at the dispatch layer, not in the prompt |
| **Two-stage model** | Stage 1 extracts flags from raw records within one member's scope; Stage 2 reasons across the family using flags only |

---

*Family Veda — internal group blueprint, version 1.0 (frozen scope). Prepared for SE3090 Assignment 1, Group SE_016. All clinical framing in this document is for an academic software engineering project and does not constitute medical guidance. All data used is synthetic.*
