import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Confirmation state shown after cancelling an order.
class OrderCancelResult extends StatelessWidget {
  const OrderCancelResult({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.mint,
            child: Icon(
              Icons.check_rounded,
              size: 42,
              color: AppColors.petrol,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            AppLocaleKey.bookingCancelled.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onClose,
            child: Text(AppLocaleKey.close.tr()),
          ),
        ],
      ),
    ),
  );
}
