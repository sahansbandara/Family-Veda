# Architecture Decisions — Family Veda

Working decision log. Formal, report-grade ADRs live in `docs/adr/` (ADR-001 … ADR-009) and are what the examiner reads. This file records decisions as they are made, including ones too small for an ADR.

**Format:** Context → Options → Decision → Consequences → Status.

---

## ADR index

| ADR | Title | Owner | Status |
|---|---|---|---|
| [ADR-001](../docs/adr/ADR-001-backend-framework.md) | Backend framework selection | S1 | Accepted |
| [ADR-002](../docs/adr/ADR-002-database-and-orm.md) | Relational database and ORM | S2 | Accepted |
| [ADR-003](../docs/adr/ADR-003-two-stage-familial-model.md) | Two-stage familial data model | S4 | Accepted |
| [ADR-004](../docs/adr/ADR-004-react-state-management.md) | React state management | S3 | Accepted |
| [ADR-005](../docs/adr/ADR-005-flutter-state-management.md) | Flutter state management | S2 | Accepted |
| [ADR-006](../docs/adr/ADR-006-local-llm-ollama.md) | Local LLM via Ollama | S3 | Accepted |
| [ADR-007](../docs/adr/ADR-007-deterministic-safety-layer.md) | Deterministic safety layer | S4 | Accepted |
| [ADR-008](../docs/adr/ADR-008-access-by-grant.md) | Access by grant, not by role | S4 | Accepted |
| [ADR-009](../docs/adr/ADR-009-async-over-video.md) | Async consultation over video | S3 | Accepted |

---

## 2026-07-31 — Product name: Family Veda

**Decision:** the product is named **Family Veda**.

**Reason:** *vedā* (වෙදා) is the Sinhala word for the traditional healer or doctor. The name states the thesis directly — this is the family's doctor, restored to the position of knowing the whole family over time. Locally rooted, immediately meaningful to Sri Lankan users, readable to an English-speaking evaluator.

**Alternatives considered:** *Pavula Care* (describes the account structure, not the clinical value) · *Kulaya Health* (*kulaya* = lineage, carries unwanted caste connotation) · *VedaCare* (cleaner in English, loses the "family" half of the thesis) · *MedLink Family* (descriptive and forgettable).

**Risk:** pronunciation confusion with *vaeda* (වැඩ, "work"). Mitigated by stating the pronunciation *VAY-daa* in the report and demo intro.

**Status:** Accepted.

---

## 2026-07-31 — One repository, four authors (folder-per-student rejected)

**Decision:** one application with three top-level projects (`backend/`, `web/`, `mobile/`), files tagged by owner, seven shared files under a labelled-block convention.

**Reason:** the specification requires React and Flutter to use the same API, database, identity, permissions and business rules. A folder-per-student layout produces four `Program.cs`, four DbContexts, four connection strings and no shared `users` table — the cross-platform workflow becomes physically impossible and `hereditary_flags` written by S2 is unreachable by S4's agent, collapsing the two-stage model. The rubric's lowest agentic band is "only a chatbot or disconnected prototype"; that structure produces disconnected prototypes by construction.

**Alternatives considered:** folder per student (rejected, above) · one repo per student with a shared API repo (rejected — same integration failure, plus four deployments).

**Risk:** merge conflicts and less obvious individual attribution. Mitigated by file-level ownership, branch discipline, small PRs, the migration lock protocol, and the fact that the examiner reads `git log --author`, not directory names.

**Status:** Accepted. Detail in blueprint §14.1.

---

## 2026-07-31 — Component allocation is by business feature, never by layer

**Decision:** each member owns one business component and delivers it across API + DB + React + Flutter + Agents.

**Reason:** 70 of 100 marks are individual, and every individual rubric band reads *"the student can explain, test, modify, or debug"* their contribution. A member who only built the frontend can answer one of six individual criteria.

**Alternatives considered:** split by layer — rejected outright.

