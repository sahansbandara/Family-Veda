# Flutter / Dart Coding Style — Family Veda

Flutter 3.x · Dart 3. General baseline: `rules/common/coding-style.md`.

## Naming

| Element | Convention |
|---|---|
| Class, enum, extension, typedef | `UpperCamelCase` |
| Variable, parameter, function, method | `lowerCamelCase` |
| Private member | `_leadingUnderscore` |
| File, directory | `snake_case.dart` |
| Constant | `lowerCamelCase` (Dart convention, not `SCREAMING_CAPS`) |

Owner-tagged files carry a header comment: `// [S2] Health Records & Extraction`.

## Structure

- One widget per file where the widget is non-trivial. 200–400 lines typical, 800 hard max.
- Directory by feature and owner: `screens/records/` [S2], `screens/triage/` [S3].
- `const` constructors wherever possible — a real performance win in a rebuild-heavy tree.
- Prefer composition over deep widget nesting. Extract a named widget before nesting five levels.

## Widgets

- `StatelessWidget` + Riverpod providers by default. `StatefulWidget` only for genuinely local, ephemeral state (animation controllers, text controllers).
- `ConsumerWidget` / `ConsumerStatefulWidget` for anything reading a provider.
- Extract a widget rather than a `_buildSomething()` method — extracted widgets get their own rebuild scope; helper methods do not.

## Null safety

- Sound null safety, always. No `late` unless initialisation is genuinely deferred and provably assigned before use.
- Never `!` to silence the analyser. Handle the null.

## Async

- `Future`/`async`-`await`, never `.then()` chains for readability.
- Always handle the error case. `AsyncValue.when(data:, loading:, error:)` covers all three states by construction — use it.
- Never block the UI isolate on heavy work; use `compute` for parsing large payloads.

## Formatting

- `dart format` clean. `flutter analyze` with **zero** warnings — CI enforces it.
- Trailing commas on multi-line argument lists so the formatter breaks lines predictably.

## Comments

Explain **why**. The always-welcome comment: a note on a clinical or authorisation rule with a doc pointer.

```dart
// The emergency screen shows no AI-generated text by design.
// See docs/CLINICAL_SAFETY.md, emergency path.
```
