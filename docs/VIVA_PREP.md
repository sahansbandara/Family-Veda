# Viva Preparation Pack — Family Veda

10-minute demonstration + 20-minute viva. 70 of 100 marks are individual. Source: blueprint §20 and Appendix A.

**Level 1 AI use applies during the demo and viva.** No external AI assistants, chatbots, IDE copilots or agentic coding tools. Only the submitted application's own agentic subsystem may run.

## Questions every member must answer

| # | Question | Answer direction |
|---|---|---|
| 1 | Is this a chatbot? | No. Four agents with distinct scopes, tools and outputs; a persisted state machine; deterministic validation; a mandatory approval gate; full traces. **Show the agent comparison table** |
| 2 | What makes your agents *distinct*? | Different scope (member vs family), different tool allow-lists, different output schemas; one is fully deterministic. **Show the tool permission matrix** |
| 3 | Your AI touches medical data. Justify it. | It does not diagnose. It assembles context. No output reaches a patient without licensed doctor approval, enforced architecturally |
| 4 | Does the agent read the whole family's records? | No. Raw records stay member-scoped. Only consented structured hereditary flags cross profile boundaries. The familial agent's raw-record tool is **denied at the dispatch layer** |
| 5 | Father is a thalassaemia carrier — does the son have it? | We cannot conclude that. Autosomal recessive conditions require relevant variants from both parents. If the other parent's status is unknown, we make no numeric affected-risk claim; we report `unknownParties` and indicate screening |
| 6 | What is deterministic validation? | Fixed rule tables, reference ranges and JSON schema checks. Same input, same output. Not LLM judgement |
| 7 | What if the LLM fails or hallucinates? | Schema validation, one retry, then safe failure. The patient sees "consult your doctor directly", never a partial or unapproved output |
| 8 | What does the AI do in an emergency? | Deliberately less. A deterministic red-flag check runs before any LLM output could surface. The user sees a referral and emergency contacts, not AI guidance |
| 9 | Why no meal plans or lifestyle advice? | Clinical nutrition therapy requires a clinician. Generic public-health information only, and only inside a doctor-approved advisory |
| 10 | How do you verify a doctor is real? | Manual admin verification against the public SLMC register in v1. Automated registry integration is future work — **no public API exists** |
| 11 | Can any verified doctor see any patient? | No. Access is by time-bound, case-scoped grant in `case_access_grants`, not by role. Grants expire and are audited |
| 12 | What happens when a minor turns 18? | Guardian-granted consents move to `PENDING_REAFFIRMATION` and are treated as not granted until the member personally confirms |
| 13 | Where is real patient data? | Nowhere. Synthetic seed data only, stated in the report's ethics section |
| 14 | Show me your individual contribution. | Open your commits, your endpoints in Swagger, your React screen, your Flutter screen, your agent, your tests |
| 15 | **Modify this now.** | Add a validation rule, change a status transition, or add a field end to end — **within five minutes** |
| 16 | Why Redux Toolkit / Riverpod / Ollama? | Point to the ADR and give the trade-off in one sentence |
| 17 | What did you cut, and why? | `docs/FUTURE_WORK.md`. Named deferrals with reasons and reserved extension points — not omissions |

## Per-member individual questions

Each member must be able to do all four for their **own** component, live:

1. **Explain** — what it does, why it is designed this way, what the alternatives were.
2. **Demonstrate** — Swagger endpoint → React screen → Flutter screen → agent → test.
3. **Modify** — add a field, a validation rule, or a status transition end to end in five minutes.
4. **Debug** — be handed a deliberately broken version and find the fault.

### S1 — Family, Identity & Consent
- Walk through the four authorisation layers and where each is enforced.
- Show the consent state machine, including the 18-year rule, in code and in the UI.
- **Show a denied agent tool call live** — the trace row, the audit row, the halted workflow. This is S1's headline moment.
- Explain why S1 owns no agent and why the tool-permission layer is an agentic contribution.

