import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/bookings_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/model/order_data.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/screens/order_details_screen.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/orders_header.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/orders_list.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/orders_shimmer_list.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/orders_tabs.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/orders_unit_filter.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/screens/emergency_orders_screen.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/service_journey_screen.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/homes_repo.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/selected_home_store.dart';

/// Orders screen: shows both in-session preview orders and real bookings
/// fetched from `/resident/bookings`.
class OrdersPrototypeScreen extends StatelessWidget {
  const OrdersPrototypeScreen({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => sl<PreviewOrdersCubit>()),
      BlocProvider<BookingsCubit>.value(value: sl<BookingsCubit>()..load()),
    ],
    child: const _OrdersPrototypeBody(),
  );
}

class _OrdersPrototypeBody extends StatefulWidget {
  const _OrdersPrototypeBody();

  @override
  State<_OrdersPrototypeBody> createState() => _OrdersPrototypeBodyState();
}

class _OrdersPrototypeBodyState extends State<_OrdersPrototypeBody> {
  /// Picked unit of the dropdown filter; null keeps every unit on display.
  int? _unitFilterId;

  /// The resident's saved units for the dropdown, straight from the homes
  /// repository — NOT derived from the bookings, because a unit with no
  /// bookings yet must still be pickable. Same cached source the dashboard's
  /// unit picker reads.
  List<OrdersUnitOption> _homeOptions = const <OrdersUnitOption>[];

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  /// Loads the resident's units; on failure the dropdown keeps the units
  /// seen in the loaded bookings.
  Future<void> _loadUnits() async {
    try {
      final List<ResidentHome> homes = await sl<HomesRepository>().list();
      if (!mounted) return;
      final List<OrdersUnitOption> options = [
        for (final ResidentHome home in homes)
          if (home.id != null && (home.name.trim().isNotEmpty || home.unitLabel.trim().isNotEmpty))
            OrdersUnitOption(
              id: home.id!,
              name: home.name.trim().isNotEmpty ? home.name : home.unitLabel,
            ),
      ];
      setState(() {
        _homeOptions = options;
        // The picked unit may be gone (removed while browsing) — back to
        // every unit instead of showing a silent empty list.
        if (_unitFilterId != null && !options.any((o) => o.id == _unitFilterId)) {
          _unitFilterId = null;
        }
      });
    } catch (_) {
      /* the dropdown falls back to the units seen in the bookings */
    }
  }

  /// Filter options: the saved units first, then any extra unit the bookings
  /// mention that the homes list does not cover (the fallback set when the
  /// homes fetch failed). Session preview orders have no unit, so they stay
  /// under the every-unit default only.
  List<OrdersUnitOption> _optionsFor(List<OrderData> realOrders) {
    final List<OrdersUnitOption> extras = _bookingUnitOptions(
      realOrders,
    ).where((option) => !_homeOptions.any((home) => home.id == option.id)).toList();
    return [..._homeOptions, ...extras];
  }

  /// Units present in the loaded bookings, in first-seen order.
  List<OrdersUnitOption> _bookingUnitOptions(List<OrderData> realOrders) {
    final Map<int, String> names = {
      for (final order in realOrders)
        if (order.homeId != null && (order.homeName?.trim().isNotEmpty ?? false))
          order.homeId!: order.homeName!,
    };
    return [for (final entry in names.entries) OrdersUnitOption(id: entry.key, name: entry.value)];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreviewOrdersCubit, List<PreviewOrder>>(
      builder: (context, previews) {
        return BlocBuilder<BookingsCubit, BookingsState>(
          builder: (context, bookingsState) {
            final realOrders = bookingsState is BookingsReady
                ? bookingsState.items.map(OrderData.fromBooking).toList()
                : <OrderData>[];
            final previewOrders = previews.map(OrderData.fromPreview).toList();
            final everyOrder = [...realOrders, ...previewOrders];
            final options = _optionsFor(realOrders);
            // A pick whose unit left the loaded bookings falls back to "all
            // units": the dropdown cannot hold a value it has no item for.
            final selectedUnitId = options.any((o) => o.id == _unitFilterId) ? _unitFilterId : null;
            // Unit pick first, then the per-tab status slice below.
            final unitOrders = selectedUnitId == null
                ? everyOrder
                : everyOrder.where((o) => o.homeId == selectedUnitId).toList();
            return DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  OrdersHeader(
                    onBookService: () => _openJourney(context),
                    onEmergencyOrders: () => _openEmergencyOrders(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: OrdersUnitFilter(
                      // Keyed by the pick so the field never displays a unit
                      // whose row vanished from the options (same trick the
                      // city picker in the add-unit form uses).
                      key: ValueKey(selectedUnitId),
                      options: options,
                      selectedId: selectedUnitId,
                      onChanged: (id) => setState(() => _unitFilterId = id),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.mintDeep.withAlpha(30),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const OrdersTabs(),
                  ),
                  Expanded(
                    // While `/resident/bookings` is loading the four tabs
                    // would all show their empty state — shimmer instead.
                    child: bookingsState is BookingsLoading
                        ? const OrdersShimmerList()
                        : TabBarView(
                            children: [
                              OrdersList(
                                orders: unitOrders,
                                onOpen: (order) => _openDetails(context, order),
                              ),
                              OrdersList(
                                orders: unitOrders
                                    .where((o) => o.statusKey == AppLocaleKey.orderActive)
                                    .toList(),
                                onOpen: (order) => _openDetails(context, order),
                              ),
                              OrdersList(
                                orders: unitOrders
                                    .where((o) => o.statusKey == AppLocaleKey.orderScheduled)
                                    .toList(),
                                onOpen: (order) => _openDetails(context, order),
                              ),
                              OrdersList(
                                orders: unitOrders
                                    .where(
                                      (o) =>
                                          o.statusKey == AppLocaleKey.serviceComplete ||
                                          o.statusKey == AppLocaleKey.requestCancelled,
                                    )
                                    .toList(),
                                onOpen: (order) => _openDetails(context, order),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openJourney(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: SafeArea(child: ServiceJourneyScreen())),
      ),
    );
  }

  void _openEmergencyOrders(BuildContext context) {
    final dashboardState = context.read<ResidentDashboardCubit>().state;
    // The unit picked on the dashboard's selector leads the request; without
    // a pick the dashboard's own home is used.
    final homeId =
        sl<SelectedHomeStore>().readId() ??
        (dashboardState is DashboardReady ? dashboardState.data.homeId : null);
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => EmergencyOrdersScreen(residentHomeId: homeId)));
  }

  void _openDetails(BuildContext context, OrderData order) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => OrderDetailsScreen(data: order)));
  }
}
