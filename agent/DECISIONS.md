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

## 2026-08-04 — Resolve pre-implementation schema and safety contradictions

**Decision:** the baseline uses 19 persisted tables; administrators remain `users` with `user_type = ADMIN`; hereditary evidence uses two nullable foreign keys with an exactly-one check; agent traces persist requested, allowed and denied tool sets; and unknown second-parent carrier status produces no numeric affected-risk claim.

**Reason:** the previous documentation counted 18 tables while assigning 19, diagrammed an undefined `admins` table, described one foreign key targeting two unrelated tables, omitted evidence needed by the trace viewer, and presented a recessive-risk percentage that assumed an unrecorded non-carrier parent. These contradictions would produce an unenforceable schema and an unsafe demonstration claim.

**Alternatives considered:** add a twentieth polymorphic evidence table (rejected for MVP complexity) · keep `evidence_ref` as an unenforced UUID (rejected because referential integrity is a security property) · create a separate `admins` table (rejected because admin identity has no separate domain data) · calculate risk while a parent's status is unknown (rejected because the input is incomplete).

**Consequences:** `hereditary_flags` requires exactly one of `lab_report_id` or `health_record_id`; traces add `tools_allowed`; adult and emergency access remain grant- and consent-controlled; relevant docs, tests and viva wording must use the corrected uncertainty rule.

**Status:** Accepted with explicit user approval.

---

## 2026-08-04 — Durable notifications and deployment targets

**Decision:** add `notification_subscriptions` as the twentieth table; protect device tokens with ASP.NET Data Protection; use FCM HTTP v1 through the backend; use Tesseract server-side OCR with manual fallback; target Render + Neon + Vercel.

**Reason:** one `users.device_token` cannot represent multiple devices or token rotation safely. FCM legacy server-key transport is obsolete. OCR must remain assistive and repeatable on API hosts. The user selected the hosting stack explicitly.

**Alternatives considered:** in-memory subscriptions (rejected because restarts lose delivery state) · one device token on `users` (rejected because multi-device users overwrite each other) · legacy FCM server key (rejected in favour of HTTP v1 service-account OAuth) · on-device-only OCR (rejected because web uploads need the same extraction path).

**Consequences:** schema has 20 tables; a new migration adds only `notification_subscriptions`; hosted environments need persistent Data Protection keys, FCM service-account JSON, and persistent upload storage. Render cannot run local Ollama, so hosted agent execution still needs a separately reachable user-controlled Ollama endpoint.

**Status:** Accepted with explicit user approval; migration applied successfully to PostgreSQL 16 Testcontainers.

---

## 2026-08-04 — Fail closed on unconfirmed extraction and uncited clinical tables

**Decision:** OCR-created lab values and hereditary flags are excluded from agent tools until a family user manually reviews and confirms them. Paediatric and allergy rule-table interfaces return `clinician review required` until the group supplies authoritative approved citations.

**Reason:** OCR is assistive and may misread a report. Inventing clinical thresholds to make a demo appear complete would be clinically unsafe and violate the project's evidence policy.

**Alternatives considered:** trust completed OCR automatically (rejected: extraction status is not clinical confirmation) · populate plausible internet-derived thresholds without group citations (rejected: unverifiable and unsafe) · remove the rule-table extension points (rejected: the required deterministic architecture should remain explicit).

**Consequences:** the web includes manual extraction review; only confirmed rows cross into Analysis/Familial Risk tools. Until citations are approved, paediatric/allergy evaluations deliberately produce no clinical interpretation.

**Status:** Accepted.

---

## 2026-08-04 — Emergency and delayed cases always produce deterministic referral paths

**Decision:** emergency cases remain `ESCALATED`, retain no draft advisory, receive a primary-doctor grant when available, and otherwise enter a verified-doctor emergency pool. Cases exceeding the doctor SLA remain reviewable but receive a deterministic in-person-referral marker and notification.

**Reason:** patient referral and doctor visibility are both necessary; changing an emergency case to `CLAIMED` would incorrectly remove the mobile emergency route. An overdue case should not silently wait while still allowing a doctor to take responsibility.

