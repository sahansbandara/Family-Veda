# Evaluation Rules — agent output

Full policy: `docs/EVALUATION.md`. Owner of the deterministic layer: S4.

## Order of evaluation

```
1. JSON schema validation          (structural)
2. Deterministic rule tables       (safety)
3. Prohibited-content check        (clinical language)
4. Confidence threshold            (reliability)
5. → PENDING_DOCTOR_REVIEW         (human)
```

Hard validation always runs before any subjective consideration. A well-worded output that fails its schema fails.

## Hard failures

| # | Failure | Result |
|---|---|---|
| 1 | Invalid JSON or schema violation | Retry **once** → safe failure |
| 2 | Prohibited content (diagnosis, dosing, prescription, diet) | Reject, safe failure, log |
| 3 | Red flag present | `ESCALATED`, **zero AI output shown** |
| 4 | Confidence below threshold | Doctor still sees it, marked `LOW_CONFIDENCE`, draft hidden |
| 5 | Denied tool call attempted | Hard error, `tools_denied` row, workflow halts |
| 6 | Familial claim missing `unknownParties` where a parent's status is unknown | Reject |
| 7 | Non-biological relationship contributed to hereditary reasoning | Reject |
| 8 | Evidence reference outside the subject member's scope | Reject, log as a violation |

## Rules

1. **Maximum one retry.** Unbounded retries burn latency, break reproducibility, and give the model more chances to drift. A referral beats a fifth attempt.
2. **Deterministic evaluators contain no LLM call.** Ever (ADR-007). Same input, same output.
3. `overall_confidence` is the **minimum** across contributing agents, not the average — a weak link is not averaged away.
4. **Never assert on exact LLM prose** in tests. Assert on schema, structured fields, and what the deterministic layer decided.
5. Passing evaluation means the case may enter `PENDING_DOCTOR_REVIEW`. **It does not mean the patient sees anything.**
6. Only `approvals.final_advisory`, written by a licensed doctor, is patient-visible.
7. New rules are added **to a rule table with a test**, never to a prompt.
8. Do not mark anything verified without evidence — paste the test output.

## What is not evaluated automatically

The clinical correctness of the doctor's final advisory. That is professional judgement and accountability, which is the entire point of the approval gate.
