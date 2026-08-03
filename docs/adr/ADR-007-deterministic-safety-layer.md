# ADR-007 — Deterministic safety layer

**Owner:** S4 · **Status:** Accepted · **Date:** 2026-08-06

## Context

Some decisions in this system are safety-critical: is this symptom a red flag requiring immediate escalation? Is this vital sign out of range for a 12-year-old? Does this draft advisory contain prohibited content? Does this familial claim overstate what inheritance permits?

An LLM answering these questions gives a *different answer to the same input on different runs*. For a clinical safety check, non-reproducibility is disqualifying — you cannot audit it, cannot test it, and cannot defend it.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| **Deterministic rule tables, no LLM** (chosen) | Same input, same output, always; unit-testable table-driven; auditable; explainable to an examiner in one sentence; runs in microseconds so it can gate everything | Rule tables must be written and cited by hand; they cannot generalise beyond what is encoded |
| LLM judgement with a safety prompt | Generalises to unseen symptoms; less upfront work | Non-reproducible; untestable in any meaningful sense; a prompt is advisory, not enforcement; a hallucinated "no red flag" on chest pain is a catastrophic failure mode |
| Hybrid — LLM proposes, rules confirm | Some generalisation with a safety net | The rules are still the binding layer, so the LLM adds latency and a failure mode without adding safety. Rejected as complexity for no gain |

## Decision

**The Safety/Validation Agent uses no LLM.** It is deterministic rule tables plus JSON schema validation plus a prohibited-content check.

Tables in `backend/src/Domain/RuleTables/` [S4]:

| Table | Purpose |
|---|---|
| `RedFlagSymptoms` | Emergency override — **runs before any LLM output could surface** |
| `PaediatricVitalRanges` | Age-adjusted out-of-range detection |
| `InheritancePatterns` | Autosomal recessive/dominant, X-linked, polygenic — cited, hardcoded |
| `AllergyContraindications` | Allergy conflict detection |

The Safety Agent is also the only agent that can **halt the workflow**.

## Consequences

**Makes easy**
- Every safety behaviour is a table-driven unit test. "Prove your emergency path works" is answered by running tests, not by demonstrating one lucky example.
- The emergency ordering guarantee — deterministic check before any LLM output — is a property of the orchestration, verifiable by reading one method.
- The inheritance table means the LLM **never** generates inheritance probabilities, which removes the highest-risk hallucination in the whole product (risk R7).
- Answers viva question 6 in one sentence.

**Makes hard**
- Coverage is exactly what is encoded. An unlisted red-flag symptom is not caught. Mitigated: the tables are cited from published clinical red-flag lists, reviewed by the group, and the residual limitation is stated openly in the report rather than hidden.
- Adding a rule requires a code change and a test, not a prompt edit. This is intentional friction.

**Rules out**
- Any future "improvement" that replaces a rule table with an LLM call. Do not do this.

## Status

Accepted.