**Alternatives considered:** notify only the patient (rejected: disconnected referral) · change emergency status to claimed (rejected: weakens emergency safety UI) · close overdue cases (rejected: prevents later review).

**Status:** Accepted.

---

## 2026-08-04 — Independent adult accounts are the MVP family boundary

**Decision:** a family head may create minor profiles only. Adult users maintain linked independent accounts; invitation/join-token support is deferred.

**Reason:** creating an unlinked adult produces an inaccessible orphan and violates adult privacy. A secure invitation system needs token lifecycle, expiry and a migration that are not necessary for the assessed core workflow.

**Alternatives considered:** allow unlinked adult profiles (rejected: inaccessible and privacy-unsafe) · silently attach adult data to the family head (rejected: account ownership violation) · implement invitations during the frozen core build (deferred as a distinct feature).

### DEC-017 — Adult invitation flow supersedes deferral

**Decision:** implement one-time adult family invitations. Store SHA-256 token hashes and token-keyed HMAC email hashes; expire after 48 hours; bind acceptance to authenticated account email; reject minors, replay, and already-linked accounts.

**Reason:** final review found adult membership otherwise impossible. This closes workflow while preserving independent adult accounts and privacy.

**Alternatives considered:** keep deferral (rejected: incomplete core workflow) · store raw email/token (rejected: avoidable credential/identity exposure) · let family head create adult profile (rejected: ownership/privacy violation).

### DEC-018 — De-identified clinical pool and bounded image OCR

**Decision:** pre-grant pool returns only opaque case ID, priority, and queue time; reads are audited. Doctor push goes only to active-grant recipients. OCR accepts bounded PNG/JPEG images only, limits decoded dimensions/output/concurrency, rate-limits extraction, and runs non-root in deployment.

**Reason:** verified status is not case access. Native parsing also requires resource limits before untrusted input reaches Tesseract.

**Alternatives considered:** broadcast identifiers to all verified doctors (rejected: grant violation) · retain direct PDF processing (rejected: unsupported and unsafe without bounded page rasterization) · unlimited parallel OCR (rejected: denial-of-service risk).

**Status:** Accepted as MVP boundary.

---

## 2026-08-04 — Retain React Router 7.18 for SPA despite RSC-only advisory

**Decision:** retain `react-router-dom` 7.18.2 and document the current high-severity audit advisory as non-applicable to this Vite SPA.

**Reason:** GHSA-qwww-vcr4-c8h2 concerns React Router RSC/server-action mode. Family Veda has no RSC runtime, server actions or React Router server deployment. The suggested forced downgrade to 7.11 reintroduces advisories that affect ordinary SPA navigation.

**Alternatives considered:** force downgrade to 7.11 (rejected: worsens directly relevant SPA security) · ignore without documentation (rejected: weak audit trail) · migrate to an unpublished fixed 8.3 release (not available).

**Consequence:** `npm audit` reports two high findings until an upstream fixed release is published; dependency monitoring remains required.

**Status:** Accepted with documented applicability assessment.

## 2026-08-04 — Add iOS as a supported development target

**Decision:** add an iOS 15+ Flutter target with bundle identifier `lk.familyveda.familyveda`, CocoaPods integration, required camera/photo permissions, APNs capability and platform-correct notification subscription.

**Reason:** the available physical development device is an iPhone, while the repository previously contained only Android platform files. Shared Dart application code remains unchanged across both targets.

**Alternatives considered:** install only the Android SDK and use an emulator (rejected as it does not exercise the available physical device) · replace Android with iOS (rejected because the assignment still requires a signed APK tested on a physical Android device) · defer iOS until deployment (rejected because platform-specific notification registration was already incorrectly hardcoded to `ANDROID`).

**Consequences:** iPhone development requires Apple signing and a gitignored Firebase iOS configuration. Android remains supported and still must satisfy the assessed APK/device gate.

**Status:** Accepted with explicit user approval.

---

## 2026-08-04 — Provision production on a separate PostgreSQL 16 project

