# Database Design — Family Veda

PostgreSQL 16 · EF Core 8 + Npgsql · 20 tables · source: implemented EF migrations.

## Entity relationship overview

```
                        ┌──────────┐
                        │  users   │
                        └────┬─────┘
             ┌───────────────┼───────────────┐
             ▼               ▼               ▼
       ┌──────────┐   ┌───────────┐   ┌───────────┐
       │ families │   │  doctors  │   │ ADMIN is  │
       └────┬─────┘   └─────┬─────┘   │ user_type │
                                           └───────────┘
            │ 1:N            │
            ▼                │
      ┌───────────┐          │
      │  members  │          │
      └─────┬─────┘          │
            │                │
   ┌────────┼────────┬───────┼──────────┬─────────────┐
   ▼        ▼        ▼       │          ▼             ▼
┌──────┐ ┌──────┐ ┌──────┐   │   ┌───────────┐ ┌──────────────┐
│health│ │ lab  │ │vitals│   │   │relation-  │ │  consents    │
│_recs │ │_repts│ │      │   │   │  ships    │ │              │
└──┬───┘ └──┬───┘ └──────┘   │   └───────────┘ └──────────────┘
   │        │ 1:N            │
   │        ▼                │
   │   ┌──────────┐          │
   │   │lab_values│          │
   │   └────┬─────┘          │
   └────┬───┘                │
        ▼                    │
┌────────────────┐           │
│hereditary_flags│           │
└────────────────┘           │
                             │
      ┌───────────┐          │
      │ episodes  │          │
      └─────┬─────┘          │
            ▼                │
   ┌────────────────┐        │
   │  triage_cases  │◄───────┘  assignment + grant
   └───┬────────┬───┘
       │        │
       ▼        ▼
┌────────────┐ ┌──────────────┐   ┌────────────────────┐
│agent_traces│ │  approvals   │   │ case_access_grants │
└────────────┘ └──────────────┘   └────────────────────┘

           ┌─────────────┐
           │  audit_log  │  ← written from everywhere
           └─────────────┘
```

`ADMIN` is a `users.user_type`, not a separate table.

## Ownership

| Owner | Tables |
|---|---|
| **S1** | `users` `families` `members` `relationships` `consents` |
| **S2** | `health_records` `lab_reports` `lab_values` `vitals` `hereditary_flags` |
| **S3** | `episodes` `triage_cases` `agent_traces` `notification_subscriptions` |
| **S4** | `doctors` `doctor_verification_log` `family_doctor_assignments` `case_access_grants` `approvals` `audit_log` |

---

## S1 — Identity and family

### `users`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK, default `gen_random_uuid()` |
| email | varchar(255) | UNIQUE, NOT NULL |
| password_hash | varchar(255) | NOT NULL |
| full_name | varchar(200) | NOT NULL |
| phone | varchar(20) | |
| user_type | enum | NOT NULL — `FAMILY_USER`, `DOCTOR`, `ADMIN` |
| is_active | boolean | NOT NULL, default true |
| created_at / updated_at | timestamptz | NOT NULL |

Indexes: `idx_users_email` (unique) · `idx_users_type`

### `families`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| family_name | varchar(150) | NOT NULL |
| head_user_id | uuid | FK → users(id), NOT NULL |
| primary_doctor_id | uuid | FK → doctors(id), NULLABLE |
| created_at / updated_at | timestamptz | NOT NULL |

### `members`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| family_id | uuid | FK → families(id) ON DELETE CASCADE, NOT NULL |
| user_id | uuid | FK → users(id), NULLABLE — **minors have no login** |
| full_name | varchar(200) | NOT NULL |
| date_of_birth | date | NOT NULL, CHECK ≤ CURRENT_DATE |
| sex | enum | `MALE`, `FEMALE`, `OTHER` |
| blood_group | varchar(5) | |
| guardian_member_id | uuid | FK → members(id), NULLABLE |
| created_at / updated_at | timestamptz | NOT NULL |

Indexes: `idx_members_family` · `idx_members_dob`

### `relationships`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| family_id | uuid | FK → families(id) |
| member_id | uuid | FK → members(id) |
| related_member_id | uuid | FK → members(id) |
| relation_type | enum | `PARENT`, `CHILD`, `SIBLING`, `SPOUSE` |
| **is_biological** | boolean | NOT NULL — **critical for genetic reasoning** |

Constraints: `UNIQUE(member_id, related_member_id)` · `CHECK (member_id <> related_member_id)`

