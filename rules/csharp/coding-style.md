# C# Coding Style — Family Veda

C# 12 · .NET 8. General baseline: `rules/common/coding-style.md`.

## Naming

| Element | Convention |
|---|---|
| Class, record, interface (`I` prefix), method, property, public field | `PascalCase` |
| Local, parameter | `camelCase` |
| Private field | `_camelCase` |
| Constant | `PascalCase` |
| Async method | Suffix `Async` |
| File | Matches the type name |

Owner-tagged files carry a header comment: `// [S3] Triage & Agent Orchestration`.

## Structure

- One public type per file. 200–400 lines typical, 800 hard max.
- `file-scoped namespace;` — no extra indentation level.
- `using` directives sorted, unused ones removed.
- Constructor injection; prefer primary constructors for services.
- `record` for DTOs, `class` for entities, `readonly record struct` for small value types.

## Nullability

- Nullable reference types **enabled** solution-wide.
- Never `!` (null-forgiving) to silence a warning. Fix the nullability instead.
- Guard clauses at the top of a method; return early.

## Async

- `async Task<T>` everywhere I/O happens. No `async void` except event handlers.
- Pass `CancellationToken` through the call chain.
- Never `.Result` or `.Wait()` — deadlock risk.
- Every controller action is `async Task<ActionResult<T>>`.

## Errors

- Throw specific exceptions (`ToolDeniedException`, `ConsentRequiredException`, `GrantExpiredException`), translated to Problem Details by `ExceptionMiddleware`.
- Never `catch (Exception)` and continue.
- Never swallow silently. If it is genuinely ignorable, log why in one line.

## Formatting

- 4-space indent, braces on their own line (standard .NET style).
- `var` when the type is obvious from the right-hand side, explicit otherwise.
- Expression-bodied members for one-liners only.
- Keep `dotnet format` clean — CI treats warnings as noise to be removed, not tolerated.

## Comments

Explain **why**, not what. The one comment style that is always welcome: a note on a non-obvious clinical or authorisation rule, with a pointer to the doc.

```csharp
// Guardian consent is void once the member turns 18 — treated as NOT granted
// until personally reaffirmed. See docs/PERMISSIONS.md, consent state machine.
```
