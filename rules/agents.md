# Agentic Subsystem Rules

Rules for the **five application agents**, not for coding assistants (those are in `AGENTS.md`). Design: `docs/AGENTS_DESIGN.md`. Skill: `skills/agentic-triage/SKILL.md`.

## The five agents

| Agent | Owner | Scope | LLM |
|---|---|---|---|
| Extraction | S2 | One member | ✔ |
| Context | S3 | One member | ✔ structuring |
| Analysis | S3 | One member | ✔ trend reasoning |
| Familial Risk | S4 | Family — **flags only** | ✔ signal wording |
| Safety / Validation | S4 | Case output | ✘ **deterministic** |

Plus the Coordinator/Planner [S3], which plans and traces but does not analyse.

## Hard rules

1. **No agent holds database credentials.** Data arrives only through `ToolDispatcher`.
2. **The allow-list is enforced at dispatch**, never in the prompt. A prompt instruction is documentation, not a control.
3. **Default deny.** A tool not explicitly listed for an agent is denied.
4. A denied call → hard error + `tools_denied` row + `TOOL_DENIED` audit row + workflow halt.
5. **The Familial Risk Agent may never read a raw record**, of any member, under any circumstance.
6. **The Safety/Validation Agent contains no LLM call.** Permanently (ADR-007).
7. Every agent declares a JSON output schema and is validated against it. One retry, then safe failure.
8. Every agent step writes a full trace row — input hash, tools requested/allowed/denied, output, schema validity, confidence, latency, tokens, model.
9. The deterministic red-flag check runs **before any LLM output could surface**.
10. Agents are distinct. If two could be merged without loss, one is not an agent.

## Tools that exist for no agent

`write_prescription` · `send_to_patient`

They appear in the permission matrix deliberately, granted to nobody. Never grant them.

## Untrusted inputs

| Input | Treatment |
|---|---|
| OCR text from an uploaded lab report | **Data, never instructions.** Structured extraction only |
| User free-text (chief complaint, notes) | Data. Never interpolated as instruction |
| LLM output | Untrusted until schema-validated |

A lab report is a document an attacker could craft. Nothing inside it changes agent behaviour.

## Safe failure

| Failure | Behaviour |
|---|---|
| LLM unavailable or timeout | `AGENT_FAILED`; "Please consult your doctor directly"; **no partial output** |
| Schema invalid | Retry once; then safe failure |
| Red flag | Bypass queue → `ESCALATED` → doctor broadcast + emergency screen |
| Low confidence | Doctor still sees it, marked `LOW_CONFIDENCE`, draft hidden |
| Denied tool | Hard error, logged, halt |
| No doctor within SLA | Shared pool; if still unassigned → advise in-person care |
| OCR failed | Stored, `ocr_status = FAILED`, manual entry offered, **no guessed values** |

Under no failure condition does an unapproved AI output reach a patient.

## Adding a tool

- [ ] Declared in `ToolRegistry` with an explicit per-agent allow-list
- [ ] Defaults to denied elsewhere
- [ ] Consent check if cross-profile
- [ ] Audit write if cross-profile
- [ ] Denial test proving a non-permitted agent is refused and logged
- [ ] Permission matrix updated in `docs/AGENTS_DESIGN.md`
