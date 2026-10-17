# Routing and dependency audit

Phase 4: preserve existing behavior while consolidating the DI file in core/services.

## Dependency lifetimes

| Dependency | Existing registration / owner |
| --- | --- |
| ApiConsumer / DioConsumer | Lazy singleton; Dio and interceptors configured in configureDependencies |
| AuthRepository | Lazy singleton |
| ResidentRepository | Lazy singleton |
| ServicesRepository | Lazy singleton |
| BookingsRepository | Lazy singleton |
| AuthCubit | Factory; root BlocProvider owns its instance |
| ResidentDashboardCubit | Factory; dashboard provider, with explicit preview constructor in offline entry |
| ServicesCubit | Factory; ServicesScreen provider |
| BookingsCubit | Factory; BookingsScreen provider |
| PreviewOrdersCubit | Shared lazy singleton across service and order previews |
| PhoneChangeCubit | Local panel-owned instance; intentionally not a global singleton |

## Navigation

Existing MaterialApp.home authentication selection, direct MaterialPageRoute pushes,
BlocProvider/BlocProvider.value ownership and tab/flow switching are unchanged.
There were no named route declarations to relocate. Introducing a new named-router
switch is an explicitly documented exception to the reference because it would
rewrite the navigation mechanism rather than relocate existing declarations.

## Source audit

All 37 pre-migration Dart source/test files were compared after resolving moved
paths, removing import directives and reconstructing extracted state parts.
Their non-import contents match modulo whitespace. No implementation differences.
All package:rounder_application imports point to existing files.
This is a source audit, not an interactive end-to-end navigation test.

The earlier authorized RadioGroup compatibility fix is outside that comparison:
the comparison baseline already includes that separately committed prerequisite.
