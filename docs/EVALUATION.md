# Agent Output Evaluation — Family Veda

How every agent output is judged before it is allowed anywhere near a doctor, and how nothing reaches a patient without approval. Owner of the deterministic layer: **S4**.

## What is evaluated

| Output | Producer | Evaluated by |
|---|---|---|
| `MemberContext` | Context Agent [S3] | JSON schema |
| `AnalysisFindings` | Analysis Agent [S3] | JSON schema + numeric sanity |
| `FamilialRiskSignal` | Familial Risk Agent [S4] | JSON schema + inheritance table consistency |
| `hereditary_flags` row | Extraction Agent [S2] | JSON schema + evidence reference exists |
| `draft_advisory` | Coordinator assembly [S3] | Prohibited-content check [S4] |
| `ValidationVerdict` | Safety Agent [S4] | Deterministic — it *is* the evaluator |

## Hard failures

Any one of these fails the output. There is no partial pass.

| # | Hard failure | Result |
|---|---|---|
| 1 | Output is not valid JSON, or fails its schema | Retry once → safe failure |
| 2 | Prohibited content present (diagnosis, dosing, prescription, diet) | Reject, safe failure, log |
| 3 | A red flag is present in the deterministic table | `ESCALATED`, **zero AI output shown** |
| 4 | Confidence below `Agents__ConfidenceThreshold` | Case still goes to a doctor, marked `LOW_CONFIDENCE`, draft advisory hidden |
| 5 | A denied tool call was attempted | Hard error, `tools_denied` row, workflow halts |
| 6 | A familial claim is made without `unknownParties` where a parent's status is unknown | Reject |
| 7 | A non-biological relationship contributed to hereditary reasoning | Reject |
| 8 | An evidence reference points to a record outside the subject member's scope | Reject, log as a violation |

## Passing condition

An output passes when **all** of the following hold:

- schema valid, and
- zero prohibited content, and
- zero denied-tool violations, and
- confidence at or above threshold, and
- every familial claim carries its caveats and unknown parties.

Passing means the case may enter `PENDING_DOCTOR_REVIEW`. **It does not mean the patient sees anything.** Only `approvals.final_advisory`, written by a licensed doctor, is patient-visible.

## Revision policy

**Maximum one retry.** Schema failure → one regeneration attempt with the same input → second failure goes to the safe-failure path.

Rationale: unbounded retries burn latency, produce non-reproducible behaviour, and give an LLM more chances to drift. A referral is a better outcome than a fifth attempt.

## Deterministic evaluators

Rule tables in `backend/src/Domain/RuleTables/` [S4]. Each is table-driven and unit-tested.

| Table | Purpose |
|---|---|
| `RedFlagSymptoms` | Emergency override. Runs **before** any LLM output could surface |
| `PaediatricVitalRanges` | Age-adjusted out-of-range detection |
| `InheritancePatterns` | Autosomal recessive/dominant, X-linked, polygenic — cited, hardcoded |
| `AllergyContraindications` | Allergy conflict detection |

Rule: **same input, same output, every time.** No LLM call inside a rule table, ever. New rules are added with a test, never by changing a prompt.

## Confidence

- Each LLM agent reports a confidence in `[0.00, 1.00]`.
- `triage_cases.overall_confidence` is the minimum across contributing agents, not the average — a weak link is not averaged away.
- Below threshold: the case still reaches a doctor, marked `LOW_CONFIDENCE`, with the draft advisory hidden so the doctor is not anchored by weak AI text.

## Human approval

| Stage | Approver | Can it be skipped? |
|---|---|---|
| Deterministic validation | System | No |
| Doctor review | Verified doctor with an unexpired case grant | **No — architectural** |
| Patient delivery | Follows approval only | No |

The gate is a persisted status, not a code convention. There is no method that emits patient-visible content from a state other than `APPROVED` or `APPROVED_REVISED`.

## Evaluating the evaluator

Tested in `ToolDenialTests` and the Safety Agent unit tests:

- Feed a draft containing "take 500 mg twice daily" → validation fails.
- Feed a familial claim missing `unknownParties` → validation fails.
- Feed a red-flag symptom → `ESCALATED`, no advisory persisted as patient-visible.
- Feed malformed JSON twice → safe failure, no partial output.
- Have the Familial Risk Agent request `read_raw_record` → denied, logged, workflow halts.

## What is not evaluated automatically

Clinical correctness of the doctor's final advisory. That is the doctor's professional judgement and accountability — which is the entire point of the approval gate.
