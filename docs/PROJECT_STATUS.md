# Rounder mobile implementation status

## Product source
Figma source: [Resident App](https://www.figma.com/design/MvOZdYEkaWILN1VEd5Ka2d/Untitled?node-id=11-2)

## Implemented foundation
- Flutter project shell, Arabic/English/Urdu locale files, runtime language switch and persisted language selection.
- `AppLocaleKey` and `AppImages` central catalogs.
- Petrel/sand/mint/orange brand palette and responsive resident dashboard.
- Feature-first resident data/model/repository/Cubit boundaries, Dio, GetIt and language-aware request headers.
- Secure token storage, register/login API client and sign out.
- Android release APK GitHub Actions workflow. The generated APK is available as an Actions artifact after a successful run.

## Initial mobile API contract
The client expects a Laravel API root such as `https://your-host/api/v1`. Supply it as:
`flutter run --dart-define=API_BASE_URL=https://your-host/api/v1`

The first screen reads `GET /resident/dashboard` with a Sanctum bearer token. Account actions call `POST /auth/register`, `POST /auth/login` and `POST /auth/logout`.

## Design follow-up
Resident App includes more screens than the foundation currently implements. The next feature slices to implement and verify are onboarding/residence linking, service catalog and booking, booking tracking, invoices/payments, residents' association, events/community, rewards, profile/settings, cancellation, aftercare, and notifications. This checklist is kept explicit so unfinished Figma flows are not mistaken for completed screens.
