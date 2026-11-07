import 'dart:ui' as ui_direction;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.mediaUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      data.mediaUrls.first,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _iconBox(),
                    ),
                  )
                else
                  _iconBox(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.titleKey,
                        textAlign: TextAlign.start,
                        style: AppTextStyles.extraBold15.copyWith(color: AppColors.petrol),
                      ),
                      if (data.subServiceName != null &&
                          data.subServiceName!.trim().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          data.subServiceName!,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
                        ),
                      ],
                      if (data.providerName != null && data.providerName!.trim().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          data.providerName!,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodySemiBold12.copyWith(color: AppColors.teal),
                        ),
                      ],
                    ],
                  ),
                ),
                Directionality(
                  textDirection: ui_direction.TextDirection.ltr,
                  child: Icon(Icons.arrow_back_ios_new, color: AppColors.petrol),
                ),
              ],
            ),
            const Divider(height: 22),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppColors.muted),
                const SizedBox(width: 4),
                Text(
                  _formatDate(data.scheduledAt),
                  style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
                ),
                const Spacer(),
                Chip(
                  label: Text(data.statusKey.tr()),
                  backgroundColor: AppColors.mint,
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (data.amount.isNotEmpty)
                  Text(
                    '${data.amount} ${AppLocaleKey.currencySar.tr()}',
                    style: AppTextStyles.extraBold16.copyWith(color: AppColors.petrol),
                  ),
                const Spacer(),
                if (data.reference.isNotEmpty)
                  Text(
                    data.reference,
                    style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _iconBox() => Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(12)),
    child: const Icon(Icons.home_repair_service_outlined, color: AppColors.petrol),
  );

  String _formatDate(DateTime dt) {
    final String d =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final String t =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$d  $t';
  }
}
