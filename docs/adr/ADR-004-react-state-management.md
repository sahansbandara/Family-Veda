# ADR-004 — React state management

**Owner:** S3 · **Status:** Accepted · **Date:** 2026-08-06

## Context

The React app is the clinical and administrative surface. Several pieces of state are genuinely cross-cutting: the authenticated session and role (drives every route guard), the doctor case queue (shared between the queue page, the case detail page and the SLA countdown), and the currently open case (read by the timeline, deviation panel, familial risk panel, trace viewer and approval panel simultaneously).

Four authors also need to add their own slices without colliding — `web/src/store/index.ts` is one of the seven shared files.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| **Redux Toolkit** (chosen) | One store, one registration point — a clean labelled-block seam for four authors; DevTools time-travel makes the case state machine inspectable during the demo; `createSlice` removes most boilerplate; predictable async with `createAsyncThunk` | Extra dependency; more ceremony than Context for trivial state |
| React Context + `useReducer` | Zero dependencies; built in | Every consumer re-renders on any change in the same context — the Case Detail page has five panels reading overlapping state; splitting into many contexts recreates Redux badly, without DevTools |
| TanStack Query alone | Excellent server-cache semantics | Does not solve session/role state or the shared open-case state; we would still need a second solution |
| Zustand | Minimal API, small | Weaker DevTools story; less conventional for an assessed project where the examiner may ask *why* |

## Decision

**Redux Toolkit**, with one slice per owner: `authSlice` [S1], `recordsSlice` [S2], `casesSlice` [S3], `doctorSlice` [S4]. Registration in `store/index.ts` follows the labelled-block convention.

## Consequences

**Makes easy**
- Route guards read `auth` from one place; adding a fifth role is a one-line change.
- Redux DevTools lets us step through the triage case state machine live in the viva — a strong demonstration of "persisted structured state".
- Slice-per-owner maps exactly onto the ownership model, so merge conflicts stay confined to one registration block.

**Makes hard**
- Slightly more setup than Context for the few genuinely local pieces of state. Those stay in `useState` — Redux is for cross-cutting state only.

**Rules out**
- Prop-drilling the session through the component tree.

## Status

Accepted.
