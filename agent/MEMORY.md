# Agent Memory — Family Veda

## Do not store

Never store in this repository, in any Markdown file, or in any commit:

- passwords, password hashes, JWT secrets, signing keys
- API keys or tokens (FCM server key, Twilio SID/token, database URLs with credentials)
- private keys or certificates
- bank or card details
- **any real patient data, real NIC numbers, or real SLMC registration numbers**
- production connection strings

All secrets live in environment variables. `.env` is gitignored; `.env.example` carries names only, never values.

## Project knowledge

### Identity
- Product: **Family Veda** — *vedā* (වෙදා), Sinhala for the traditional healer/doctor. Pronounced *VAY-daa*. Not *vaeda* (වැඩ) = "work".
- Course: SE3090 Software Engineering Frameworks, SLIIT. Group SE_016, lab group Y3.S1.SE.WE.01.01. Submission name `SE3090_SE016`.
- 25% of the module. 100 marks: 30 group + **70 individual**. That ratio drives every structural decision.

### The one-sentence thesis
The AI does context; the doctor does medicine. Family Veda closes the **context gap**, it does not diagnose.

### Six architectural invariants (never violate)
1. React and Flutter consume **the same** ASP.NET Core API. No second backend.
2. React and Flutter share the same database, identity, permissions and business rules.
3. The agentic subsystem is **never called directly by a client** — only by ASP.NET Core.
4. The third-party notification service is **never called directly by a client**.
5. **No agent holds database credentials.** Agents get data only through allow-listed backend tools.
6. **No patient-visible output exists that has not passed the doctor approval gate.**

### The two-stage data model (the strongest design idea)
- Stage 1 — Extraction Agent, scope ONE member: raw records → structured `hereditary_flags` rows. Raw content never leaves this stage.
- Stage 2 — Familial Risk Agent, scope FAMILY but **flags table only**: consented flags + relationship graph → screening indication.
- Memory hook: **FLAGS CROSS, FILES DON'T.**
- Justification: a hereditary assessment needs ~20 tokens of structured fact per relative, not ~8,000 tokens of raw history. Passing raw records would increase privacy exposure, enlarge the hallucination surface and add no analytical capability.

### Access model
- **Access by grant, not by role.** Authorisation queries `case_access_grants` (unexpired, not revoked), never `user.role == "DOCTOR"`.
- Grants are time-bound (48 h), case-scoped, individually audited.
- `PENDING` doctors get 403 on every clinical endpoint.

### Consent
- Categories: `HEREDITARY_FLAGS`, `VITALS_SUMMARY`, `CONDITIONS`. Granted per member, per category.
- States: `NOT_SET` (default, nothing shared) → `GRANTED` → `REVOKED` → re-`GRANTED`.
- **At 18, guardian-granted consents move to `PENDING_REAFFIRMATION` and are treated as NOT granted** until the member personally confirms. Strong viva point.

### Genetics framing — the highest-risk viva topic
- Never claim inheritance. Claim a **screening indication**.
- Autosomal recessive with one confirmed carrier parent and the other confirmed not a carrier = 0% affected, 50% carrier. When the other parent's status is unknown, report `unknownParties` and make no numeric affected-risk claim. Both confirmed carriers = 25% affected, 50% carrier.
- Always report `unknownParties` when a parent's status is unknown.
- `relationships.is_biological` is mandatory — adoptive and step relationships are excluded from all hereditary reasoning.
- The inheritance table is hardcoded, cited and deterministic. **Never LLM-generated.**

### Emergency behaviour
Deterministic red-flag check runs *before* any LLM output could surface. On a hit: emergency referral, patient or minor guardian notification, active-grant doctor notification, and **zero AI-generated guidance**. Unassigned doctors use a de-identified claim pool; identifiers are never broadcast.

### Repository structure decision
One application, four authors. A **folder-per-student layout was considered and rejected** — it produces four `Program.cs`, four DbContexts, no shared identity, and makes the cross-platform workflow physically impossible, which lands directly in the rubric's 2-mark "disconnected prototype" band. Proof of individual work is `git log --author`, not folder names.

### The seven shared files (the only real conflict surface)
`backend/src/Api/Program.cs` [S1] · `AppDbContext.cs` [S1] · `Application/Agents/IAgent.cs` [S3] · `web/src/store/index.ts` [S3] · `web/src/routes/AppRouter.tsx` [S1] · `mobile/lib/router/app_router.dart` [S1] · `package.json` / `pubspec.yaml` [S1].
Convention: add lines inside your own labelled block, never reorder or reformat existing lines.

### Migration protocol (the one thing that genuinely breaks the repo)
Announce "taking migration lock, ~20 min" in the group chat → `git pull origin develop` → `dotnet ef migrations add <Name>` → `dotnet ef database update` → commit and push immediately → announce "lock released". Never two migrations in flight. Never edit a migration someone already pushed — add a new one. Naming: `20260814_S2_AddLabReportsAndValues`.