**Decision:** keep the existing Neon PostgreSQL 18 project unchanged and provision a separate production project on PostgreSQL 16, matching the tested runtime and blueprint.

**Reason:** Neon projects cannot be downgraded in place. Deploying against PostgreSQL 18 would introduce an untested database version into the graded stack, while replacing the existing project would risk unrelated data and configuration.

**Alternatives considered:** use the existing PostgreSQL 18 project (rejected: runtime mismatch) · delete and recreate the existing project (rejected: destructive and unnecessary) · change the project baseline to PostgreSQL 18 (rejected: no design or test evidence supports that change).

**Consequences:** all six committed migrations are applied to the PostgreSQL 16 production database. Render remains the next deployment gate; its required persistent disk needs workspace payment information. Vercel deployment follows only after the API URL and CORS origin are known.

**Status:** Accepted under the user's approved Render + Neon + Vercel deployment plan.

---

## 2026-08-04 — Account-scope mobile member state and make logout truthful

**Decision:** key persisted active-member preferences by authenticated backend user ID and revalidate identity after every asynchronous restore. Persist a non-secret logout-intent marker independently of Keychain using a flushed temporary file, atomic rename, parent-directory `fsync`, and stale-temp recovery in application-support storage. Treat logout as durable only when server revocation or local refresh-token deletion succeeds; if both fail, enter a locked cleanup-required state that survives restart.

**Reason:** an unscoped or late Keychain read can cross account boundaries. Claiming sign-out after both revocation and deletion fail leaves a valid refresh token able to restore silently.

**Alternatives considered:** swallow storage errors and always show signed out (rejected: false security state) · use only an in-memory cleanup lock (rejected: restart could restore the retained refresh token) · remove member persistence entirely (rejected: unnecessary usability regression).

**Consequences:** secure-storage failures never expose the prior account's member selection; 401 events always close in-memory auth. A combined logout failure blocks protected routes, clears member scope and prevents refresh or new login until cleanup succeeds, including after process restart. Mobile uses `path_provider` only to locate app-support storage; tokens remain in Keychain.

**Status:** Accepted under the approved design-correction authority.

---

## 2026-08-04 — Use Render free plan and defer push notifications

**Decision:** deploy the API on Render's free plan without a persistent disk. Store uploaded lab-report files and Data Protection keys in the container's writable `/app` directories. Omit FCM deployment secrets and defer APNs/FCM notification delivery.

**Reason:** the user explicitly cannot fund paid subscriptions. Render persistent disks require paid compute, and Apple push delivery also requires external provider configuration. Neon remains the persistent source of structured clinical data; core authentication, records, OCR, triage and doctor-approval workflows remain demonstrable.

**Alternatives considered:** retain the paid persistent disk (rejected: violates the zero-cost constraint) · disable the entire deployment (rejected: prevents evaluator access to the core workflow) · substitute a hosted LLM or notification provider (rejected: violates ADR-006 or introduces another paid dependency).

**Consequences:** uploaded files and encrypted notification-token keys are ephemeral and may be lost when Render restarts. Production push configuration is intentionally absent and distributed clients do not include Firebase configuration, so token registration is not expected; the subscription endpoint itself remains available. Neon metadata can outlive an ephemeral file and must not be presented as proof that the file remains retrievable or securely erased. The demo must use synthetic uploads that can be repeated, and the report must state this free-tier limitation plainly. Hosted inference uses an unreachable loopback Ollama URL and fails safely; Ollama runs only on the local demo machine as already documented.

**Status:** Accepted with explicit user direction; supersedes the earlier requirement for a Render persistent disk.

---

## Open decisions

| # | Question | Owner | Decide by |
|---|---|---|---|
| 1 | Confirm the S1–S4 component allocation | All | W1 meeting |
| 2 | Ollama model latency confirmation on actual demo hardware | S3 | Before live Ollama verification |

## Decision rule

Record here at the moment of decision, including rejected alternatives — the report's ADR section is graded on the trade-off reasoning, and reconstructing it in Week 8 produces weak ADRs.
