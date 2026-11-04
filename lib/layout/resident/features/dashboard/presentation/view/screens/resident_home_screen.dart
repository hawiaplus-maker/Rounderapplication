import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_flow.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_screen.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/screens/orders_prototype_screen.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_dashboard_body.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/resident_dock.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/screens/emergency_request_screen.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/service_journey_screen.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/selected_home_store.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/screens/property_rating_screen.dart';

/// Resident application shell. The selected tab stays alive as a local
/// prototype; each feature owns its own screens and state.
class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({super.key});

  @override
  State<ResidentHomeScreen> createState() => _ResidentHomeScreenState();
}

class _ResidentHomeScreenState extends State<ResidentHomeScreen> {
  int _tab = 0;

  void _openEmergency() {
    final dashboardState = context.read<ResidentDashboardCubit>().state;
    // The unit picked on the dashboard's selector leads the request; without
    // a pick the dashboard's own home is used.
    final homeId =
        sl<SelectedHomeStore>().readId() ??
        (dashboardState is DashboardReady ? dashboardState.data.homeId : null);
    Navigator.of(
      context,
    ).push(
      MaterialPageRoute<void>(
        builder: (_) => EmergencyRequestScreen(residentHomeId: homeId),
      ),
    );
  }

  void _openPropertyRating() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const PropertyRatingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.watch<ResidentDashboardCubit>().state;
    final homeName = dashboardState is DashboardReady ? dashboardState.data.homeName : '';
    final unitLabel = dashboardState is DashboardReady ? dashboardState.data.unitLabel : '';
    // Reading the locale here rebuilds this shell on every language change, so
    // the tabs below get fresh keys and rebuild from scratch: widgets that were
    // built as `const` (or parked in the IndexedStack) would otherwise keep the
    // strings they resolved in the previous language.
    final String localeCode = context.locale.languageCode;
    final pages = <Widget>[
      HomeDashboardBody(
        key: ValueKey<String>('home-$localeCode'),
        onTalkToAli: () => setState(() => _tab = 1),
        onMoreBalance: () => setState(() => _tab = 3),
        onVisitDetails: () => setState(() => _tab = 3),
        onEmergency: _openEmergency,
        onViewAssessment: _openPropertyRating,
      ),
      ServiceJourneyScreen(key: ValueKey<String>('services-$localeCode')),
      OrdersPrototypeScreen(key: ValueKey<String>('orders-$localeCode')),
      UnionScreen(key: ValueKey<String>('union-$localeCode')),
      // The account tab keeps its state: the language is switched from its
      // settings page, so the resident stays where the switch happened.
      AccountFlow(homeName: homeName, unitLabel: unitLabel),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        extendBody: true,
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppColors.homeBackground),
          child: SafeArea(
            bottom: false,
            child: IndexedStack(index: _tab, children: pages),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              HomeSpacing.page,
              0,
              HomeSpacing.page,
              HomeSizes.dockBottomInset,
            ),
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: HomeSizes.maxContentWidth),
                child: ResidentDock(
                  selectedIndex: _tab,
                  onSelected: (index) => setState(() => _tab = index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