### Memory hooks (drill these before the viva)
| Hook | Meaning |
|---|---|
| **P-A-V-A** | Prepare · Analyse · Validate · Approve. AI does the first three, the doctor does the fourth |
| **FLAGS CROSS, FILES DON'T** | The two-stage data model |
| **P-V-G** | Pending · Verified · Grant. Access comes from the grant, not the role |
| **GATE OR GONE** | If it did not pass the approval gate, the patient never sees it |
| **2-4-6-8** | W2 CI green · W4 CRUD end-to-end · W6 agents complete · W8 deployed |
| **S-R-S** | Signal not diagnosis · Recessive needs both · Share flags not files |

## Mistakes to avoid

| Mistake | Why it costs marks |
|---|---|
| Splitting work by layer (A=backend, B=frontend) | 70 marks are individual and every band asks the student to explain/test/modify/debug across all five technologies |
| Folder-per-student repository | Produces disconnected prototypes by construction → rubric's lowest agentic band |
| Enforcing the tool allow-list in the prompt | Prompt-level "rules" are advisory. Enforcement must be in the dispatch layer, or the viva demo fails |
| Letting the LLM make clinical safety decisions | Safety must be deterministic rule tables — reproducibility and auditability are the whole argument |
| Saying "the son inherits the father's thalassaemia" | Factually wrong for autosomal recessive and the examiner will press on it |
| Claiming an SLMC API integration | No public API exists. The honest answer is: manual admin verification |
| Adding meal plans or lifestyle prescriptions | Clinical nutrition therapy. Unsafe, zero rubric marks, indefensible in a viva |
| Showing any AI output during the emergency path | Directly contradicts the safety architecture the report claims |
| Two members generating EF migrations at once | Conflicting model snapshots — the one failure that genuinely breaks the repository |
| Committing on another member's behalf | Destroys the git evidence their individual marks depend on |
| Leaving the report to Week 8 | 15 minutes every Sunday from W1 instead |
| Adding features after the W5 freeze | Deferred features are worth zero marks; the assessed core is worth 100 |

## Patterns that work

- **Labelled DI blocks in `Program.cs`** — different members edit different lines, so Git merges cleanly.
- **DTOs in, DTOs out, always** — entities are never exposed by a controller.
- **`async Task<ActionResult<T>>` on every action** — explicitly assessed.
- **RFC 7807 Problem Details** for every error response, via one middleware.
- **Loading / empty / error / success state on every data view** — assessed on both platforms.
- **Every list view gets search, filter, sort and pagination** — assessed on both platforms.
- **Write the 8 priority test cases first** — they map one-to-one onto viva questions.
- **Small, frequent PRs.** Merge pain scales super-linearly with PR size.

## Dependencies and versions

| Component | Pin | Note |
|---|---|---|
| .NET | 8 (LTS) | C# 12 |
| EF Core + Npgsql | 8 | Migrations serialised under the lock protocol |
| PostgreSQL | 16 | `gen_random_uuid()` needs `pgcrypto` or PG13+ built-in |
| React | 18 | Vite, React Router, Redux Toolkit |
| Flutter | 3.x | go_router, Riverpod, flutter_secure_storage, camera/image_picker |
| Ollama | latest | `llama3.1:8b` — confirm latency on the demo machine in W5 |
| Tesseract | — | OCR; Google ML Kit on-device is the mobile alternative |
| Testing | xUnit + Moq · Vitest + RTL · flutter_test · Testcontainers | — |

## Environment notes

- Ollama runs **locally** and must be running for any agent workflow. It is not deployed. Hardware requirements go in the deployment section of the report.
- Free-tier hosting sleeps. Verify the deployed URLs daily during W9 (risk R6).
- OCR accuracy on real Sri Lankan lab report layouts is expected to be poor (risk R3). OCR is **assistive, never authoritative** — always offer manual correction.
- Physical Android device required for the W7 device-feature check and the W8 APK test.

