# ADR-005 — Flutter state management

**Owner:** S2 · **Status:** Accepted · **Date:** 2026-08-06

## Context

The Flutter app carries a piece of state that no other surface has: the **active member profile**. A family head switches between their own record, a minor's record and another member's record, and every subsequent screen — records, vitals, complaint submission, case tracker — must reflect the switch. Getting this wrong means showing one member's data under another member's name, which in a health app is the worst possible bug.

It also needs auth/session state driving `go_router` redirects, and async API state on every screen with loading, empty and error handling.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| **Riverpod** (chosen) | Compile-time safe — a missing provider is a build error, not a runtime crash; no `BuildContext` needed, so providers are unit-testable without a widget tree; `ref.watch` dependency graph makes "everything downstream of the active member rebuilds" automatic and explicit | Newer than Provider; the team learns a second mental model |
| Provider | Simplest; widely documented | `context.read` of a missing provider fails at **runtime**; testing requires a widget tree; scoping the active-member dependency is manual and easy to get wrong |
| Bloc / flutter_bloc | Excellent for complex event-driven flows; very testable | Substantial boilerplate per feature; four authors × many screens in nine weeks makes the ceremony cost real |
| `setState` only | No dependency | Cannot express the cross-screen active-member dependency at all |

## Decision

**Riverpod**, with one provider file per owner. The active member is a single provider that every member-scoped provider watches, so a profile switch invalidates all dependent state automatically.

## Consequences

**Makes easy**
- The active-member switch is correct by construction: any provider that reads member data declares its dependency and is invalidated on switch.
- Providers are testable in plain Dart unit tests — cheap coverage toward the 80% requirement.
- `go_router` redirect guards read the auth provider directly, with no `BuildContext` gymnastics.

**Makes hard**
- Learning curve in W2. Mitigated by keeping the provider set small and one file per owner.

**Rules out**
- Passing the active member down the widget tree by hand, which is where the wrong-member bug would come from.

## Status

Accepted.
