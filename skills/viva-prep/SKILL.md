---
name: viva-prep
description: Use when preparing for the SE3090 demonstration or viva, rehearsing the demo script, drilling viva questions, preparing to explain/modify/debug a component live, or writing the individual report sections. Fires on mentions of viva, demo, presentation, mock viva, or "explain my component".
---

# Viva Prep

10-minute demonstration + 20-minute viva. **70 of 100 marks are individual.** Full pack: `docs/VIVA_PREP.md`.

**Level 1 AI use applies during the demo and viva.** No external AI assistants. Only the submitted application's own agentic subsystem runs. Preparation is Level 4 and disclosed; performance is unaided.

## What is actually being tested

Every individual rubric band reads: *"the student can **explain, test, modify, or debug**"* their contribution. Not "the student built". Four verbs, all live.

| Verb | What it means on the day |
|---|---|
| **Explain** | What it does, why designed this way, what the alternatives were |
| **Demonstrate** | Swagger endpoint → React screen → Flutter screen → agent → test, all yours |
| **Modify** | Add a field, a validation rule, or a status transition end to end **in five minutes** |
| **Debug** | Be handed a broken build and find the fault |

If you can only do the first, you score the lowest band.

## Drill order

1. **Your own component, four verbs.** Practise the five-minute modification until it is muscle memory.
2. **The three memorised tables:** agent comparison (`docs/AGENTS_DESIGN.md`), tool permission matrix, inheritance patterns.
3. **The 17 group questions** in `docs/VIVA_PREP.md`. Every member answers all 17.
4. **The demo script**, your segment, timed.
5. **Cross-examination:** answer questions about *another* member's component. The examiner may ask.

## Answer shape

One sentence of answer, then the evidence, then the caveat if there is one. Not a paragraph of context ending in a conclusion.

> **Q:** Does the agent read the whole family's records?
> **A:** No. Raw records stay member-scoped; only consented structured hereditary flags cross profile boundaries. The Familial Risk Agent's raw-record tool is denied at the dispatch layer — here is the denial, and here is the `tools_denied` row it wrote.

## Phrases to use

> "context assembly, not clinical conclusion"
> "data minimisation — flags cross profiles, files do not"
> "access by grant, not by role"
> "the approval gate is architectural, not procedural"
> "deterministic validation, not LLM judgement"
> "screening indication, not diagnosis"
> "safe failure — the patient sees nothing unapproved"
> "deliberately deferred, with the extension point reserved"

## Phrases that lose marks

> ❌ "Our AI is better than a doctor"
> ❌ "The AI diagnoses the patient"
> ❌ "The son inherits the father's condition"
> ❌ "We'd just call the SLMC API"
> ❌ "The AI has access to all the family's data"
> ❌ "The AI gives urgent advice when no doctor is available"
> ❌ "We didn't have time so we skipped tests"

## Memory hooks

| Hook | Meaning |
|---|---|
| **P-A-V-A** | Prepare · Analyse · Validate · Approve. AI does three, the doctor does the fourth |
| **FLAGS CROSS, FILES DON'T** | The two-stage data model |
| **P-V-G** | Pending · Verified · Grant. Access comes from the grant |
| **GATE OR GONE** | Not through the gate, not seen by the patient |
| **2-4-6-8** | W2 CI green · W4 CRUD · W6 agents · W8 deployed |
| **S-R-S** | Signal not diagnosis · Recessive needs both · Share flags not files |

## When you do not know

Say so, then say what would answer it. A confident wrong answer about genetics or authorisation costs more than an honest "I'd have to check — it's in the inheritance table in `Domain/RuleTables`."

Never invent an integration, a figure, or a source under pressure.

## Demo failure plan

Risk R11 is real. Before the demo: data pre-seeded, Ollama warm, deployed URLs verified that morning, physical device charged and paired, **recorded backup video accessible offline**. If the live demo fails, switch to the video without apology and keep narrating.

## Writing the individual report

Use `docs/individual-reports/S<n>.md`. Show evidence, not claims: file paths, endpoint names, screenshots, `git log --author="<you>"`, test results with coverage.

**The personal reflection is written by you, never AI-generated.** The specification states an AI-generated reflection receives no credit — and this skill will not draft one for you. It can help you *outline questions to answer*; the words must be yours.
