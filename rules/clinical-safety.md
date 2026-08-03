# Clinical Safety Rules

Read before any agent, advisory, rule table, emergency path, seed clinical data, or patient-visible string. Full reference: `docs/CLINICAL_SAFETY.md`. Skill: `skills/clinical-safety/SKILL.md`.

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

Breaking one is a **CRITICAL** review finding and blocks merge, regardless of who requested it.

## Permitted vs prohibited output

| ✔ Permitted | ❌ Prohibited |
|---|---|
| Factual lab explanation against a reference range | Meal plans, calorie targets |
| Trends across the member's own reports | Behavioural prescriptions |
| Deviation from the member's own baseline | Drug names, doses, prescriptions |
| Recommending a screening test | Diagnosis or probable-diagnosis language |
| Consented familial risk signals | Urgent advice without doctor approval |
| A draft advisory **for doctor review** | Anything patient-visible before approval |

## Genetics

- Never claim inheritance. Claim a screening indication.
- Autosomal recessive, one confirmed carrier parent plus one confirmed non-carrier parent = **0% affected, 50% carrier**. If the other parent's status is unknown, make no numeric affected-risk claim and report `unknownParties`. Both confirmed carriers = 25% affected, 50% carrier.
- Always report `unknownParties` when a contributing parent's status is unknown.
- `relationships.is_biological = false` is excluded from every hereditary computation.
- The inheritance table is hardcoded and cited. **The LLM never generates probabilities.**

## Emergency ordering

The deterministic red-flag check runs **before any LLM output could surface**. If a refactor moves an LLM call ahead of it, that is a critical regression — check this every time the orchestrator changes.

On a hit: referral, Suwa Seriya 1990, nearest hospitals, doctor broadcast, Family Head notified. **Zero AI-generated guidance.**

## Data policy

Synthetic only. No real patient data, real NIC numbers, or real SLMC registration numbers — in code, tests, seeds, screenshots, the demo video, or the report.

## Honesty

| Claim | Truth |
|---|---|
| SLMC verification | Manual, admin-mediated. No public API exists |
| OCR reliability | Assistive, never authoritative |
| Deployed agents | Need a reachable Ollama instance; the demo runs it locally |
| Real-world use | None. Academic prototype, synthetic data |

Never claim an integration that does not exist.

## Pre-merge checklist for clinical-facing changes

- [ ] No diagnosis, drug, dosing, prescription or diet language introduced
- [ ] No code path emits patient-visible content from a non-approved state
- [ ] The red-flag check still runs before any LLM output
- [ ] New cross-profile reads are consent-gated and audited
- [ ] New agent tools default to denied and have a denial test
- [ ] No seed row could be mistaken for real patient data
- [ ] The disclaimer is present on every advisory surface
