# Rounder Resident App

Flutter resident app for the Rounder design at [Figma · Resident App](https://www.figma.com/design/MvOZdYEkaWILN1VEd5Ka2d/Untitled?node-id=11-2).

## Current implementation
The current working slice covers resident sign-up/sign-in, secure Sanctum token storage, home linking by property code, a live resident dashboard, localized services, service booking, booking history and cancellation. These data flows call the separate Laravel API in [RounderAdmin](https://github.com/khaledmohsen954/RounderAdmin).

This is the first delivery slice from the full Figma Resident App page. See [implementation guide](docs/IMPLEMENTATION_GUIDE.md) for what is wired and which design journeys still need implementation.

## Architecture
- Feature-first UI/data/state layers under `lib/layout`.
- Shared services, API client, localization keys, image paths, dependency injection and theme under `lib/core`.
- Cubits expose loading, ready and error states; repositories map API responses to UI models.
- Dio sends the saved locale in `Accept-Language` and a secure Sanctum bearer token after sign-in.

## Localization and assets
- Arabic is the initial locale; English and Urdu are selectable at runtime and saved.
- UI string IDs live in `AppLocaleKey`; JSON values live in `assets/i18n/{ar,en,ur}.json`.
- Asset paths are centralized in `AppImages`; add approved design exports under `assets/images`.

## Build
The Android Actions workflow generates the Flutter Android host, analyzes Dart, runs tests, builds a release APK and uploads it as an artifact. Set `API_BASE_URL` as a repository Actions variable or supply it locally:
`flutter run --dart-define=API_BASE_URL=https://your-host/api/v1`

## Main directories
```
lib/
  core/                 # API, DI, routing, theme, locale and asset catalogs
  layout/auth/          # resident sign-in and registration
  layout/resident/
    data/               # dashboard, homes, services and booking models/repos
    presentation/       # dashboard/services/bookings Cubits and screens
assets/i18n/             # ar, en, ur translations
assets/images/           # approved Rounder image exports
docs/                    # implementation and Figma flow guide
```
