# mobile — Flutter application

**ONE** application. The **patient and family operational** surface — a different purpose from React, as the specification requires. Scaffolded in W2.

Flutter 3.x · go_router · Riverpod (ADR-005) · flutter_secure_storage · flutter_test

## Target structure

```
mobile/
├── lib/
│   ├── screens/
│   │   ├── auth/                             [S1]
│   │   ├── family/                           [S1]
│   │   ├── records/                          [S2]
│   │   ├── vitals/                           [S2]
│   │   ├── triage/                           [S3]
│   │   ├── notifications/                    [S3]
│   │   ├── risk/                             [S4]
│   │   └── emergency/                        [S4]
│   ├── widgets/
│   │   ├── shared/                           ⚠ review required
│   │   └── {by owner}/
│   ├── providers/                            one file per owner
│   ├── services/api/                         one client file per owner
│   ├── models/                               mirrors backend DTOs
│   ├── router/app_router.dart                ⚠ SHARED
│   └── main.dart                             ⚠ SHARED
├── test/
└── pubspec.yaml                              ⚠ SHARED
```

## Screen inventory

| # | Screen | Owner | Key features |
|---|---|---|---|
| 1 | Onboarding / Login | S1 | Secure token storage (`flutter_secure_storage`) |
| 2 | Family Setup | S1 | Create family, add members |
| 3 | Member Switcher | S1 | Active-profile selector, persisted |
| 4 | Home / Member Summary | S3 | Latest vitals, active cases, alerts |
| 5 | Submit Complaint | S3 | Symptom picker, duration, severity slider, notes |
| 6 | **Upload Lab Report** | S2 | **Camera / image picker — the device feature** |
| 7 | Record Vitals | S2 | Weight, BP, temperature, blood sugar |
| 8 | Records List | S2 | Search, filter by type, sort, paginate |
| 9 | Case Status Tracker | S3 | Live stepper matching the state machine |
| 10 | Approved Guidance | S4 | Doctor-approved advisory **only** |
| 11 | Familial Risk & Screening | S4 | Consented signals + screening recommendations |
| 12 | Consent Settings | S1 | Grant/revoke own sharing |
| 13 | Notifications | S3 | Push inbox |
| 14 | Emergency Screen | S4 | Red-flag path — **referral only, no AI output** |

## Required technical features

- Reusable widgets: `MemberCard` `StatusStepper` `VitalTile` `SymptomChip` `EmptyStateView` `ErrorRetryView`
- `go_router` navigation with auth redirect guards
- Riverpod state management (ADR-005)
- Registration, login, logout, secure token storage, protected screens
- Forms with validation, search, filtering, status tracking, history
- Responsive layouts; **loading, empty and error states everywhere**
- **Device feature: camera / image picker for lab report capture**
- Push notifications on case status change

## The active-member rule

The active member profile is a single Riverpod provider. **Every member-scoped provider watches it**, so switching profiles invalidates all dependent state automatically.

Showing one member's data under another member's name is the worst possible bug in this app. Never pass the active member down the widget tree by hand.

## The emergency screen

Deliberately minimal. **No AI-generated text of any kind.**

- Referral header: "Seek immediate in-person medical care."
- Suwa Seriya **1990** as a one-tap call action
- Nearest hospital list
- Statement that the case has been broadcast to verified doctors and the Family Head notified

## Rules

- Adding a route: add your block in `app_router.dart`. Do not restructure the guards.
- Adding a dependency: announce in the group chat before touching `pubspec.yaml`.
- New shared widget: PR review by at least one other member.
- `google-services.json` and any signing keystore are **gitignored** — never commit them.
- The API base URL is passed with `--dart-define`, never hardcoded.

## Commands

```bash
flutter pub get
```

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000/api/v1 --dart-define=APP_ENV=development
```

```bash
flutter test
```

```bash
flutter build apk --release
```

> `10.0.2.2` is the Android emulator's alias for the host machine's localhost. On a physical device, use the machine's LAN IP or the deployed URL.

## Run on an iPhone

Requirements: macOS, Xcode, CocoaPods, an Apple ID added to Xcode, and an iPhone with Developer Mode enabled. Keep the repository outside iCloud/File Provider folders so Xcode CodeSign does not inherit unsupported extended attributes; `~/Developer/Family-Veda` is a suitable location.

```bash
cd mobile
flutter pub get
open ios/Runner.xcworkspace
```

In Xcode, select `Runner`, open **Signing & Capabilities**, select your Apple development team, and keep the bundle identifier `lk.familyveda.familyveda`. Connect and trust the iPhone, then run:

```bash
flutter devices
flutter run -d <iphone-device-id> \
  --dart-define=API_BASE_URL=https://<deployed-api-host>/api/v1 \
  --dart-define=APP_ENV=development
```

For a local backend, use a trusted HTTPS development endpoint or tunnel; do not disable certificate validation. Push notifications additionally require a Firebase iOS app with the same bundle identifier, `GoogleService-Info.plist` added locally to the Runner target, and the Push Notifications capability enabled in Xcode. The Firebase file is intentionally gitignored.

## References

`design.md` · `docs/API_CONTRACT.md` · `docs/CLINICAL_SAFETY.md` · `rules/flutter/` · `rules/frontend.md`
