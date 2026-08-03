# web — React application

**ONE** application. The **clinical and administrative** surface — deliberately not a patient app. Scaffolded in W2.

React 18 · Vite · React Router · Redux Toolkit (ADR-004) · Vitest + React Testing Library

## Target structure

```
web/
├── src/
│   ├── pages/
│   │   ├── auth/                             [S1]
│   │   ├── family/                           [S1]
│   │   ├── consents/                         [S1]
│   │   ├── records/                          [S2]
│   │   ├── dashboard/                        [S3]
│   │   ├── traces/                           [S3]
│   │   ├── doctor/                           [S4]
│   │   ├── admin/                            [S4]
│   │   └── audit/                            [S4]
│   ├── components/
│   │   ├── shared/                           ⚠ review required
│   │   │   DataTable · StatusBadge · EmptyState
│   │   │   ConfirmDialog · ErrorBoundary
│   │   └── {family,records,triage,clinical}/  by owner
│   ├── store/
│   │   ├── index.ts                          ⚠ SHARED
│   │   └── slices/{auth,records,cases,doctor}Slice.ts
│   ├── services/api/                         one client file per owner
│   ├── routes/AppRouter.tsx                  ⚠ SHARED
│   └── hooks/
├── tests/
└── package.json                              ⚠ SHARED
```

## Screen inventory

| # | Screen | Role | Owner | Key features |
|---|---|---|---|---|
| 1 | Login / Register | All | S1 | JWT, role-based redirect |
| 2 | Doctor Case Queue | Doctor | S4 | Table, filter by priority/status, sort, pagination, SLA countdown |
| 3 | Case Detail | Doctor | S4 | Member timeline, deviation flags, familial signals, draft advisory |
| 4 | Agent Trace Viewer | Doctor | S3 | Step-by-step trace, tools requested/denied, confidence, latency |
| 5 | Approval Panel | Doctor | S4 | Approve / Revise / Request info / Reject / Escalate |
| 6 | Doctor Profile | Doctor | S4 | Verification status, credentials |
| 7 | Doctor Verification Queue | Admin | S4 | Pending list, certificate viewer, approve/reject |
| 8 | Family Management | Family Head | S1 | Members CRUD, relationships |
| 9 | Consent Management | Head / Member | S1 | Per-category toggles, reaffirmation prompts |
| 10 | Record Browser | Family | S2 | Search, filter, sort, paginate |
| 11 | Lab Report Viewer | Family | S2 | Parsed values, reference ranges, trend chart |
| 12 | Family Health Dashboard | Family Head | S3 | Vitals trends, case history, flag summary |
| 13 | Audit Log Viewer | Head / Admin | S4 | Who accessed what, when, under which consent |
| 14 | System Reports | Admin | S3 | Usage, agent performance, SLA compliance |

## Required technical features

- Functional components and Hooks only
- React Router with **protected routes** and role guards
- Reusable component library: `<DataTable>` `<StatusBadge>` `<TimelineChart>` `<TraceStep>` `<ConfirmDialog>` `<EmptyState>` `<ErrorBoundary>`
- Redux Toolkit for auth/session and case queue state (ADR-004)
- **Loading, empty, success and error states on every data view**
- Client-side validation mirroring server rules
- Responsive layout, accessible markup (labels, focus order, contrast)
- **Search, filter, sort and pagination on every list view**

## Component tree

```
<App>
 ├── <AuthProvider>
 ├── <Router>
 │    ├── /login                  → <LoginPage>                [S1]
 │    ├── /doctor        [guard: DOCTOR + VERIFIED]
 │    │    ├── /queue             → <CaseQueue>                [S4]
 │    │    └── /cases/:id         → <CaseDetail>               [S4]
 │    │                             ├── <MemberTimeline>       [S2]
 │    │                             ├── <DeviationPanel>       [S3]
 │    │                             ├── <FamilialRiskPanel>    [S4]
 │    │                             ├── <AgentTraceViewer>     [S3]
 │    │                             └── <ApprovalPanel>        [S4]
 │    ├── /admin         [guard: ADMIN]
 │    │    ├── /doctors           → <VerificationQueue>        [S4]
 │    │    └── /reports           → <SystemReports>            [S3]
 │    └── /family        [guard: FAMILY_HEAD | MEMBER]
 │         ├── /members           → <MemberManagement>         [S1]
 │         ├── /consents          → <ConsentManagement>        [S1]
 │         ├── /records           → <RecordBrowser>            [S2]
 │         ├── /dashboard         → <FamilyDashboard>          [S3]
 │         └── /audit             → <AuditLogViewer>           [S4]
 └── <ErrorBoundary>
```

## Rules

- Adding a slice: register it in `store/index.ts` inside your own labelled block. Do not touch others'.
- Adding a route: add your route block in `AppRouter.tsx`. **Do not restructure the guards.**
- Adding a dependency: announce in the group chat before touching `package.json`.
- New shared component: PR review by at least one other member.
- `VITE_*` variables are inlined into the client bundle. **Never put a secret in one.**

## Commands

```bash
npm ci
```

```bash
npm run dev
```

```bash
npm test
```

```bash
npm run build
```

## References

`design.md` · `docs/API_CONTRACT.md` · `rules/react/` · `rules/typescript/` · `rules/frontend.md`