> `is_biological = false` (adoptive, step) **must** be excluded from all hereditary reasoning. This is a viva talking point and a required test case.

### `consents`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id), NOT NULL |
| data_category | enum | `HEREDITARY_FLAGS`, `VITALS_SUMMARY`, `CONDITIONS` |
| status | enum | `NOT_SET`, `GRANTED`, `REVOKED`, `PENDING_REAFFIRMATION` |
| granted_by_user_id | uuid | FK → users(id) |
| granted_at / revoked_at / expires_at | timestamptz | NULLABLE |

Constraint: `UNIQUE(member_id, data_category)`

---

## S2 — Health records

### `health_records`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id), NOT NULL |
| record_type | enum | `CONDITION`, `ALLERGY`, `MEDICATION`, `SURGERY`, `IMMUNISATION` |
| title | varchar(200) | NOT NULL |
| description | text | |
| onset_date | date | |
| is_chronic | boolean | default false |
| recorded_by_user_id | uuid | FK → users(id) |
| created_at / updated_at | timestamptz | NOT NULL |

Indexes: `idx_records_member_type` · `idx_records_member_created`

### `lab_reports`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id), NOT NULL |
| report_type | varchar(100) | `FBC`, `FBS`, `HbA1c`, `LIPID`, `HB_ELECTROPHORESIS` |
| report_date | date | NOT NULL |
| file_url | varchar(500) | |
| file_type | enum | `IMAGE`, `PDF` |
| ocr_status | enum | `PENDING`, `PROCESSING`, `COMPLETED`, `FAILED` |
| ocr_raw_text | text | |
| uploaded_by_user_id | uuid | FK → users(id) |
| created_at | timestamptz | NOT NULL |

> `ocr_raw_text` is **untrusted input**. It is never passed to an agent as instructions and is never rendered unescaped.

### `lab_values`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| lab_report_id | uuid | FK → lab_reports(id) ON DELETE CASCADE |
| analyte_code | varchar(50) | `HB`, `WBC`, `HBA2`, `MCV`, `GLUCOSE_F` |
| value | numeric(10,3) | NOT NULL |
| unit | varchar(20) | NOT NULL |
| reference_low / reference_high | numeric(10,3) | |
| is_abnormal | boolean | |

Index: `idx_labvalues_analyte` — supports trend queries

### `vitals`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id) |
| recorded_at | timestamptz | NOT NULL |
| height_cm / weight_kg | numeric(6,2) | |
| bmi | numeric(5,2) | computed |
| temperature_c | numeric(4,1) | |
| systolic_bp / diastolic_bp | integer | |
| pulse_bpm | integer | |
| blood_sugar_mgdl | numeric(6,2) | |
| source | enum | `SELF_REPORTED`, `CLINIC`, `LAB` |

Index: `idx_vitals_member_time` — **the baseline query index**

### `hereditary_flags` ⭐ two-stage bridge table

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id), NOT NULL |
| condition_code | varchar(50) | NOT NULL — e.g. `BETA_THAL_CARRIER` |
| condition_name | varchar(200) | NOT NULL |
| inheritance_pattern | enum | `AUTOSOMAL_RECESSIVE`, `AUTOSOMAL_DOMINANT`, `X_LINKED`, `POLYGENIC` |
| status | enum | `CONFIRMED`, `SUSPECTED`, `RULED_OUT` |
| lab_report_id | uuid | FK → lab_reports(id), NULLABLE |
| health_record_id | uuid | FK → health_records(id), NULLABLE |
| confidence | numeric(3,2) | 0.00–1.00 |
| extracted_by | varchar(50) | `EXTRACTION_AGENT` or `MANUAL` |
| verified_by_doctor_id | uuid | FK → doctors(id), NULLABLE |
| created_at | timestamptz | NOT NULL |

Constraints: `UNIQUE(member_id, condition_code)` · exactly one of `lab_report_id` / `health_record_id` is present. Indexes: `idx_flags_member` · `idx_flags_condition`

> **This is the only clinical data permitted to cross member boundaries**, and only when consented. Raw records never cross. *Flags cross, files don't.*

---

## S3 — Triage and agents

### `episodes`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| member_id | uuid | FK → members(id), NOT NULL |
| submitted_by_user_id | uuid | FK → users(id) |
| chief_complaint | varchar(300) | NOT NULL |
| symptoms | jsonb | array of symptom codes |
| duration_days | integer | |
| severity_self | integer | CHECK 1–10 |
| notes | text | |
| created_at | timestamptz | NOT NULL |

