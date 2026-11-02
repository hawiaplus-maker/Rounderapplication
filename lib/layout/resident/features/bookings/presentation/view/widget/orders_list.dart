import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/bookings_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/model/order_data.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/order_card.dart';

/// Orders list for one status tab, with its empty state.
class OrdersList extends StatelessWidget {
  const OrdersList({super.key, required this.orders, required this.onOpen});

  final List<OrderData> orders;
  final ValueChanged<OrderData> onOpen;

  @override
  Widget build(BuildContext context) {
    Future<void> refresh() async {
      await context.read<BookingsCubit>().load();
    }

    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.6,
              child: Center(
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
                        style: AppTextStyles.extraBold18.copyWith(color: AppColors.petrol),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 118),
        children: orders
            .map(
              (order) => OrderCard(
                data: order,
                onTap: () => onOpen(order),
              ),
            )
            .toList(),
      ),
    );
  }
}
