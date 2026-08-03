---
name: clinical-safety
description: Use before writing or changing anything that produces clinical output or affects patient safety — agent outputs, advisories, rule tables, red-flag handling, familial risk and genetics wording, emergency screens, seed clinical data, disclaimers, or any patient-visible string. Fires on any mention of diagnosis, symptoms, drugs, dosing, diet, inheritance, or emergency.
---

# Clinical Safety

Full reference: `docs/CLINICAL_SAFETY.md`. This skill is the gate you run **before** writing.

## The ten rules

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

A change that breaks one of these is a **CRITICAL** finding and blocks merge — regardless of who asked for it. Say so plainly and propose the compliant version.

## Permitted vs prohibited output

| ✔ Permitted | ❌ Prohibited |
|---|---|
| Factual lab explanation ("HbA1c 7.2, reference below 5.7, above range") | Meal plans, calorie targets |
| Trends across the member's own reports | Behavioural prescriptions ("do this, don't do that") |
| Deviation from the member's own baseline | Drug names, doses, prescriptions |
| Recommending a screening test | Diagnosis or probable-diagnosis language |
| Consented familial risk signals | Urgent advice without doctor approval |
| A draft advisory **for doctor review** | Anything patient-visible before approval |

## Genetics — the highest-risk topic

Never claim inheritance. Claim a **screening indication**.

| ❌ Wrong | ✔ Correct |
|---|---|
| "Son has thalassaemia because his father does" | "First-degree relative is a confirmed β-thalassaemia carrier. Maternal carrier status is unknown. Screening (HbA2, full blood count) is indicated before any conclusion." |
| "This condition is inherited automatically" | "Autosomal recessive: both parents must be carriers for the condition to manifest. One carrier parent alone is insufficient." |
| "Your son will have hair loss like his father" | "Androgenetic alopecia is polygenic with contributions from both parental lines. No predictive claim can be made." |

Rules:
- Autosomal recessive, one carrier parent = **0% affected, 50% carrier**.
- Always report `unknownParties` when a contributing parent's status is unknown.
- `relationships.is_biological = false` is excluded from every hereditary computation.
- The inheritance table is **hardcoded and cited**. The LLM never generates probabilities.

## Emergency ordering — verify this every time the orchestrator changes

```
deterministic red-flag check
        ↓ (runs BEFORE any LLM output could surface)
   HIT  → emergency screen: referral, 1990, hospitals, doctor broadcast
          ✘ ZERO AI-generated guidance
   MISS → normal triage → approval gate
```

If a refactor ever moves an LLM call ahead of the red-flag check, that is a critical regression.

## Prohibited-content check

Deterministic rule table, unit-tested. Catches: diagnosis language · probability-of-diagnosis language · drug names and dosing · prescription framing · diet and lifestyle prescription · inheritance claims · urgency advice without referral.

New patterns are added **to the table with a test**, never to a prompt.

## Pre-write gate

Before writing any clinical-facing string or code path:

- [ ] Could this text be read as a diagnosis?
- [ ] Does it name a drug, a dose, or a diet?
- [ ] Does it make a predictive claim about inheritance?
- [ ] Can this code path emit patient-visible content from a non-approved state?
- [ ] Does the red-flag check still run first?
- [ ] Is any new cross-profile read consent-gated **and** audited?
- [ ] Does any new tool default to denied?
- [ ] Could any seed row be mistaken for real patient data?

## When a request conflicts with these rules

State the conflict in one sentence, name the rule, and offer the compliant version. Do not silently narrow the request and do not moralise.

> "That would put dosing text on a patient screen, which breaks RULE 6. What I can do instead is surface the lab value against its reference range and route the case to the doctor for the medication decision."

## Honesty rules

| Question | The honest answer |
|---|---|
| How are SLMC numbers verified? | Manually, by a clinic admin. **No public API exists** |
| Does OCR work reliably? | Not always. Assistive, never authoritative; manual correction always offered |
| Is the deployed system running the agents? | Only with a reachable Ollama instance. The demo runs it locally |
| Has this been used with real patients? | No. Synthetic data only, by policy |

Never claim an integration that does not exist.
