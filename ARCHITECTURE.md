# Rounder mobile architecture

## Scope
Flutter package: `rounder_application`. This migration reorganizes existing source; it does not complete the product or introduce new business flows.

## Shared code
| Path | Responsibility |
| --- | --- |
| lib/main.dart | Mount EasyLocalization and the existing authentication provider |
| lib/service_initialize.dart | Binding initialization, localization initialization, then existing DI setup, in the original order |
| lib/app.dart | MaterialApp, locale delegates, theme and existing authentication gate |
| lib/core/images/app_images.dart | AppImages asset constants |
| lib/core/locale/app_locale_key.dart | AppLocaleKey localization constants |
| lib/core/network | Existing ApiConsumer and DioConsumer |
| lib/core/services/services_locator.dart | Existing GetIt sl registrations and Dio interceptors |
| lib/core/theme/app_theme.dart | Existing AppColors and AppTheme |

## Features
Authentication is in `lib/layout/global/features/auth`.
Resident features are in `lib/layout/resident/features`:
dashboard, bookings, services, emergencies, properties, account, onboarding, association.

Applicable subdirectories:
- `data/model`: existing models; public class names and JSON contracts retained.
- `data/repo`: existing repositories; filenames end in _repo.dart, existing Repository class names and return types retained.
- `presentation/cubit`: Cubits and matching state parts.
- `presentation/view/screen`: existing screens and intact multi-screen flows.
- `presentation/view/widget`: existing standalone feature widgets.

Five custom state groups were extracted verbatim into *_state.dart files using part/part of.
PreviewOrdersCubit continues to use List<PreviewOrder>; no artificial state wrapper was introduced.
Private helper widgets and combined flows stay in their original Dart libraries.

## Preserved architectural exceptions
The approved mapping prioritizes pure restructuring over introducing missing reference functionality:
- Secure storage remains flutter_secure_storage; Hive and Firebase are not added.
- Existing state classes remain unchanged; no Equatable/StatusState conversion.
- Repository contracts remain unchanged; no Either/Failure redesign or new abstract interfaces.
- Direct navigation, tab switching, auth gating and existing BlocProvider ownership remain unchanged. No named-route table existed to relocate.
- Existing API clients and route names on the server remain unchanged.
- Multi-purpose account, welcome, association and service journey files remain intact in their approved feature folders.

See [routing and DI audit](docs/ROUTING_DI_AUDIT.md) for lifetimes and ownership.
All internal import/export directives use package:rounder_application paths; part directives stay within their Dart library.

## Build and verification
The restructuring workflow runs flutter pub get, strict flutter analyze and flutter test.
For application changes it generates an Android host in CI only, restores the repository pubspec,
and builds a debug APK. Native generated files are not committed.
Documentation-only commits repeat analysis/tests without rebuilding unchanged application code.

See [mapping](docs/RESTRUCTURE_MAPPING.md) and [validation report](docs/RESTRUCTURE_VALIDATION.md).
