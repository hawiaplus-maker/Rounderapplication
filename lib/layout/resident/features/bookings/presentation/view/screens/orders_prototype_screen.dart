import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/bookings_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/model/order_data.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/screens/order_details_screen.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/orders_header.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/orders_list.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/orders_tabs.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/service_journey_screen.dart';

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

class _OrdersPrototypeBody extends StatelessWidget {
  const _OrdersPrototypeBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreviewOrdersCubit, List<PreviewOrder>>(
      builder: (context, previews) {
        return BlocBuilder<BookingsCubit, BookingsState>(
          builder: (context, bookingsState) {
            final realOrders = bookingsState is BookingsReady
                ? bookingsState.items.map(OrderData.fromBooking).toList()
                : <OrderData>[];
            final previewOrders =
                previews.map(OrderData.fromPreview).toList();
            final all = [...realOrders, ...previewOrders];
            return DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  OrdersHeader(onBookService: () => _openJourney(context)),
                  const OrdersTabs(),
                  Expanded(
                    child: TabBarView(
                      children: [
                        OrdersList(
                          orders: all,
                          onOpen: (order) => _openDetails(context, order),
                        ),
                        OrdersList(
                          orders: all
                              .where((o) => o.statusKey == AppLocaleKey.orderActive)
                              .toList(),
                          onOpen: (order) => _openDetails(context, order),
                        ),
                        OrdersList(
                          orders: all
                              .where((o) => o.statusKey == AppLocaleKey.orderScheduled)
                              .toList(),
                          onOpen: (order) => _openDetails(context, order),
                        ),
                        OrdersList(
                          orders: all
                              .where((o) =>
                                  o.statusKey == AppLocaleKey.serviceComplete ||
                                  o.statusKey == AppLocaleKey.requestCancelled)
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
        builder: (_) =>
            const Scaffold(body: SafeArea(child: ServiceJourneyScreen())),
      ),
    );
  }

  void _openDetails(BuildContext context, OrderData order) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => OrderDetailsScreen(data: order)),
    );
  }
}
