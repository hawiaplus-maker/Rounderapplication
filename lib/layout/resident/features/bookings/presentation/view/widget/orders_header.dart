import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Title bar of the orders tab with links to service booking and emergency history.
class OrdersHeader extends StatelessWidget {
  const OrdersHeader({super.key, required this.onBookService, required this.onEmergencyOrders});

  final VoidCallback onBookService;
  final VoidCallback onEmergencyOrders;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: AppColors.orange),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppLocaleKey.orders.tr(),
                  style: AppTextStyles.extraBold23.copyWith(color: AppColors.white),
                ),
              ),
              FilledButton(
                onPressed: onEmergencyOrders,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.mint,
                  foregroundColor: AppColors.petrol,
                ),
                child: Text(AppLocaleKey.emergencyOrders.tr()),
              ),
            ],
          ),
          SizedBox(height: 25),
          // Align(
          //   alignment: AlignmentDirectional.centerEnd,
          //   child: TextButton.icon(
          //     onPressed: onEmergencyOrders,
          //     icon: const Icon(Icons.emergency_outlined),
          //     label: Text(AppLocaleKey.emergencyOrders.tr()),
          //     style: TextButton.styleFrom(foregroundColor: AppColors.white),
          //   ),
          // ),
        ],
      ),
    );
  }
}
