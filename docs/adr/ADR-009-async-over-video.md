# ADR-009 — Asynchronous consultation over live video

**Owner:** S3 · **Status:** Accepted · **Date:** 2026-08-06

## Context

A telehealth product suggests video consultation. The specification requires one complete cross-platform workflow, and video would certainly qualify. The question is whether it is the right workflow for *this* product, in nine weeks, with four authors.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| **Asynchronous doctor review** (chosen) | Fits the product thesis — the value is *preparation*, not presence; satisfies the cross-platform workflow requirement fully (Flutter → agents → React → Flutter); the approval gate is a natural pause in an async flow; no third-party media infrastructure | No real-time interaction; the doctor cannot ask a follow-up question live (mitigated by the `AWAITING_INFO` state) |
| Live video (WebRTC) | Impressive demo; familiar telehealth pattern | Signalling server, TURN provisioning, media handling and mobile permissions — realistically 2–3 weeks; would consume the agent budget; adds a live failure mode to the demonstration; **contributes nothing extra to the rubric** |
| Both | Maximum feature coverage | Guarantees neither is finished well |

## Decision

**Asynchronous doctor review.** The cross-platform workflow is: Flutter complaint submission → agentic triage → React doctor approval → notification → Flutter approved guidance.

The `AWAITING_INFO` state covers the follow-up-question case: the doctor requests more information, the member responds, and the case returns to `PENDING_DOCTOR_REVIEW`.

## Consequences

**Makes easy**
- The approval gate — the safety centrepiece — is a natural state in an async workflow. In a live video call there is no obvious place for it.
- Engineering effort goes into the agents, which carry 12 individual marks, rather than into media infrastructure, which carries none.
- The demonstration has no real-time media failure mode.

**Makes hard**
- No live clinician–patient interaction. Accepted: Family Veda's proposition is context, not consultation delivery.

**Rules out**
- WebRTC in v1. Documented as a deliberate deferral in `docs/FUTURE_WORK.md` §18.4, not as an omission.

## Status

Accepted.
