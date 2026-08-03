# Agentic AI Subsystem Design — Family Veda

Source: blueprint §6. This is the highest-weighted individual criterion (12 marks) and the most likely viva focus.

## Why this is agentic, not a chatbot

| Requirement | Family Veda implementation |
|---|---|
| Accepts a domain objective | "Assess this member's complaint against their longitudinal baseline" |
| Plans multiple steps | Coordinator produces an ordered plan of agent invocations |
| Delegates to distinct agents | 4 agents with different scopes, tools, inputs and outputs |
| Uses controlled tools | Explicit allow-list per agent, **enforced at dispatch** — not advisory |
| Persists structured state | `triage_cases`, `agent_traces`, `hereditary_flags` |
| Deterministic validation | Rule tables and reference ranges — not LLM judgement |
| Pauses for authorised approval | Mandatory doctor approval gate with no bypass path |
| Records observability evidence | Per-step trace: input hash, tools requested/denied, output, confidence, latency, tokens |
| Returns auditable result or safe failure | Approved advisory, or an explicit safe-failure referral |

## Workflow

```
   FLUTTER — member submits complaint
   { memberId, symptoms[], vitals{}, durationDays, attachments[] }
                    │
                    ▼
   ┌────────────────────────────────────────────────────────┐
   │  COORDINATOR / PLANNER                          (S3)   │
   │  • Validates request shape                             │
   │  • Creates TriageCase (status: PLANNING)               │
   │  • Produces an ordered execution plan                  │
   │  • Emits trace step 0                                  │
   └────────────────────┬───────────────────────────────────┘
                        ▼
   ┌────────────────────────────────────────────────────────┐
   │  AGENT 1 — CONTEXT AGENT      (S3)   scope: ONE member │
   │  Tools: read_member_profile, read_member_vitals,       │
   │         read_member_episodes, read_member_conditions   │
   │  DENIED: any other member, any family-wide read        │
   │  Output: MemberContext {                               │
   │      baselineVitals, chronicConditions, allergies,     │
   │      medications, recentEpisodes[], age, sex }         │
   │  Status → CONTEXT_READY                                │
   └────────────────────┬───────────────────────────────────┘
                        ▼
   ┌────────────────────────────────────────────────────────┐
   │  AGENT 2 — ANALYSIS AGENT     (S3)   scope: ONE member │
   │  Tools: read_lab_trends, compute_deviation             │
   │  Task: Is this complaint consistent with this person's │
   │        own baseline, or is it a deviation?             │
   │  Output: AnalysisFindings {                            │
   │      deviations[], trendSummary, recurrencePattern,    │
   │      timeline[], confidence }                          │
   │  Status → ANALYSED                                     │
   └────────────────────┬───────────────────────────────────┘
                        ▼
   ┌────────────────────────────────────────────────────────┐
   │  AGENT 3 — FAMILIAL RISK AGENT (S4)  scope: FAMILY     │
   │  Tools: read_consented_hereditary_flags,               │
   │         read_relationship_graph,                       │
   │         lookup_inheritance_pattern                     │
   │  DENIED: read raw records of ANY member  ◄── critical  │
   │  Output: FamilialRiskSignal {                          │
   │      signals[], inheritanceNote,                       │
   │      screeningRecommendations[], unknownParties[] }    │
   │  Status → RISK_ASSESSED                                │
   └────────────────────┬───────────────────────────────────┘
                        ▼
   ┌────────────────────────────────────────────────────────┐
   │  AGENT 4 — SAFETY / VALIDATION AGENT (S4)              │
   │  ⚠ DETERMINISTIC. No LLM decision. Rule tables only.   │
   │   ▸ Red-flag symptom table    → EMERGENCY override     │
   │   ▸ Age-adjusted vital ranges → out-of-range flag      │
   │   ▸ Allergy contraindication table                     │
   │   ▸ Duration thresholds (fever > 3 days in a child)    │
   │   ▸ Output JSON schema validation                      │
   │   ▸ Prohibited-content check                           │
   │  Any red flag → BYPASS queue → immediate escalation    │
   │  Status → VALIDATED  or  ESCALATED                     │
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
        ║   ✔ APPROVE          → APPROVED           ║
        ║   ✎ REVISE + approve → APPROVED_REVISED   ║
        ║   ↩ REQUEST_INFO     → AWAITING_INFO      ║
        ║   ✘ REJECT           → REJECTED           ║
        ║   🚨 ESCALATE        → ESCALATED          ║
        ╚═══════════════════════════════════════════╝
                        │
                        ▼
        Notification (third-party) → Flutter
        Member receives DOCTOR-APPROVED guidance only.
```

## Agent comparison — *viva critical, every member memorises this*

| | Context | Analysis | Familial Risk | Safety |
|---|---|---|---|---|
| **Owner** | S3 | S3 | S4 | S4 |
| **Scope** | One member | One member | Family (flags only) | Case output |
| **Reads raw records** | ✔ own member | ✔ own member | ✘ **hard denied** | ✘ |
| **Reads other members** | ✘ | ✘ | ✔ flags only, consented | ✘ |
| **Uses LLM** | ✔ structuring | ✔ trend reasoning | ✔ signal wording | ✘ **deterministic** |
| **Primary output** | MemberContext | AnalysisFindings | FamilialRiskSignal | ValidationVerdict |
| **Can halt the workflow** | ✘ | ✘ | ✘ | ✔ emergency override |

