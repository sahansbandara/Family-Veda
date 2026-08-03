# Flutter Testing — Family Veda

`flutter_test` · Riverpod `ProviderContainer`. Plan: `docs/TESTING.md`.

## What to test

| Layer | Focus |
|---|---|
| Providers | Business logic in plain Dart unit tests — no widget tree needed |
| Widgets | Forms with validation, the status stepper, empty/error views |
| Models | JSON serialisation round-trips against the backend DTO shape |

Riverpod providers are testable without a widget tree, which makes them the cheapest route to the 80% coverage requirement. Put logic in providers, not in widgets.

## Provider test

```dart
test('active member switch invalidates member-scoped records', () async {
  final container = ProviderContainer(overrides: [
    recordApiProvider.overrideWithValue(FakeRecordApi()),
  ]);
  addTearDown(container.dispose);

  container.read(activeMemberProvider.notifier).state = memberA;
  expect(await container.read(memberRecordsProvider.future), isA<List<HealthRecord>>());

  container.read(activeMemberProvider.notifier).state = memberB;
  // The provider must refetch for member B, never serve member A's data.
});
```

The active-member invalidation test is **mandatory** — showing one member's data under another's name is the worst bug this app can have.

## Widget test

```dart
testWidgets('submit complaint form rejects an empty chief complaint', (tester) async {
  await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SubmitComplaintScreen())));

  await tester.tap(find.byKey(const Key('submit')));
  await tester.pump();

  expect(find.text('Please describe the main complaint'), findsOneWidget);
});
```

Use `Key`s on interactive elements so tests do not depend on visible text.

## Required coverage

Every screen you own has, at minimum:

- [ ] A test that the loading state renders
- [ ] A test that the empty state renders with its explanatory message
- [ ] A test that the error state renders with a working retry
- [ ] A test for each form validation rule

Every provider you own has:

- [ ] A happy-path test
- [ ] An error-path test
- [ ] An invalidation test if it depends on the active member

## Edge cases

null · empty list · network failure · 401 during a refresh · permission denied (camera) · very long names · Sinhala and Tamil characters · offline · slow response.

## Rules

- TDD: write the failing widget/provider test first.
- No real network calls in tests. Fake the API client at the provider boundary.
- No `Future.delayed` sleeps. Use `tester.pump(Duration(...))` deterministically.
- `flutter analyze` must be clean — CI fails on warnings.
- A flaky test is a broken test.