**Risk:** every member must be competent in five technologies. Mitigated by the W4 gate forcing both frontends early, and by the weekly ritual surfacing anyone falling behind by W5.

**Note:** S1 owns no agent. S1's agentic contribution is the tool-permission enforcement layer that every agent depends on, plus the CI pipeline. Both are directly assessed and **must be stated explicitly in S1's individual report**.

**Status:** Accepted, pending confirmation at the W1 group meeting.

---

## 2026-07-31 — Scope frozen; deferrals documented, not omitted

**Decision:** scope freezes at the end of Week 5. Anything raised after that goes to `docs/FUTURE_WORK.md` and receives zero lines of code.

**Reason:** the assessed core (agentic workflow, integrated system, deployment, documentation) is worth 100 marks; the deferred features are worth zero. "Deliberately deferred, with the extension point identified" reads as engineering maturity; "we ran out of time" reads as failure.

**Risk:** a genuinely valuable idea arrives at W6 and is refused. Accepted — that is the point of a freeze.

**Status:** Accepted.

---

## 2026-08-04 — Repository converted from universal agent template to project workspace

**Decision:** removed template-only scaffolding (bootstrap prompts, template manifest, duplicated skill trees, off-stack language rules, unrelated skills and workflows) and rewrote `agent/`, `docs/`, `rules/`, `skills/` and `workflows/` against the blueprint. `CLAUDE.md` switched `TEMPLATE_MODE → PROJECT_MODE`.

**Reason:** the template carried ~150 files with no relation to a .NET / React / Flutter clinical project (Python/Go/Rust/Vue/Swift rules, crawler and LLM-selection skills, trading and Telegram content skills, a duplicated `claude/skills` tree). Dead context costs tokens on every boot and dilutes the rules that actually apply.

**Alternatives considered:** leave the template intact and add project files alongside — rejected: two competing sources of truth and a boot sequence pointing at files that describe a different project.

**Risk:** a removed rule turns out to be needed later. Low — everything removed is recoverable from git history, and the template's upstream source is unchanged.

**Status:** Accepted.

---

## 2026-08-04 — Project repository created

**Decision:** the project lives at **https://github.com/sahansbandara/Family-Veda**, public, with `main` (protected, always deployable) and `develop` (integration) already created.

**Reason:** the blueprint's branch strategy needs both branches to exist before feature branches start in W1. The repository is public so the evaluator can be granted access without friction and the link can be submitted directly.

**Alternatives considered:** private repository with per-user collaborator access (rejected — adds friction for the evaluator and for the lecturer's access requirement, and access must be maintained until 21 Oct 2026 regardless) · continuing in the `universal-agent-project-template` repository (rejected — the template is a separate reusable artefact; the old remote is retained locally as `template`).

**Risk:** a public repository is visible to other groups before submission. Accepted deliberately — the marks depend on the viva and on individual `git log --author` evidence, neither of which is transferable by copying the repository. **Consequence to manage:** never commit real patient data, real SLMC numbers, credentials, or deployment secrets. Everything in this repository is world-readable from the moment it is pushed.

**Status:** Accepted.

---

## Open decisions

| # | Question | Owner | Decide by |
|---|---|---|---|
| 1 | Confirm the S1–S4 component allocation | All | W1 meeting |
| 2 | Ollama model: `llama3.1:8b` or a smaller model | S3 | W5, after the latency test on the demo machine |
| 3 | Notification provider: FCM primary vs Twilio SMS fallback | S3 | W6 |
| 4 | Hosting pair: Render + Neon vs Azure + Supabase | S1 | W7, before the W8 deploy gate |
| 5 | OCR engine: Tesseract server-side vs Google ML Kit on-device | S2 | W5, based on accuracy on sample layouts |

## Decision rule

Record here at the moment of decision, including rejected alternatives — the report's ADR section is graded on the trade-off reasoning, and reconstructing it in Week 8 produces weak ADRs.
