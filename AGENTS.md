# nex_gen_ai — Project Notes

Flutter mobile client for the NexgenAI platform (web: https://brainvoai.com, an Angular SPA).
Backend: Laravel REST API at `https://api.brainvoai.com/api/` (bearer token auth, Laravel
signed-URL email verification).

## Verification commands
- `flutter analyze` — must report no issues
- `flutter test` — widget tests (secure storage is overridden with a fake; plugin channels
  hang forever in the test environment, so always override `secureStorageProvider` in tests)

## Architecture
- State management / DI: Riverpod 3 (plain `Notifier` classes — riverpod codegen packages
  conflict with this SDK's analyzer version, do NOT add riverpod_generator/riverpod_lint)
- Routing: go_router with `StatefulShellRoute.indexedStack` (3 branches: Home `/`,
  History `/history`, Settings `/settings`); auth redirect lives in `lib/app/router.dart`
- Networking: dio (`lib/core/api/dio_client.dart`) with `AuthInterceptor` (bearer injection,
  401 → token wipe + `AuthInterceptor.onUnauthorized`); errors normalized via `ApiException`
- Folder layout: feature-first (`lib/features/<feature>/{data,application,presentation}`),
  shared code in `lib/core/`, app-level config in `lib/app/`

## Theme
Dark neon theme ported from the website's CSS tokens (`lib/app/theme/app_colors.dart`):
base scale #0D1B2A→#E0E1DD, primary pink #E72D63, neon cyan/purple/pink/blue accents,
16px radius, ShareTechMono for display text only.

## Security rules
- NEVER embed AI provider keys (OpenAI/Gemini/HF/etc.) in the app — all AI calls must be
  proxied through the backend. (The website leaks keys client-side; do not copy that.)
- Tokens go in `flutter_secure_storage` only.

## Known gotchas
- Some bundled assets are `.avif`, which Flutter cannot decode — convert to webp/png before use.
- Asset filenames contain spaces/typos (e.g. `logo-1 (1).png`, `Gear Loader.gif`).
- iOS monetization must use in-app purchase (RevenueCat planned), not Stripe.