This table is the single strongest evidence that the agents are **distinct**, not one prompt renamed four times.

## Tool permission matrix

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

### Enforcement

Enforcement lives in `ToolDispatcher` (owned by **S1**), **not in the prompt**. A denied call:

1. returns a hard error to the agent,
2. writes the tool name to `agent_traces.tools_denied`,
3. halts the workflow.

**Demonstrate this live in the viva.** Very few groups will be able to.

```
❌ WRONG: "You must not read other members' records."   (a prompt instruction — advisory)
✔ RIGHT:  if (!registry.IsAllowed(agent, tool)) throw new ToolDeniedException(...);
```

## Two-stage data model

```
STAGE 1 — EXTRACTION (isolated, per member)          [S2]
┌──────────────────────────────────────────────────┐
│  Extraction Agent — runs on lab report upload    │
│  scope: ONE member                               │
│  input: that member's lab reports and records    │
│  process: OCR → parse → identify hereditary-     │
│           relevant findings → structure          │
│  output row → hereditary_flags                   │
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
│  ⚠ raw-record tool DENIED at dispatch layer.     │
└──────────────────────────────────────────────────┘
```

**Justification (viva).** A hereditary risk assessment needs roughly 20 tokens of structured fact per relative, not 8,000 tokens of raw history. Passing full records would increase privacy exposure, enlarge the hallucination surface, bloat LLM context and add no analytical capability. **Flags cross profile boundaries; files do not.**

## Familial risk — correct genetic framing

> **Never claim inheritance. Claim a screening indication.**

| ❌ Wrong output | ✔ Correct output |
|---|---|
| "Son has thalassaemia because his father does" | "First-degree relative is a confirmed β-thalassaemia carrier. Maternal carrier status is unknown. Screening (HbA2, full blood count) is indicated before any conclusion." |
| "This condition is inherited automatically" | "Autosomal recessive: both parents must be carriers for the condition to manifest. One carrier parent alone is insufficient." |
| "Your son will have hair loss like his father" | "Androgenetic alopecia is polygenic with contributions from both parental lines. No predictive claim can be made." |

**Inheritance reference table** — hardcoded, cited, deterministic, **not LLM-generated**:

| Pattern | One carrier/affected parent | Both carriers | System output |
|---|---|---|---|
| Autosomal recessive (β-thalassaemia, cystic fibrosis) | If other parent is confirmed not a carrier: 0% affected · 50% carrier. If status is unknown: no numeric affected-risk claim | If both parents are confirmed carriers: 25% affected · 50% carrier | Screening indicated; second-parent status required |
| Autosomal dominant (Huntington's, familial hypercholesterolaemia) | 50% affected | — | Screening indicated |
| X-linked recessive (haemophilia, G6PD deficiency) | Depends on the child's sex and which parent | — | Screening indicated; sex-specific note |
| Polygenic / multifactorial (type 2 diabetes, hypertension, alopecia) | Increased relative risk only | — | Risk factor noted; **no predictive claim** |

`relationships.is_biological` is mandatory. Adoptive and step relationships are excluded from hereditary reasoning.

## Safe failure behaviour

| Failure mode | System behaviour |
|---|---|
| LLM unavailable or times out | `AGENT_FAILED`; member sees "Please consult your doctor directly"; **no partial output** |
| Output fails schema validation | Retry once; second failure → safe failure path |
| Red-flag symptom detected | Bypass LLM → `ESCALATED` → deterministic referral; active-grant doctor notification only |
| Confidence below threshold | Case still goes to a doctor, marked `LOW_CONFIDENCE`, draft advisory hidden |
| Denied tool call attempted | Hard error, logged as a violation, workflow halts |
| No doctor available within SLA | Escalate to the shared pool; if still unassigned → advise in-person care |
| OCR fails on a lab report | Report stored, `ocr_status = FAILED`, manual entry offered; **no guessed values** |

> Under no failure condition does the system show an unapproved AI output to a patient.

## Observability — the trace record

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

## Implementation map

| File | Owner |
|---|---|
| `Application/Agents/IAgent.cs` | ⚠ SHARED, coordinated by S3 |
| `Application/Agents/Coordinator.cs` | S3 |
| `Application/Agents/ExtractionAgent.cs` | S2 |
| `Application/Agents/ContextAgent.cs` | S3 |
| `Application/Agents/AnalysisAgent.cs` | S3 |
| `Application/Agents/FamilialRiskAgent.cs` | S4 |
| `Application/Agents/SafetyValidationAgent.cs` | S4 |
| `Infrastructure/Agents/OllamaClient.cs` | S3 |
| `Infrastructure/Agents/ToolDispatcher.cs` | **S1** — allow-list enforcement |
| `Infrastructure/Agents/ToolRegistry.cs` | **S1** |
| `Domain/RuleTables/*.cs` | S4 |

## Adding a new tool — checklist

- [ ] Declare it in `ToolRegistry` with an explicit per-agent allow-list
- [ ] Default to **denied** for every agent not listed
- [ ] Add the consent check if it reads cross-profile data
- [ ] Add the audit write if it reads cross-profile data
- [ ] Add a unit test proving a non-permitted agent is denied and the denial is logged
- [ ] Update the tool permission matrix in this file and in the blueprint
