# Rounder mobile restructuring — inventory and proposed mapping

Status: awaiting owner approval. No application file has been moved.
Package: `rounder_application`.
Branch: `restructure/petromin-layout`.
Source baseline: `8979aa5167796479ef4a27de02ae7260ba83f394`.
Approved prerequisite fix: emergency RadioGroup migration, `2365add192b656ae247bff6a833cedf5a6d7e69f`.

## Inventory

34 Dart files under lib and 3 existing test files:
- 12 presentation screen/flow files (some contain multiple screens).
- 2 standalone widget files; additional private widgets remain in their containing libraries.
- 6 Cubit files; states are currently colocated, and PreviewOrdersCubit uses List<PreviewOrder>.
- 4 repository files, 3 standalone model files.
- 1 DI file, 2 network files, 1 theme file, 2 constants files, 2 entry files.
- No dedicated route files. Navigation currently uses direct Navigator pushes and MaterialApp.home.

Shared infrastructure: network, DI, theme, localization keys and image constants.
Shared feature: authentication.
Resident-specific features: dashboard, bookings, services, emergencies, properties and association.
The account/onboarding placement decisions below require explicit approval.

## Proposed file mapping

| Old path | New path |
| --- | --- |
| `lib/core/constants/app_images.dart` | `lib/core/images/app_images.dart` |
| `lib/core/constants/app_locale_key.dart` | `lib/core/locale/app_locale_key.dart` |
| `lib/core/di/injection.dart` | `lib/core/services/services_locator.dart` |
| `lib/layout/auth/data/auth_repository.dart` | `lib/layout/global/features/auth/data/repo/auth_repo.dart` |
| `lib/layout/auth/presentation/auth_cubit.dart` | `lib/layout/global/features/auth/presentation/cubit/auth_cubit.dart` |
| `lib/layout/auth/presentation/screens/login_screen.dart` | `lib/layout/global/features/auth/presentation/view/screen/login_screen.dart` |
| `lib/layout/resident/data/models/resident_dashboard.dart` | `lib/layout/resident/features/dashboard/data/model/resident_dashboard_model.dart` |
| `lib/layout/resident/data/repositories/resident_repository.dart` | `lib/layout/resident/features/dashboard/data/repo/resident_repo.dart` |
| `lib/layout/resident/presentation/cubit/resident_dashboard_cubit.dart` | `lib/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart` |
| `lib/layout/resident/presentation/screens/resident_home_screen.dart` | `lib/layout/resident/features/dashboard/presentation/view/screen/resident_home_screen.dart` |
| `lib/layout/resident/data/models/booking_item.dart` | `lib/layout/resident/features/bookings/data/model/booking_item_model.dart` |
| `lib/layout/resident/data/repositories/bookings_repository.dart` | `lib/layout/resident/features/bookings/data/repo/bookings_repo.dart` |
| `lib/layout/resident/presentation/cubit/bookings_cubit.dart` | `lib/layout/resident/features/bookings/presentation/cubit/bookings_cubit.dart` |
| `lib/layout/resident/presentation/cubits/preview_orders_cubit.dart` | `lib/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart` |
| `lib/layout/resident/presentation/screens/bookings_screen.dart` | `lib/layout/resident/features/bookings/presentation/view/screen/bookings_screen.dart` |
| `lib/layout/resident/presentation/screens/orders_prototype_screen.dart` | `lib/layout/resident/features/bookings/presentation/view/screen/orders_prototype_screen.dart` |
| `lib/layout/resident/data/models/service_option.dart` | `lib/layout/resident/features/services/data/model/service_option_model.dart` |
| `lib/layout/resident/data/repositories/services_repository.dart` | `lib/layout/resident/features/services/data/repo/services_repo.dart` |
| `lib/layout/resident/presentation/cubit/services_cubit.dart` | `lib/layout/resident/features/services/presentation/cubit/services_cubit.dart` |
| `lib/layout/resident/presentation/screens/services_screen.dart` | `lib/layout/resident/features/services/presentation/view/screen/services_screen.dart` |
| `lib/layout/resident/presentation/screens/service_journey_screen.dart` | `lib/layout/resident/features/services/presentation/view/screen/service_journey_screen.dart` |
| `lib/layout/resident/presentation/screens/emergency_request_screen.dart` | `lib/layout/resident/features/emergencies/presentation/view/screen/emergency_request_screen.dart` |
| `lib/layout/resident/presentation/screens/link_home_screen.dart` | `lib/layout/resident/features/properties/presentation/view/screen/link_home_screen.dart` |
| `lib/layout/resident/presentation/cubits/phone_change_cubit.dart` | `lib/layout/resident/features/account/presentation/cubit/phone_change_cubit.dart` |
| `lib/layout/resident/presentation/screens/account_flow.dart` | `lib/layout/resident/features/account/presentation/view/screen/account_flow.dart` |
| `lib/layout/resident/presentation/widgets/discard_profile_dialog.dart` | `lib/layout/resident/features/account/presentation/view/widget/discard_profile_dialog.dart` |
| `lib/layout/resident/presentation/widgets/phone_change_panel.dart` | `lib/layout/resident/features/account/presentation/view/widget/phone_change_panel.dart` |
| `lib/layout/resident/presentation/screens/resident_welcome_flow.dart` | `lib/layout/resident/features/onboarding/presentation/view/screen/resident_welcome_flow.dart` |
| `lib/layout/resident/presentation/screens/union_screen.dart` | `lib/layout/resident/features/association/presentation/view/screen/union_screen.dart` |

