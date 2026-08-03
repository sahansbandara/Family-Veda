# Flutter Patterns — Family Veda

Riverpod (ADR-005) · go_router · flutter_secure_storage.

## The active-member rule — the most important pattern in this app

Showing one member's data under another member's name is the worst possible bug in a health app.

```dart
// [S1] The single source of truth for whose data is on screen.
final activeMemberProvider = StateProvider<MemberId?>((ref) => null);

// [S2] Every member-scoped provider WATCHES it, so a profile switch
// invalidates all dependent state automatically.
final memberRecordsProvider = FutureProvider.autoDispose<List<HealthRecord>>((ref) async {
  final memberId = ref.watch(activeMemberProvider);
  if (memberId == null) return const [];
  return ref.watch(recordApiProvider).listRecords(memberId);
});
```

**Never pass the active member down the widget tree by hand.** Declare the dependency.

## All three async states, by construction

```dart
ref.watch(memberRecordsProvider).when(
  data:    (records) => records.isEmpty
                          ? const EmptyStateView(message: 'No records yet. Add one to start the history.')
                          : RecordList(records: records),
  loading: () => const CircularProgressIndicator(),
  error:   (e, _) => ErrorRetryView(onRetry: () => ref.invalidate(memberRecordsProvider)),
);
```

`when` makes forgetting a state a compile error. Use it rather than manual null/flag checks.

## Router guard

```dart
// [S1] app_router.dart — ⚠ SHARED. Add your route block; do not restructure the guards.
final router = GoRouter(
  redirect: (context, state) {
    final loggedIn = ref.read(authProvider).isAuthenticated;
    if (!loggedIn && !state.uri.path.startsWith('/auth')) return '/auth/login';
    return null;
  },
  routes: [
    // ===== S1 — Auth, Family, Consent =====
    // ===== S2 — Records, Vitals =====
    // ===== S3 — Triage, Notifications =====
    // ===== S4 — Risk, Emergency =====
  ],
);
```

## Secure storage

```dart
// [S1] Tokens never touch SharedPreferences.
const storage = FlutterSecureStorage();
await storage.write(key: 'refresh_token', value: token);
```

Access tokens in memory, refresh tokens in secure storage. Cleared on logout.

## API client

One client file per owner under `services/api/`. Each returns typed models from `models/`, which mirror the backend DTOs. Handle 401 by refreshing once, then routing to login.

## Widget extraction

```dart
// ❌ helper method — rebuilds with the whole parent
Widget _buildVitalTile(Vital v) => …

// ✔ extracted widget — gets its own rebuild scope, and is unit-testable
class VitalTile extends StatelessWidget { const VitalTile({super.key, required this.vital}); … }
```

## Anti-patterns

| Don't | Do |
|---|---|
| `setState` for cross-screen state | A Riverpod provider |
| Pass the active member as a constructor argument | `ref.watch(activeMemberProvider)` |
| `SharedPreferences` for tokens | `flutter_secure_storage` |
| Hardcode the API base URL | `--dart-define=API_BASE_URL=…` |
| `_buildX()` helper methods for real widgets | Extract a widget class |
| Ignore the error branch of an async call | `AsyncValue.when` with all three |
| Restructure `app_router.dart` | Add your labelled block only |
| `GestureDetector` on a bare `Container` | A button widget, or add `Semantics` |
