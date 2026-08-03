# Flutter Security — Family Veda

Project-wide policy: `rules/security.md`.

## Token handling

- Refresh tokens in `flutter_secure_storage` (Keychain / EncryptedSharedPreferences). **Never `SharedPreferences`.**
- Access tokens in memory only.
- Clear both on logout, on 401-after-refresh, and on account switch.
- Never log a token, never include one in an error report.

## Configuration

- API base URL passed with `--dart-define`, never hardcoded and never committed per-environment.
- `google-services.json` is **gitignored**. So is any signing keystore and `key.properties`.
- No secret is ever compiled into the app. A mobile binary is not a secret store — anything shipped in it is public.

## Network

- HTTPS only in production. Do not disable certificate validation, not even "temporarily for testing".
- The app talks **only** to the Family Veda API. It never calls Ollama, FCM's send API, or Twilio directly (invariants 3 and 4).
- Timeouts on every request; a hung request must surface as a retryable error, not a frozen screen.

## Permissions

- Request camera and storage permission **at the moment of use**, with an explanation, not at app start.
- Handle permanent denial gracefully — offer manual entry instead of the camera path.
- Request nothing the app does not need. A health app asking for contacts is a red flag to a user and to an examiner.

## Data on device

- Do not cache clinical records to unencrypted local storage.
- Captured lab report images are uploaded and then removed from app-local temporary storage.
- No clinical content in crash reports or analytics.
- Consider `FLAG_SECURE` on screens showing clinical data to block screenshots — document the decision either way.

## Display rules

- The patient sees `approvals.final_advisory` only. Never a draft advisory, never raw agent output.
- The disclaimer component is persistently visible on any advisory screen.
- The emergency screen contains **no AI-generated text**.

## Checklist

- [ ] No secrets in the repo or the binary
- [ ] Tokens in secure storage, cleared on logout
- [ ] HTTPS enforced; certificate validation untouched
- [ ] Permissions requested in context, denial handled
- [ ] No clinical data in logs, crash reports, or unencrypted cache
- [ ] No direct calls to third-party services
- [ ] Nothing patient-visible that has not passed the approval gate
