# ADR-012 — Hosted LLM inference

**Owner:** S3 · **Status:** Proposed (AI-drafted 2026-09-18 — owner must review, edit and accept) · **Supersedes:** [ADR-006](ADR-006-local-llm-ollama.md) · **Date:** 2026-09-18

## Context

ADR-006 chose local Ollama and accepted that "the deployed API cannot run the agent workflow without a reachable Ollama instance". Two facts changed:

1. SE3090 §16 and §17.1 require the application's agentic subsystem to be **executed during the evaluation**, and the team decided the whole system must be hosted, not laptop-dependent.
2. The API host (Render free, ADR-010) has 512 MB RAM — too small for any useful local model.

Constraints kept from ADR-006: zero cost, no clinical judgement by the LLM, deterministic safety (ADR-007), mandatory doctor approval.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| **Groq free API, `llama-3.1-8b-instant`, OpenAI-compatible** (chosen) | Free, no card; ~1–2 s per call; same Llama 3.1 8B family as ADR-006; JSON mode; one small client | Synthetic data leaves team hardware; free-tier rate limits; external dependency |
| Hugging Face Space running Ollama | Free; Ollama code unchanged | CPU only: 20–40 s per call (3B) or minutes (8B); sleeps after 48 h idle |
| Oracle Cloud free ARM VM + Ollama | Always on; data on team-controlled VM | Card signup, approval can fail; 30–60 s per call; server ops |
| Keep local Ollama + tunnel | Privacy argument intact | Only works while a laptop is on — not a hosted system |

## Decision

Use Groq through `ChatCompletionsLlmClient`, which implements the existing `IOllamaClient` contract so agents are unchanged. Provider is chosen by `Llm__Provider` (`openai-compatible` in production, `ollama` still available for local development). The key is `Llm__ApiKey`, a Render dashboard secret. Behaviour kept from `OllamaClient`: per-call timeout, exactly one retry, strict JSON deserialisation with unknown fields rejected, `AgentOutputValidator` semantic checks, fail-closed `InvalidOperationException` → case `FailedSafe`.

## Consequences

**Makes easy:** agents run on the deployed system; latency well inside NFR-01 (60 s workflow); no GPU or server to maintain.

**Makes hard:** the privacy position changes. The report must state plainly: all data is synthetic (Rule 7); only the fields each agent's allow-listed tools return are sent; HTTPS only; the key never reaches a client; clients never call Groq (invariant 3). Rate limits (HTTP 429) surface as safe failures, not partial output.

**Rules out:** claiming local/private inference in the report or viva.

## Status

Proposed. Accept after S3 review and one hosted end-to-end triage run.
