---
name: tool-router
description: Use when adding, changing or debugging an agent tool, the ToolRegistry, the ToolDispatcher, or the per-agent allow-list; also when choosing how the backend should reach an external service (notifications, OCR, LLM). Fires on "add a tool", "tool denied", "allow-list", "ToolDispatcher", "third-party integration".
---

# Tool Router

Two distinct concerns share the word "tool" in this project. Route to the right one.

| Concern | Owner | Reference |
|---|---|---|
| **Agent tools** — what the five agents may call | S1 (`ToolRegistry`, `ToolDispatcher`) | `docs/AGENTS_DESIGN.md` · `rules/agents.md` |
| **External services** — how the backend reaches FCM, Twilio, Ollama, OCR | Per owner | below |

---

## Part 1 — Agent tools

### The rule

**The allow-list is enforced at dispatch, never in the prompt. Default deny.**

```csharp
if (!registry.IsAllowed(agent, tool))
{
    await audit.ToolDeniedAsync(agent, tool, ct);
    throw new ToolDeniedException(agent, tool);   // hard error — the workflow halts
}
```

A prompt line saying "you must not read other members' records" is documentation, not a control. The demonstrable denial is what earns the marks.

### Adding a tool — checklist

- [ ] Declared in `ToolRegistry` with an explicit per-agent allow-list
- [ ] **Defaults to denied** for every agent not listed
- [ ] Consent check if it reads cross-profile data
- [ ] Audit write if it reads cross-profile data
- [ ] Unit test proving a non-permitted agent is refused **and** the refusal lands in `agent_traces.tools_denied`
- [ ] Tool permission matrix updated in `docs/AGENTS_DESIGN.md`

### Scope discipline

Ask: **what is the smallest data that answers this question?** The two-stage model exists because a hereditary assessment needs ~20 tokens of structured fact per relative, not 8,000 tokens of raw history.

### Permanently forbidden

| Tool | Status |
|---|---|
| `read_raw_record` for the Familial Risk Agent | **Denied.** ADR-003. Never grant |
| `write_prescription` | Exists for **no agent** |
| `send_to_patient` | Exists for **no agent** — delivery follows doctor approval |
| Anything giving an agent a database connection | Invariant 5 |

---

## Part 2 — External services

### Routing priority

```
1. Direct API from the backend
2. Vendor SDK
3. Nothing else — no browser automation, no scraping
```

This project integrates exactly three external things. There is no web-data acquisition requirement.

| Service | Reached by | Never reached by |
|---|---|---|
| FCM push (fallback Twilio SMS) | `FcmNotificationClient` [S3], backend only | A client. Invariant 4 |
| Ollama | `OllamaClient` [S3], backend only, localhost | A client. Invariant 3 |
| OCR (Tesseract / ML Kit) | `TesseractOcrService` [S2] | — |

### Rules

- Secrets in environment variables only (`docs/ENV_VARS.md`).
- Timeout, one retry, then a defined fallback. Never an unbounded retry.
- Treat every response as untrusted input — especially OCR text.
- Do not add a fourth external dependency without a group decision recorded in `agent/DECISIONS.md`. The scope is frozen.

## Stop conditions

Stop and ask before: granting a new tool to an agent · storing a credential · adding an external dependency · anything that would let a client reach the agents or a third-party service directly.
