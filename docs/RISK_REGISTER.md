# Risk Register — Family Veda

Source: blueprint §21. Reviewed at every Monday meeting; state updated in this file.

| # | Risk | Likelihood | Impact | Mitigation | Owner | State |
|---|---|---|---|---|---|---|
| **R1** | Agent workflow not working by W6 | Medium | **Critical** | Hard gate at W6; contingency is 3 agents instead of 4 | S3 | Open |
| **R2** | Ollama too slow on team hardware | Medium | High | Test in W5 on the **actual demo machine**; smaller model; cache context | S3 | Open |
| **R3** | OCR accuracy poor on Sri Lankan lab report formats | **High** | Medium | Manual correction UI as fallback; OCR is assistive, **never authoritative** | S2 | Open |
| **R4** | Integration left until the end | Medium | **Critical** | W4 gate forces end-to-end integration at the halfway point | All | Open |
| **R5** | A member underperforms | Medium | High | Weekly checkpoints; **written** escalation to the lecturer by W5 | S3 (leader) | Open |
| **R6** | Free-tier hosting sleeps or fails during evaluation | Medium | High | Deploy in W8, verify daily in W9; local fallback ready | S1 | Open |
| **R7** | Examiner challenges the genetics framing | **High** | High | `docs/CLINICAL_SAFETY.md` genetics section memorised by all four members | S4 | Open |
| **R8** | Scope creep | High | High | Feature freeze at W5; new ideas go to `docs/FUTURE_WORK.md` | All | Open |
| **R9** | A member cannot explain their own component | Medium | **Critical** | Mock viva ×2 in W9; each member demos to the group first | All | Open |
| **R10** | Report written in the last week | High | High | 15 minutes every Sunday, per member, from W1 | All | Open |
| **R11** | Demo fails live | Medium | High | Rehearse ×5; recorded video as backup; seeded demo data pre-loaded | S3 | Open |

## Project-specific technical risks

| # | Risk | Mitigation |
|---|---|---|
| **T1** | Two members generate EF migrations simultaneously → conflicting model snapshots | The migration lock protocol. Announced in the group chat, one at a time |
| **T2** | A `⚠ SHARED` file is reformatted, turning a clean merge into a conflict | Labelled-block convention: add lines, never reorder or reformat |
| **T3** | LLM returns prose instead of JSON | Schema validation + one retry + safe failure. Never parse loosely |
| **T4** | An agent tool is added without an allow-list entry and silently works for everyone | `ToolRegistry` defaults to **denied**; every new tool needs a denial test |
| **T5** | A prompt-injection payload arrives via OCR text on an uploaded lab report | OCR output is data, never instructions. Structured extraction only; no free-form instruction following |
| **T6** | Patient-visible endpoint accidentally reads `draft_advisory` | The advisory a patient sees comes from `approvals.final_advisory` only. Covered by a test |
| **T7** | Physical Android device unavailable for the W7/W8 device checks | Confirm device access in W1; borrow a second device as backup |

## Escalation

| Situation | Escalate to | When |
|---|---|---|
| A member 2+ weeks behind | Lecturer-in-charge, **in writing** | By W5 |
| A weekly gate missed | Group leader (S3) → apply the contingency rule | Same week |
| Two gates missed in a row | Lecturer-in-charge | Immediately |
| Any clinical safety rule violated in merged code | Group leader + revert | Immediately |

## Review log

| Date | Change |
|---|---|
| 2026-08-04 | Register created from blueprint §21; technical risks T1–T7 added |
