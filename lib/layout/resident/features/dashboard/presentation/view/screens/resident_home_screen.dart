import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/widgets/brand_gradient_backdrop.dart';
import 'package:rounder_application/layout/global/widgets/guest_gate_view.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/profile_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_flow.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_screen.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/screens/orders_prototype_screen.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/exit_app_dialog.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_dashboard_body.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/resident_dock.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/screens/emergency_request_screen.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/service_journey_screen.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/selected_home_store.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/screens/property_rating_screen.dart';

/// Resident application shell. The selected tab stays alive as a local
/// prototype; each feature owns its own screens and state.
class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({super.key, this.isGuest = false});

  /// Guest mode is opened on top of the login screen: protected tabs show a
  /// sign-in gate and back returns to that login screen instead of exiting.
  final bool isGuest;

  @override
  State<ResidentHomeScreen> createState() => _ResidentHomeScreenState();
}

class _ResidentHomeScreenState extends State<ResidentHomeScreen> {
  int _tab = 0;
  final Set<int> _loadedTabs = {0};

  /// The account identity is fetched once when the signed-in home opens, so
  /// opening the account tab only reveals it instead of refetching it on
  /// every tap. Guest mode has no session to fetch.
  ProfileCubit? _profileCubit;

  @override
  void initState() {
    super.initState();
    if (!widget.isGuest) {
      _profileCubit = sl<ProfileCubit>()..load();
    }
  }

  @override
  void dispose() {
    _profileCubit?.close();
    super.dispose();
  }

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

  /// Leaves guest mode and reveals the login screen underneath.
  void _backToLogin() {
    if (mounted) Navigator.of(context).maybePop();
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
        isGuest: widget.isGuest,
        onTalkToAli: () {
          _loadedTabs.add(1);
          setState(() => _tab = 1);
        },
        onMoreBalance: () {
          _loadedTabs.add(3);
          setState(() => _tab = 3);
        },
        onVisitDetails: () {
          _loadedTabs.add(3);
          setState(() => _tab = 3);
        },
        onEmergency: _openEmergency,
        onViewAssessment: _openPropertyRating,
      ),
      _loadedTabs.contains(1)
          ? ServiceJourneyScreen(
              key: ValueKey<String>('services-$localeCode'),
              isGuest: widget.isGuest,
            )
          : const SizedBox.shrink(),
      _loadedTabs.contains(2)
          ? OrdersPrototypeScreen(
              key: ValueKey<String>('orders-$localeCode'),
              isGuest: widget.isGuest,
              onSignIn: _backToLogin,
            )
          : const SizedBox.shrink(),
      _loadedTabs.contains(3)
          ? UnionScreen(key: ValueKey<String>('union-$localeCode'))
          : const SizedBox.shrink(),
      // The account tab keeps its state: the language is switched from its
      // settings page, so the resident stays where the switch happened.
      _loadedTabs.contains(4)
          ? (widget.isGuest
              ? BrandGradientBackdrop.deep(
                  child: GuestGateView(
                    titleKey: AppLocaleKey.guestAccountTitle,
                    bodyKey: AppLocaleKey.guestAccountBody,
                    onSignIn: _backToLogin,
                    icon: Icons.person_outline_rounded,
                  ),
                )
              : AccountFlow(
                  homeName: homeName,
                  unitLabel: unitLabel,
                  active: _tab == 4,
                  profileCubit: _profileCubit!,
                  onRootBack: () => setState(() => _tab = 0),
                ))
          : const SizedBox.shrink(),
    ];

    final Widget shell = AnnotatedRegion<SystemUiOverlayStyle>(
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
                  onSelected: (index) => setState(() {
                    _loadedTabs.add(index);
                    _tab = index;
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // The signed-in account tab owns its own nested back navigation
    // (profile → home, sub-page → previous page), so the shell stays out of
    // its way there. Guest mode has no nested account flow.
    final bool accountOwnsBack = !widget.isGuest && _tab == 4;
    if (accountOwnsBack) return shell;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_tab != 0) {
          setState(() => _tab = 0);
          return;
        }
        // Guest mode was pushed from login: back closes the preview instead
        // of asking to exit the whole app.
        if (widget.isGuest) {
          Navigator.of(context).maybePop();
          return;
        }
        if (!await confirmExitApp(context) || !mounted) return;
        SystemNavigator.pop();
      },
      child: shell,
    );
  }
}
