# nex_gen_ai — Project Notes

Flutter mobile client for the NexgenAI platform (web: https://brainvoai.com, an Angular SPA).
Backend: Laravel REST API at `https://api.brainvoai.com/api/` (bearer token auth, Laravel
signed-URL email verification).

## Verification commands
- `flutter analyze` — must report no issues
- `flutter test` — unit + widget tests
- `flutter build apk --debug` — full compile check

## Running with AI features enabled
AI calls go through an OpenAI-compatible gateway that must be supplied at build time.
Never hardcode provider keys in the app.
```
flutter run --dart-define=AI_BASE_URL=https://your-proxy.example.com/v1/
```
Optional defines: `AI_API_KEY` (local dev only), `AI_CHAT_MODEL`, `AI_IMAGE_MODEL`.
Without `AI_BASE_URL`, generation surfaces `AiNotConfiguredException` instead of failing silently.

## Architecture
- State management / DI: Riverpod 3 (plain `Notifier` classes — riverpod codegen packages
  conflict with this SDK's analyzer version, do NOT add riverpod_generator/riverpod_lint)
- Routing: go_router with `StatefulShellRoute.indexedStack` (3 branches: Home `/`,
  History `/history`, Settings `/settings`); auth + onboarding redirects in `lib/app/router.dart`
- Networking: dio (`lib/core/api/dio_client.dart`) with `AuthInterceptor` (bearer injection,
  401 → token wipe + `AuthInterceptor.onUnauthorized`); errors normalized via `ApiException`
- AI gateway: `lib/core/api/ai_client.dart` (chat, SSE streaming chat, image generation)
- Folder layout: feature-first (`lib/features/<feature>/{data,application,presentation}`),
  shared code in `lib/core/`, app-level config in `lib/app/`

## Backend endpoints (extracted from the production web bundles)
Auth: `login`, `register`, `logout`, `forgot-password`, `reset-password`, `password`,
`update-user`, `email/verification-notification`, `verify-email/{id}/{hash}`, `user`,
`user/transactions`.
Website/billing: `packages`, `settings`, `blogs`, `blog/{id}`, `createPaymentIntent?package_id=`.
Media/interior: `medias` (POST/GET/DELETE), `create-interior-prediction`,
`get-prediction/{id}` (async prediction — poll until `succeeded`).

## Testing notes
- `test/helpers.dart` provides `testOverrides()`; ALWAYS use it for widget tests.
  `flutter_secure_storage`, `shared_preferences` and Hive all need overrides — the real
  secure-storage platform channel never completes under `flutter test` (it hangs forever).
- `Override` is exported from `package:flutter_riverpod/misc.dart`, not the main entrypoint.

## Theme
Dark neon theme ported from the website's CSS tokens (`lib/app/theme/app_colors.dart`):
base scale #0D1B2A→#E0E1DD, primary pink #E72D63, neon cyan/purple/pink/blue accents,
16px radius, ShareTechMono for display text only.
App icon + splash generated from `assets/img/logo.png` via flutter_launcher_icons /
flutter_native_splash (`flutter_native_splash.yaml`); re-run after changing the logo.

## Security rules
- NEVER embed AI provider keys (OpenAI/Gemini/HF/etc.) in the app — proxy them server-side.
  (The website leaks its keys client-side; do not copy that pattern.)
- Tokens go in `flutter_secure_storage` only.
- Release builds: `flutter build appbundle --obfuscate --split-debug-info=build/symbols`

## Known gotchas / remaining work
- Some bundled assets are `.avif`, which Flutter cannot decode — convert to webp/png before use.
- Asset filenames contain spaces/typos (e.g. `logo-1 (1).png`, `Gear Loader.gif`).
- iOS monetization MUST use in-app purchase (RevenueCat), not Stripe — billing screen's
  "Choose Plan" is deliberately stubbed until IAP is wired.
- Not yet built: Short Generation (video), push notifications, analytics/crash reporting,
  deep linking, voice mode for AI agents, email-verification pending screen.
- Android release still signs with debug keys (see `android/app/build.gradle.kts`).
