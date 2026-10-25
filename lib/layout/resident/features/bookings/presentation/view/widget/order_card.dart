import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/model/order_data.dart';

/// Summary card of one order in the orders list.
class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.data, required this.onTap});

  final OrderData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    color: AppColors.white.withValues(alpha: .95),
    margin: const EdgeInsets.only(bottom: 13),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.mint,
                  child: Icon(data.icon, color: AppColors.petrol),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        data.titleKey.tr(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.petrol,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.locationKey.tr(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_left, color: AppColors.petrol),
              ],
            ),
            const Divider(height: 22),
            Row(
              children: [
                Text(
                  data.reference,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(data.statusKey.tr()),
                  backgroundColor: AppColors.mint,
                  side: BorderSide.none,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${data.amount} ${AppLocaleKey.currencySar.tr()}',
                  style: const TextStyle(
                    color: AppColors.petrol,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Text(
                  AppLocaleKey.orderDetails.tr(),
                  style: const TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
