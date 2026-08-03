# C# / ASP.NET Core Security — Family Veda

Project-wide policy: `rules/security.md`. This file is the .NET-specific implementation.

## Authentication

- JWT bearer, validated with `TokenValidationParameters`: issuer, audience, lifetime, signing key — **all four**, `ClockSkew = TimeSpan.Zero`.
- Signing key from configuration/environment. Never a literal.
- Passwords hashed with ASP.NET Core Identity's hasher or `Rfc2898DeriveBytes` with a per-user salt. Never MD5/SHA-1, never unsalted.
- Refresh tokens stored hashed, single-use, revocable.
- Rate limiting on `/auth/*` via `AddRateLimiter`.

## Authorisation

- Named policies, never inline role strings scattered across controllers.
- Clinical data policies read `case_access_grants`, never `user.role` (ADR-008).
- `[Authorize]` by default; `[AllowAnonymous]` only on `/auth/register`, `/auth/login`, `/auth/refresh`.
- A `PENDING` doctor must fail every clinical policy — test it.

## EF Core

- **Parameterised by construction.** Never `FromSqlRaw` with string interpolation of user input; use `FromSqlInterpolated` only if raw SQL is truly unavoidable (it is not, here).
- Never expose `IQueryable` to a controller — an unbounded query is a DoS and a data-leak surface.
- Always paginate. Cap `pageSize`.

## Input

- FluentValidation on every request DTO.
- File upload: enforce content type and size (`Storage__MaxUploadBytes`), generate the stored filename yourself, store outside the web root, never serve by user-supplied path.
- **OCR text is untrusted.** It is data extracted into structured fields, never a string interpolated into an agent prompt as instruction.
- **LLM output is untrusted.** JSON-schema validate before use. Never `JsonSerializer.Deserialize` into a type and assume the fields are sane.

## Output

- RFC 7807 Problem Details from one middleware.
- Production: generic 500 with a trace id. No stack trace, no SQL, no entity names, no member names.
- 404 instead of 403 where the existence of the resource is itself private.

## Secrets

- Environment variables only. `appsettings.Development.json` and `appsettings.Production.json` are gitignored.
- Never log a token, a password, a connection string, or clinical content.
- Use `dotnet user-secrets` for local development if preferred — it stores outside the repo.

## Transport

- `app.UseHttpsRedirection()` and HSTS in production.
- CORS restricted to the configured origins. Never `AllowAnyOrigin` with credentials.

## Checklist before a PR touching security

- [ ] Named policy used, not an inline role check
- [ ] Grant check present on every clinical read
- [ ] Consent check present on every cross-profile read
- [ ] Audit row written on every cross-profile read
- [ ] Validator present on every new request DTO
- [ ] No raw SQL, no unbounded query
- [ ] No secret in configuration files or logs
- [ ] Negative test: unauthorised caller gets 403/404, and it is asserted
