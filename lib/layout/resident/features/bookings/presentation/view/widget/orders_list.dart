import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/model/order_data.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/order_card.dart';

/// Orders list for one status tab, with its empty state.
class OrdersList extends StatelessWidget {
  const OrdersList({super.key, required this.orders, required this.onOpen});

  final List<OrderData> orders;
  final ValueChanged<OrderData> onOpen;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 54,
                color: AppColors.petrol,
              ),
              const SizedBox(height: 14),
              Text(
                AppLocaleKey.noOrdersYet.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.petrol,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 118),
      children: orders
          .map(
            (order) => OrderCard(
              data: order,
              onTap: () => onOpen(order),
            ),
          )
          .toList(),
    );
  }
}
