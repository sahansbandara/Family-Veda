# ADR-001 — Backend framework selection

**Owner:** S1 · **Status:** Accepted · **Date:** 2026-08-06

## Context

The system needs one backend serving both a React web client and a Flutter mobile client, with shared identity, permissions and business rules (architectural invariants 1 and 2). It must host the agent orchestration and the tool dispatch layer in-process, expose OpenAPI documentation, and be deployable on a free tier.

The SE3090 specification **mandates ASP.NET Core Web API**. This ADR therefore documents *why the mandate is a good fit* and what the alternatives would have cost — an ADR that says only "it was mandated" scores nothing.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| **ASP.NET Core 8 Web API** (chosen) | Static typing across the whole stack; first-class DI container; EF Core with real migrations; built-in Swagger; `[Authorize]` policy model matches our four-layer authorisation; LTS support to Nov 2026 | Team's C# experience is thinner than JavaScript; heavier local toolchain |
| Node.js + Express/NestJS | Familiar language; shared types with React | Dynamic typing weakens the contract between four authors; migration tooling is weaker than EF Core; **not permitted by the specification** |
| Java Spring Boot | Comparable typing and DI; mature | Heavier ceremony; slower iteration for a 9-week project; **not permitted** |

## Decision

**ASP.NET Core 8 (LTS) Web API with C# 12.**

## Consequences

**Makes easy**
- The authorisation policy model maps directly onto our four layers (authentication → role → scope → consent).
- EF Core migrations give a single, serialisable schema history — critical with four authors sharing one database.
- Built-in OpenAPI generation satisfies the API documentation deliverable with no extra work.
- The tool dispatch layer is a plain C# class the examiner can read, which is what makes invariant 5 provable.

**Makes hard**
- Agent code is written in C# rather than Python, so we forgo the Python agent ecosystem. Mitigated: our agents make structured HTTP calls to Ollama, which is unremarkable in C#.
- The team must invest in C# fluency early — front-loaded into W2.

**Rules out**
- A second backend in any other language. Invariant 1.

## Status

Accepted.
