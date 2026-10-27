import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/model/order_data.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/screen/order_details_screen.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/orders_header.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/orders_list.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/orders_tabs.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screen/service_journey_screen.dart';

/// Local orders prototype for the Figma list, detail, tracking, and cancel flows.
/// No booking or payment endpoint is called from this screen.
class OrdersPrototypeScreen extends StatelessWidget {
  const OrdersPrototypeScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PreviewOrdersCubit, List<PreviewOrder>>(
        bloc: sl<PreviewOrdersCubit>(),
        builder: (context, orders) => DefaultTabController(
          length: 4,
          child: Column(
            children: [
              OrdersHeader(onBookService: () => _openJourney(context)),
              const OrdersTabs(),
              Expanded(
                child: TabBarView(
                  children: [
                    OrdersList(
                      orders: orders.map(OrderData.fromPreview).toList(),
                      onOpen: (order) => _openDetails(context, order),
                    ),
                    OrdersList(
                      orders: orders
                          .where(
                            (order) =>
                                order.statusKey == AppLocaleKey.orderActive,
                          )
                          .map(OrderData.fromPreview)
                          .toList(),
                      onOpen: (order) => _openDetails(context, order),
                    ),
                    OrdersList(
                      orders: orders
                          .where(
                            (order) =>
                                order.statusKey == AppLocaleKey.orderScheduled,
                          )
                          .map(OrderData.fromPreview)
                          .toList(),
                      onOpen: (order) => _openDetails(context, order),
                    ),
                    OrdersList(
                      orders: orders
                          .where(
                            (order) =>
                                order.statusKey ==
                                    AppLocaleKey.serviceComplete ||
                                order.statusKey ==
                                    AppLocaleKey.requestCancelled,
                          )
                          .map(OrderData.fromPreview)
                          .toList(),
                      onOpen: (order) => _openDetails(context, order),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  void _openJourney(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(
          body: SafeArea(child: ServiceJourneyScreen()),
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, OrderData order) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OrderDetailsScreen(data: order),
      ),
    );
  }
}
