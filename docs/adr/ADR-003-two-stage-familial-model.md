# ADR-003 — Two-stage familial data model

**Owner:** S4 · **Status:** Accepted · **Date:** 2026-08-06

## Context

The product's differentiator is surfacing **familial** risk signals: a son's recurrent fever and mild anaemia read differently when a biological parent is a confirmed β-thalassaemia carrier. That requires some information to cross member profile boundaries.

But raw health records are the most sensitive data in the system, and members consent individually. The design question is: **what, exactly, is allowed to cross a profile boundary?**

## Options considered

| Option | Pros | Cons |
|---|---|---|
| **Two-stage: extract structured flags per member, reason across the family using flags only** (chosen) | Minimal data crosses; the crossing unit is small, structured and consent-checkable; raw records never leave member scope; the familial agent's raw-record tool can be denied at dispatch, which is provable | Extraction quality becomes a dependency — a missed flag is invisible downstream |
| Give the familial agent read access to every consented member's full records | Simplest to implement; nothing is lost in extraction | Massive privacy exposure; ~8,000 tokens of raw history per relative instead of ~20 tokens of fact; enlarges the hallucination surface; consent becomes all-or-nothing; **indefensible in a viva** |
| No cross-profile analysis at all | Zero privacy exposure | Removes the product's core differentiator; reduces the system to a single-member record app |

## Decision

**Two stages.**

- **Stage 1 — Extraction (per member, isolated).** The Extraction Agent [S2] runs on lab report upload within one member's scope, and writes structured rows to `hereditary_flags`: `{ memberId, conditionCode, inheritancePattern, status, evidenceRef, confidence }`. **Raw record content never leaves this stage.**
- **Stage 2 — Familial analysis (family-wide, flags only).** The Familial Risk Agent [S4] reads consented `hereditary_flags` plus the relationship graph. Its `read_raw_record` tool is **denied at the dispatch layer**, not merely discouraged in a prompt.

Memory hook: **FLAGS CROSS, FILES DON'T.**

## Consequences

**Makes easy**
- Consent becomes meaningful and granular: `HEREDITARY_FLAGS` can be granted without exposing any record.
- Cross-profile reads are small, uniform and cheap to audit — one `audit_log` row per flag read, with `consent_ref_id`.
- The denial is demonstrable live: request `read_raw_record` from the Familial Risk Agent and show the hard error, the `tools_denied` trace row and the halted workflow.
- LLM context stays small, which keeps latency inside the NFR-01 budget.

**Makes hard**
- A condition the Extraction Agent fails to flag is invisible to familial analysis. Mitigated: flags can be entered manually (`extracted_by = MANUAL`) and verified by a doctor (`verified_by_doctor_id`).
- Two agents, two owners, one contract — the `hereditary_flags` schema must be agreed before W5.

**Rules out**
- Any tool that returns another member's raw records to any agent. Permanently.

## Status

Accepted. This is the strongest single design idea in the project and the answer to viva question 4.