### `triage_cases`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| episode_id | uuid | FK → episodes(id), NOT NULL |
| member_id | uuid | FK → members(id), NOT NULL |
| status | enum | see the state machine below |
| priority | enum | `ROUTINE`, `URGENT`, `EMERGENCY` |
| assigned_doctor_id | uuid | FK → doctors(id), NULLABLE |
| assigned_at | timestamptz | |
| sla_expires_at | timestamptz | `assigned_at + 6 hours` |
| context_output | jsonb | Agent 1 |
| analysis_output | jsonb | Agent 2 |
| familial_risk_output | jsonb | Agent 3 |
| validation_output | jsonb | Agent 4 |
| draft_advisory | text | **never patient-visible unapproved** |
| overall_confidence | numeric(3,2) | |
| created_at / updated_at | timestamptz | NOT NULL |

Indexes: `idx_cases_status_priority` · `idx_cases_doctor` · `idx_cases_member`

### `agent_traces`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| triage_case_id | uuid | FK → triage_cases(id) ON DELETE CASCADE |
| step_number | integer | NOT NULL |
| agent_name / agent_version | varchar | NOT NULL |
| input_summary | jsonb | |
| input_hash | varchar(64) | SHA-256 |
| tools_requested / tools_allowed / tools_denied | jsonb | arrays — enforcement evidence and violations are visible here |
| output_summary | jsonb | |
| output_schema_valid | boolean | |
| confidence | numeric(3,2) | |
| latency_ms / token_count | integer | |
| model_name | varchar(100) | |
| status | enum | `SUCCESS`, `FAILED`, `DENIED`, `TIMEOUT` |
| error_message | text | |
| created_at | timestamptz | NOT NULL |

Constraint: `UNIQUE(triage_case_id, step_number)`

### `notification_subscriptions`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| user_id | uuid | FK → users(id) ON DELETE CASCADE, NOT NULL |
| token_hash | varchar(64) | UNIQUE SHA-256 fingerprint, NOT NULL |
| protected_token | varchar(4096) | ASP.NET Data Protection ciphertext, NOT NULL |
| platform | varchar(24) | `ANDROID`, `IOS`, or `WEB` |
| is_active | boolean | NOT NULL |
| last_seen_at | timestamptz | NOT NULL |
| created_at / updated_at | timestamptz | NOT NULL |

The FCM token is decrypted only inside the backend notification client. It is never returned by an API, logged, or stored in Markdown.

---

## S4 — Doctor, approval and audit

### `doctors`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| user_id | uuid | FK → users(id), UNIQUE, NOT NULL |
| slmc_reg_no | varchar(30) | UNIQUE, NOT NULL |
| specialty / qualification | varchar | |
| certificate_url | varchar(500) | |
| verification_status | enum | `PENDING`, `VERIFIED`, `INFO_REQUESTED`, `REJECTED`, `SUSPENDED` |
| verified_by_user_id | uuid | FK → users(id), NULLABLE |
| verified_at | timestamptz | NULLABLE |
| created_at / updated_at | timestamptz | NOT NULL |

### `doctor_verification_log`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| doctor_id | uuid | FK → doctors(id) |
| action | enum | `SUBMITTED`, `APPROVED`, `INFO_REQUESTED`, `REJECTED`, `SUSPENDED`, `REINSTATED` |
| actor_user_id | uuid | FK → users(id) |
| reason | text | |
| created_at | timestamptz | NOT NULL |

### `family_doctor_assignments`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| family_id | uuid | FK → families(id) |
| doctor_id | uuid | FK → doctors(id) |
| is_primary | boolean | NOT NULL |
| assigned_at / revoked_at | timestamptz | |

### `case_access_grants` ⭐ the security story table

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| triage_case_id | uuid | FK → triage_cases(id) |
| doctor_id | uuid | FK → doctors(id) |
| granted_at | timestamptz | NOT NULL |
| expires_at | timestamptz | NOT NULL |
| revoked_at | timestamptz | NULLABLE |
| granted_reason | enum | `PRIMARY_DOCTOR`, `POOL_CLAIM`, `ESCALATION` |

> Authorisation reads **this table**, not the user's role.

