# Rounder Resident App

Flutter mobile application for the Rounder resident experience.

## Product scope

The application follows the **02 - Resident App** page in the Rounder Figma file. Its flows cover onboarding and authentication, residence linking, services and bookings, order tracking, owners' association, payments, rewards, profile and aftercare.

## Architecture

- Feature-first structure under `lib/layout`.
- Shared app services, networking, localization, routes, theme, and reusable widgets under `lib/core`.
- Cubit state management, repositories, models, and dependency injection.
- The Flutter app is a client of the separate Laravel REST API in [RounderAdmin](https://github.com/khaledmohsen954/RounderAdmin).

## Localization and assets

- Arabic is the initial locale; English and Urdu are supported.
- Translation keys live in `AppLocaleKey`; locale data lives under `i18n/`.
- Asset paths are centralized in `AppImages`; local design assets live under `assets/`.
- Locale changes are runtime-selectable and persisted.

## Project status

The repository is being initialized from the approved Figma design. The Figma QA boards marked as simulations or outside the app are implementation notes, not resident-facing screens.