## Session handoff notes
- **2026-08-04 production live** — Render Blueprint `family-veda-production` deployed service `srv-d9oqfsm7bikc73fs7h20` from `main` commit `bb85582`; API `https://family-veda-api.onrender.com` is live on the free plan. After initial port-detection routing settled, 20/20 health probes returned 200 and exact Vercel-origin CORS preflight returned 204. Neon migrations are current. Rotated the synthetic demo password after browser diagnostic exposure; all five role logins passed with the replacement stored only in macOS Keychain service `FamilyVedaDemoPassword`. Vercel `https://family-veda-web.vercel.app` doctor login reached `/dashboard`. A production-configured iOS build was signed, installed and launched on physical device `ImSahanS`; installed bundle `lk.familyveda.familyveda` version 1.0.0 contains the Render API URL. Apple team/no-push settings remain local and uncommitted. Push is deferred; Ollama remains local-demo-only; Render uploads/keys remain ephemeral.
- **2026-08-04 zero-cost deployment correction** — Render billing validation now passes, but the user cannot fund paid subscriptions. Blueprint changed to explicit free plan with no persistent disk; lab uploads and Data Protection keys use writable ephemeral `/app` paths. FCM/APNs deployment is deferred and FCM secret prompts are omitted. Neon remains persistent; Ollama remains local-only. Physical iPhone and Apple Development signing are now detected. Rotated the Neon role password after a diagnostic log disclosure, converted Neon URI syntax to Npgsql key/value syntax, and verified the container against Neon. Seeded the five synthetic evaluator roles locally; all five logins passed. The shared demo password is stored only in macOS Keychain service `FamilyVedaDemoPassword`.
- **2026-08-04 mobile auth hardening** — iOS Keychain `-34018` now fails closed without startup hangs. Active-member preferences are account-scoped by backend user ID; delayed reads recheck current identity before applying. Partial token writes clear in-memory bearer state, 401 expiration always emits even when Keychain deletion fails, and logout reports success only when either server revocation or local refresh-token deletion succeeds. A non-secret app-support marker uses flushed writes, atomic rename, parent-directory `fsync`, and interrupted-temp recovery so combined-failure cleanup locking survives restart; protected routes close, member scope clears and refresh is blocked until cleanup succeeds. Flutter analyzer is clean; 46 tests pass; touched auth/storage service coverage is 93%+.
- **2026-08-04 production provisioning (historical; later superseded)** — GitHub CI run `30866408901` passed backend, React, Flutter analysis/tests, debug APK and quality gate after retrying one transient Maven Central HTTP 429. Provisioned a separate Neon PostgreSQL 16 project in the existing organization and applied all six committed EF Core migrations; an independent migration listing confirmed the hosted schema state. Render was initially blocked by missing payment information and the planned persistent disk; the later zero-cost deployment decision supersedes that disk requirement. No credentials or connection strings were committed.
- **2026-08-04 iOS enablement** — Added the missing Flutter iOS platform with bundle ID `lk.familyveda.familyveda`, iOS 15 minimum, camera/photo permission strings, CocoaPods integration, push capability/entitlements and Firebase Messaging UIScene delegate setup. Device subscription now sends `IOS` on iPhone and `ANDROID` on Android; Flutter analyze and 27 tests pass. CocoaPods 1.17 and the Xcode iOS 26.5 simulator runtime are installed; clean-path native simulator build produces `Runner.app`. The repository's current File Provider-managed `Documents` path injects extended attributes that break CodeSign, so Xcode/iPhone work should use a non-cloud clone. Physical run still needs an attached iPhone, Apple signing team and gitignored Firebase configuration. Android remains required for the assessed signed APK/device deliverable.
- **2026-08-04 final hardening** — Added complete web family/doctor onboarding, doctor status gating, emergency doctor referral and broadcast, failed-safe/SLA patient referrals, >100-case recovery, manual OCR confirmation with confirmed-only agent reads, conservative deterministic rule-table interfaces, approved-only familial screening guidance, relationships/consent UI, records/vitals/lab review, mobile record/vital entry, explicit clinical endpoint policies and expanded tests. Current local gates: 42 backend unit + 4 PostgreSQL integration + 17 React + 24 Flutter tests pass; builds/analyzers clean; EF model clean; Docker runtime healthy with PostgreSQL and Tesseract. Live provider authentication, Ollama, Firebase, Android SDK/device, citations and human coursework remain external.
- **2026-08-04 review closure** — De-identified and audited pre-grant case pool; grant-only doctor push; fail-closed emergency synonyms/severity/young-child fever including notes; consent audits on every automatic/manual transition; confirmed-only flags and immutable reviewed extraction; bounded non-root image OCR; email-bound one-time adult invitations; vulnerable NuGet graph cleared. Final local gates: 56 backend unit + 5 PostgreSQL integration + 17 React + 25 Flutter tests pass; builds/analyzers/formatting clean; EF model clean; Docker production runtime healthy as non-root with PostgreSQL migration and Tesseract.

- **2026-08-04 full build** — Implemented .NET 8 API, 20-table PostgreSQL schema, JWT/refresh flow, family/consent/records/triage/doctor workflows, tool-dispatched Extraction/Context/Analysis/Familial Risk agents, deterministic emergency/safety gate, approval-only patient guidance, Tesseract upload/OCR, FCM HTTP v1 subscriptions, React clinical/admin workspace, Flutter patient app with camera upload, synthetic seed, Render/Neon/Vercel configs. Local gates: backend build clean; 19 unit + 2 PostgreSQL integration tests pass; web lint + 11 tests + build pass; Flutter analysis + 22 tests pass. Android SDK, live Ollama, Firebase config, and provider credentials remain external verification blockers. Migration lock released after pending-model check and PostgreSQL application test.

- **2026-08-04** — Repository converted from the universal agent template into the Family Veda project workspace. Template-only scaffolding, off-stack language rules and unrelated skills removed. `agent/`, `docs/`, `rules/`, `skills/`, `workflows/` rewritten against the blueprint. Mode switched `TEMPLATE_MODE → PROJECT_MODE`. No application code written yet; implementation starts at the W2 skeleton.
