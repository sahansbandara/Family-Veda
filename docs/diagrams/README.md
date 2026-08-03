# Diagrams

Export every diagram as **PNG or SVG** for the report, and keep the editable source alongside it (draw.io `.drawio`, Mermaid `.mmd`, or the tool's native format). A diagram whose source is lost cannot be corrected in Week 8.

## Required for the report

| File | Contents | Owner | Due |
|---|---|---|---|
| `er-diagram.*` | All 20 tables, FKs, key constraints and indexes | S2 | W1 |
| `architecture.*` | The reference architecture — Flutter + React → API → PostgreSQL + agents → notification service | S3 | W1 |
| `agent-workflow.*` | Coordinator → Context → Analysis → Familial Risk → Safety → approval gate → patient | S3 | W1 |
| `triage-state-machine.*` | `SUBMITTED` … `CLOSED`, including `AGENT_FAILED` and `ESCALATED` | S3 | W1 |
| `consent-state-machine.*` | `NOT_SET` / `GRANTED` / `REVOKED` / `PENDING_REAFFIRMATION` | S1 | W1 |
| `doctor-verification.*` | `PENDING` → `VERIFIED` / `INFO_REQUESTED` / `REJECTED` / `SUSPENDED` | S4 | W1 |
| `two-stage-model.*` | Stage 1 extraction (per member) → `hereditary_flags` → Stage 2 familial analysis | S4 | W1 |
| `cross-platform-workflow.*` | The demo sequence: Flutter → agents → React → Flutter, with owner tags | S3 | W1 |
| `wireframes-react.*` | Key React screens | All | W1 |
| `wireframes-flutter.*` | Key Flutter screens | All | W1 |

## Rules

1. **Tag every component with its owner** (`[S1]`–`[S4]`). The examiner reads these diagrams while judging individual contribution.
2. Keep diagrams consistent with the ASCII versions in the blueprint and in `docs/ARCHITECTURE.md`, `docs/DATABASE.md`, `docs/AGENTS_DESIGN.md`. If a diagram and a document disagree, the blueprint wins and both get fixed.
3. Regenerate any diagram whose subject changes. A stale ER diagram in the report is worse than none.
4. No real patient data in any diagram, wireframe or screenshot.
