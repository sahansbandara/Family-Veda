# Future Work — Deliberate Deferrals

Source: blueprint §18. Everything raised after the **W5 scope freeze** lands here and receives zero lines of code.

> Write these into the report exactly in this style. "Deliberately deferred, with the extension point identified" reads as engineering maturity. "We ran out of time" reads as a failure.

## 18.1 Appointment scheduling

Deferred. Booking is orthogonal to the assessed agentic workflow and would have consumed approximately three weeks across availability modelling, slot management, conflict handling and notification flows. The architecture reserves the extension point: `doctor_availability` and `appointments` tables with `appointments.triage_case_id` as a nullable foreign key, so a doctor approving a case can offer a slot **without a schema change**.

```
Reserved schema (not implemented):

doctor_availability
  id, doctor_id FK, day_of_week, start_time,
  end_time, slot_minutes, is_active

appointments
  id, doctor_id FK, member_id FK, family_id FK,
  scheduled_at, duration_minutes,
  status ENUM(REQUESTED, CONFIRMED, DECLINED,
              COMPLETED, CANCELLED, NO_SHOW),
  triage_case_id FK NULLABLE,   ← links to the agentic flow
  created_at, updated_at

Privacy constraint (design already decided):
  Families see OPEN slots only. A doctor's booked
  slots are other patients' information and must
  never be exposed.
```

## 18.2 Payment and settlement

Deferred deliberately. Handling real transactions for medical services in an academic prototype carries regulatory and data-protection exposure disproportionate to its value, and contributes nothing to the assessed criteria. Version 1 assumes clinic-side settlement — payment occurs outside the platform, as it does today in Sri Lankan GP practice.

## 18.3 External calendar synchronisation

Deferred. Google Calendar and Outlook integration requires OAuth consent flows, token refresh handling and per-provider API differences. A lower-cost interim path is identified: generating an `.ics` file for download, which requires no OAuth and no stored third-party credentials. Not implemented in v1.

## 18.4 Live video consultation

Deferred. WebRTC signalling, TURN server provisioning and media handling represent substantial engineering cost. The asynchronous doctor review workflow already satisfies the cross-platform workflow requirement and is a better fit for a context-assembly product, where the value lies in preparation rather than real-time presence. (ADR-009.)

## 18.5 Personalised lifestyle and nutrition guidance

**Deferred on safety grounds, not scope grounds.** Dietary plans and exercise prescriptions for diabetic, renal, paediatric or pregnant patients constitute clinical nutrition therapy and require a qualified clinician. Version 1 permits only generic, sourced public-health information, and only within a doctor-approved advisory.

## 18.6 Automated SLMC verification

Deferred. **No public API to the Sri Lanka Medical Council register currently exists.** Version 1 uses manual, admin-mediated verification against the public register, with the full decision trail recorded in `doctor_verification_log`.

## 18.7 Additional deferred items

| Item | Reason |
|---|---|
| Wearable device integration | Scope; no rubric contribution |
| Pharmacy / e-prescription dispensing | Regulated domain |
| Multi-language UI (Sinhala/Tamil) | Valuable for real deployment; not assessed |
| Offline-first mobile sync | Significant complexity; not assessed |
| Doctor-to-doctor referral network | Natural v2 extension of `case_access_grants` |

---

## Post-freeze intake log

Anything proposed after the W5 freeze is recorded here with the date and the proposer. It is not built.

| Date | Proposal | Proposed by | Disposition |
|---|---|---|---|
| — | — | — | — |