## Files retained in place

`lib/main.dart`, `lib/app.dart`, `lib/core/network/api_consumer.dart`,
`lib/core/network/dio_consumer.dart`, `lib/core/theme/app_theme.dart`.
Tests retain their paths and receive updated package imports.
Assets, translation JSON, pubspec dependencies and platform files remain unchanged.

## Decisions requiring approval

1. `account_flow.dart` combines profile, settings, notifications, privacy, help, gifts and phone editing. Proposed: move intact to resident/features/account. Do not split widget/state logic or assume this is reusable by other roles.
2. `resident_welcome_flow.dart` combines introduction, tasks and gifts. Proposed: keep intact in resident/features/onboarding, not global onboarding.
3. `union_screen.dart` combines association finance, dues, facilities, visits, news and community. Proposed: keep intact under association.
4. `service_journey_screen.dart` spans catalogue, booking, payment preview and follow-up. Proposed: keep intact in services for this path-only migration.
5. `orders_prototype_screen.dart` contains order list and details; `PreviewOrder` lives in its Cubit library. Preserve these library boundaries in bookings.
6. Preserve existing public class names (e.g. AuthRepository, BookingItem, AccountFlow); only filenames/paths follow the target naming convention.

## Pure restructuring boundaries

The project currently uses flutter_secure_storage; Hive, Firebase, Either, Equatable and StatusState are absent.
Adding those libraries, changing repository return contracts or rewriting Cubit states is outside this restructuring.
Existing DI lifetimes and injection sites remain unchanged. Do not register new services solely to imitate the reference.
Do not force all routes into a new onGenerateRoute switch: that would rewrite navigation behavior rather than move existing route declarations.
Empty reference directories are not evidence of implemented functionality.

Existing colocated Cubit state declarations may be extracted verbatim into matching *_state.dart parts,
preserving their Dart library, identifiers and behavior. PreviewOrdersCubit has no custom state class to extract.
Bootstrap extraction, if performed, must preserve the exact existing initialization sequence; no additional services or permissions.

## Execution after approval

- Phase 2: move shared core files and update all imports; analyze + tests; one commit.
- Phase 3: migrate auth, then each resident feature separately; analyze + tests after each feature; one commit per feature.
- Phase 4: verify existing DI and navigation references; preserve behavioral exceptions above.
- Phase 5: verify entry/localization imports, build Android APK without committing generated native files.
- Phase 6: remove only verified obsolete paths, update README/ARCHITECTURE and report actual checks.

Each failing phase stops execution. No move is approved by the existence of this document.

## Phase 0 validation

Flutter pub get, strict flutter analyze and flutter test passed after the prerequisite fix.
Evidence: https://github.com/khaledmohsen954/Rounderapplication/actions/runs/39040893589
APK rebuild is pending the restructuring phases; this baseline run does not claim APK validation.
