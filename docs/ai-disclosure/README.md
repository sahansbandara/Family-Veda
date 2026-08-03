# AI Use Disclosure

| Phase | Level | Rule |
|---|---|---|
| Development | **Level 4** | AI assistance permitted, **must be disclosed and verified** |
| Final demonstration | **Level 1** | No external AI assistants, chatbots, IDE copilots or agentic coding tools |
| Viva | **Level 1** | Same. Only the submitted application's own agentic subsystem may run |

## Rules

1. **Each member maintains their own file** — `S1.md`, `S2.md`, `S3.md`, `S4.md`. Never write in another member's file.
2. **Update weekly**, every Sunday, 15 minutes. Reconstructing this in Week 8 produces a vague log that reads as an afterthought.
3. Record: which tool, which task, what was generated, **what you verified and changed**. The verification column is the one the examiner cares about — it is the difference between using a tool and outsourcing your understanding.
4. **The individual reflection is never AI-generated.** The specification states an AI-generated reflection receives no credit. Write it yourself, in your own voice.
5. If you cannot explain a line of code an AI produced for you, either understand it or delete it. Viva question 15 is "modify this now."

## Entry format

| Date | Tool | Task | What was generated | What I verified / changed |
|---|---|---|---|---|
| 2026-08-12 | Example Assistant | Scaffold `ConsentService` | Method stubs and the state transition switch | Rewrote the 18-year transition — the generated version treated `PENDING_REAFFIRMATION` as granted. Added a unit test proving it is treated as not granted |

An entry like the example above scores well: it shows the tool was used, checked, and corrected.
