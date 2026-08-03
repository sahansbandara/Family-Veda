# Clinical Safety, Ethics and AI Boundaries — Family Veda

Source: blueprint §7 and §17. **Read this before writing any agent, advisory, seed record, or user-facing clinical string.**

## The ten non-negotiable rules

```
RULE 1  ▸ The system never diagnoses.
RULE 2  ▸ No AI output reaches a patient without doctor approval.
RULE 3  ▸ The approval gate is architectural — there is no bypass path.
RULE 4  ▸ Clinical safety checks are deterministic, never LLM judgement.
RULE 5  ▸ Family history yields a SCREENING INDICATION, never a diagnosis.
RULE 6  ▸ No drug names, no dosing, no prescriptions, no meal plans.
RULE 7  ▸ Synthetic data only. No real patient data, ever.
RULE 8  ▸ Every cross-profile access is consented and audited.
RULE 9  ▸ On any uncertainty, the system defers to in-person care.
RULE 10 ▸ In an emergency the system shows a referral, not AI output.
```

A change that violates one of these is a **CRITICAL** review finding and blocks merge, regardless of who requested it.

## What the AI may and may not produce

| ✔ Permitted | ❌ Prohibited |
|---|---|
| Explain a lab report factually ("HbA1c 7.2, reference below 5.7, above range") | Personalised meal plans or calorie targets |
| Show trends across a member's own reports | Personalised behavioural prescriptions ("do this, don't do that") |
| Flag a deviation from the member's own baseline | Drug names, doses, or prescriptions |
| Recommend a screening test | Diagnosis or probable-diagnosis language |
| Surface consented familial risk signals | Any urgent medical advice delivered without doctor approval |
| Draft an advisory **for doctor review** | Any output shown to a patient before approval |

### Why meal plans are excluded

A dietary plan for a diabetic, renal, pregnant or paediatric patient is **clinical nutrition therapy**. An incorrect plan causes real harm, it carries zero rubric marks, and it cannot be defended in a viva. Generic, sourced public-health information may appear **only** inside a doctor-approved advisory.

## Prohibited-content check (Safety Agent, deterministic)

Runs on every draft advisory before it is persisted. Any hit fails validation.

| Category | Examples of what is caught |
|---|---|
| Diagnosis language | "you have", "this is", "diagnosed with", "confirms", "suffering from" |
| Probability-of-diagnosis language | "most likely X", "probably has", "consistent with a diagnosis of" |
| Drug names and dosing | any drug name; "mg", "ml", "twice daily", "take … " |
| Prescription framing | "prescribe", "start on", "stop taking" |
| Diet and lifestyle prescription | "eat", "avoid eating", "calories", "diet plan", "exercise routine" |
| Inheritance claims | "inherited from", "will develop", "passed down to" |
| Urgency advice without referral | any instruction to act medically that is not "seek in-person care" |

The check is a rule table with unit tests, not a prompt instruction. New patterns are added to the table with a test, never to a prompt.

## Emergency path — deliberately AI-silent

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

The red-flag check runs **before any LLM output could reach the user**. This ordering is the whole safety argument — verify it in code review every time the orchestrator changes.

> **Viva line.** "In an emergency our system deliberately says less, not more. The red-flag check is deterministic and runs before any LLM output could reach the user. Silence plus a referral is the safe failure mode; AI advice in an emergency is not."

## Genetics framing

> Never claim inheritance. Claim a **screening indication**.

| Pattern | One carrier/affected parent | Both carriers | Permitted output |
|---|---|---|---|
| Autosomal recessive | 0% affected · 50% carrier | 25% affected · 50% carrier | Screening indicated; second-parent status required |
| Autosomal dominant | 50% affected | — | Screening indicated |
| X-linked recessive | Depends on the child's sex and which parent | — | Screening indicated; sex-specific note |
| Polygenic / multifactorial | Increased relative risk only | — | Risk factor noted; **no predictive claim** |

Rules:

- Always report `unknownParties` when a contributing parent's status is unknown.
- `relationships.is_biological = false` is excluded from every hereditary computation.
- The inheritance table is hardcoded and cited. **The LLM never generates inheritance probabilities.**

## Required disclaimers

In-app, both platforms, persistently visible on any advisory screen:

> This is a clinical decision-support tool. It does not provide medical diagnosis. All guidance is reviewed and approved by a licensed doctor before you receive it. In an emergency, seek immediate in-person medical care.

In the report: an explicit ethics section stating the synthetic-data policy, the non-diagnostic positioning, and the approval-gate architecture.

## Data ethics

| Policy | Rule |
|---|---|
| Real patient data | **Never.** Not in seeds, tests, screenshots, demo videos, or the report |
| Real SLMC numbers | Never. Synthetic registration numbers only |
| Real NIC numbers | Never |
| Screenshots in the report | Synthetic family only |
| Demo video | Synthetic family only |
| Cross-profile data | Consented, minimal (flags only), audited |
| Retention | Project lifetime; access maintained until 21 Oct 2026 |

## AI use disclosure

| Phase | Level | Rule |
|---|---|---|
| Development | Level 4 | AI assistance permitted, **must be disclosed and verified** |
| Final demonstration | Level 1 | No external AI assistants, chatbots, IDE copilots or agentic coding tools |
| Viva | Level 1 | Same. Only the submitted application's own agentic subsystem may run |

Each member maintains `docs/ai-disclosure/S<n>.md` recording: which tool, which task, what was generated, what was verified and changed.

> **Hard rule.** The individual reflection must not be AI-generated. The specification states an AI-generated reflection receives no credit.

## Honesty rules for the report and viva

| Question | The honest answer |
|---|---|
| How are SLMC numbers verified? | **Manually, by a clinic admin, against the public register.** No public API exists |
| Does OCR work reliably on Sri Lankan lab reports? | Not always. OCR is assistive, never authoritative; manual correction is always offered |
| Is the deployed system running the agents? | The agents need a reachable Ollama instance. The demo runs it locally |
| Has this been used with real patients? | No. Synthetic data only, by policy |

Never claim an integration that does not exist.

## Phrases to never use

> ❌ "Our AI is better than a doctor"
> ❌ "The AI diagnoses the patient"
> ❌ "The son inherits the father's condition"
> ❌ "We'd just call the SLMC API"
> ❌ "The AI has access to all the family's data"
> ❌ "The AI gives urgent advice when no doctor is available"
> ❌ "We didn't have time so we skipped tests"

## Review checklist for any clinical-facing change

- [ ] Does any new string contain diagnosis, dosing, prescription, or diet language?
- [ ] Can the new code path emit patient-visible content from a non-approved state?
- [ ] Does the red-flag check still run before any LLM output could surface?
- [ ] Is any new cross-profile read consent-gated and audited?
- [ ] Does any new agent tool default to denied for agents not listed?
- [ ] Does any new seed row contain data that could be mistaken for real patient data?