### S2 — Health Records & Extraction
- Show the camera capture on a physical device, end to end.
- Show the OCR failure path: `ocr_status = FAILED`, no guessed values, manual entry offered.
- Explain the Extraction Agent's scope and why raw content never leaves Stage 1.
- Show a `hereditary_flags` row and trace it through either `lab_report_id` or `health_record_id`.

### S3 — Triage & Orchestration
- Walk the state machine from `SUBMITTED` to `CLOSED`, naming every transition trigger.
- Show the Coordinator's plan and trace step 0.
- Explain the difference between the Context and Analysis agents in one sentence each.
- Show the Agent Trace Viewer and read one trace row aloud.
- Show the safe-failure path with Ollama stopped.

### S4 — Familial Risk & Clinical Approval
- Explain autosomal recessive inheritance without notes.
- Show `unknownParties` in a real output.
- Show the deterministic rule tables and explain why they are not LLM-driven.
- Show the approval gate and confirm there is no bypass path.
- Show a grant expiring and the resulting 403.

## Phrases to use

> "context assembly, not clinical conclusion"
> "data minimisation — flags cross profiles, files do not"
> "access by grant, not by role"
> "the approval gate is architectural, not procedural"
> "deterministic validation, not LLM judgement"
> "screening indication, not diagnosis"
> "safe failure — the patient sees nothing unapproved"
> "deliberately deferred, with the extension point reserved"

## Phrases to never use

> ❌ "Our AI is better than a doctor"
> ❌ "The AI diagnoses the patient"
> ❌ "The son inherits the father's condition"
> ❌ "We'd just call the SLMC API"
> ❌ "The AI has access to all the family's data"
> ❌ "The AI gives urgent advice when no doctor is available"
> ❌ "We didn't have time so we skipped tests"

## Memory hooks

| Hook | Meaning |
|---|---|
| **P-A-V-A** | Prepare · Analyse · Validate · Approve. AI does the first three; the doctor does the fourth |
| **FLAGS CROSS, FILES DON'T** | The two-stage data model |
| **P-V-G** | Pending · Verified · Grant. Access comes from the grant, not the role |
| **GATE OR GONE** | If it did not pass the approval gate, the patient never sees it |
| **2-4-6-8** | W2 CI green · W4 CRUD end-to-end · W6 agents complete · W8 deployed |
| **S-R-S** | Signal not diagnosis · Recessive needs both · Share flags not files |

## The 10-minute demonstration script

Rehearse this exact sequence at least five times, with seeded data pre-loaded.

| Time | Step | Owner |
|---|---|---|
| 0:00–0:45 | Problem and positioning: the context gap; "the AI does context, the doctor does medicine" | S3 |
| 0:45–2:00 | Flutter: father uploads the son's FBC via **camera**; OCR runs; a `hereditary_flags` row appears | S2 |
| 2:00–3:15 | Flutter: father submits "son, 12, fever 3 days" | S3 |
| 3:15–5:00 | React: doctor opens the case — timeline, deviations, familial signal with `unknownParties`, draft advisory | S4 |
| 5:00–6:15 | React: Agent Trace Viewer — four steps, tools requested/allowed/**denied**, confidence, latency | S3 |
| 6:15–7:00 | **Live denied tool call** — the Familial Risk Agent's raw-record request is refused and logged | S1 |
| 7:00–8:00 | React: doctor revises and approves | S4 |
| 8:00–8:45 | Flutter: push notification; father reads the approved guidance and screening advice | S3 |
| 8:45–10:00 | Emergency path: submit a red-flag complaint → referral screen, **zero AI output** | S4 |

Backup: the recorded video, in case the live demo fails (risk R11).

## Mock viva schedule (W9)

| Session | Format |
|---|---|
| Mock 1 | Each member presents their component to the group. The group asks the 17 questions |
| Mock 2 | Cross-examination: each member is asked about **another** member's component, then handed a broken build to debug |