```sql
-- ❌ WRONG
if (user.role == "DOCTOR") allow;

-- ✔ RIGHT
SELECT * FROM case_access_grants
 WHERE triage_case_id = @caseId
   AND doctor_id      = @doctorId
   AND revoked_at IS NULL
   AND expires_at > now();
-- no row → 403
```

### `approvals`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| triage_case_id | uuid | FK → triage_cases(id) |
| doctor_id | uuid | FK → doctors(id) |
| decision | enum | `APPROVED`, `APPROVED_REVISED`, `INFO_REQUESTED`, `REJECTED`, `ESCALATED` |
| doctor_notes | text | |
| final_advisory | text | **what the patient actually receives** |
| decided_at | timestamptz | NOT NULL |

### `audit_log`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| actor_user_id | uuid | FK → users(id), NULLABLE (null = system/agent) |
| actor_type | enum | `USER`, `DOCTOR`, `ADMIN`, `AGENT`, `SYSTEM` |
| action | varchar(100) | e.g. `CROSS_PROFILE_FLAG_READ` |
| resource_type / resource_id | varchar / uuid | |
| subject_member_id | uuid | FK → members(id), NULLABLE |
| consent_ref_id | uuid | FK → consents(id), NULLABLE |
| ip_address | inet | |
| metadata | jsonb | |
| created_at | timestamptz | NOT NULL |

Indexes: `idx_audit_subject_time` · `idx_audit_actor_time`

---

## State machines

### Triage case

```
        SUBMITTED
            │
            ▼
        PLANNING ────────────────► AGENT_FAILED
            │                          │
            ▼                          ▼
      CONTEXT_READY              safe-failure notice
            │                    "consult doctor directly"
            ▼
        ANALYSED
            │
            ▼
      RISK_ASSESSED
            │
            ▼
        VALIDATED ──── red flag ──► ESCALATED
            │                          │
            ▼                          ▼
  PENDING_DOCTOR_REVIEW ◄──────────────┘
            │
   ┌────────┼────────┬──────────────┬────────────┐
   ▼        ▼        ▼              ▼            ▼
APPROVED  APPROVED  AWAITING_INFO  REJECTED   ESCALATED
          _REVISED     │
            │          │ member responds
            ▼          ▼
        DELIVERED   (back to PENDING_DOCTOR_REVIEW)
            │
            ▼
         CLOSED
```

### Consent

```
NOT_SET ──grant──► GRANTED ──revoke──► REVOKED ──re-grant──► GRANTED
                      │
                      │ member turns 18
                      ▼
            PENDING_REAFFIRMATION   (treated as NOT granted)
```

**Business rule.** When a member reaches 18, all guardian-granted consents move to `PENDING_REAFFIRMATION` and are treated as **not granted** until the member personally confirms.

### Doctor verification

```
PENDING ──approve──► VERIFIED ──suspend──► SUSPENDED ──reinstate──► VERIFIED
   │  │
   │  └──request info──► INFO_REQUESTED ──resubmit──► PENDING
   └──reject──► REJECTED
```

Every transition writes a `doctor_verification_log` row with actor and reason.

---

## Migration protocol ⚠

Two members generating EF Core migrations simultaneously produces conflicting model snapshots — the one failure that genuinely breaks the repository.

```
1. Announce in the group chat: "taking migration lock, ~20 min"
2. git pull origin develop
3. dotnet ef migrations add <Name>
4. dotnet ef database update        # verify
5. Commit and push immediately
6. Announce: "migration lock released"
7. Everyone else: git pull before working
```

Never two migrations in flight. Never edit a migration another member has already pushed — add a new one.

Naming: `20260814_S2_AddLabReportsAndValues` — date, owner, purpose.

## Seed data policy

**Synthetic data only. No real patient records under any circumstances.**

One demonstration family of four with clinically plausible, internally consistent history:

| Member | Profile | Demonstrates |
|---|---|---|
| Father, 46 | Confirmed β-thalassaemia carrier (elevated HbA2), type 2 diabetes | Hereditary flag source |
| Mother, 42 | Carrier status **unknown** | `unknownParties` output |
| Son, 12 | Recurrent fever, mild anaemia on FBC | The live demo triage case |
| Daughter, 19 | Recently turned 18 | `PENDING_REAFFIRMATION` consent rule |

Plus 2 doctors (1 `VERIFIED`, 1 `PENDING`) and 1 clinic admin — demonstrates the verification workflow live.

Seed implementation: `backend/src/Infrastructure/Persistence/Seed/SyntheticFamilySeed.cs` [S2].
