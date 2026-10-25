import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Title bar of the orders tab with the book-service entry.
class OrdersHeader extends StatelessWidget {
  const OrdersHeader({super.key, required this.onBookService});

  final VoidCallback onBookService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_rounded, color: AppColors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLocaleKey.orders.tr(),
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
              ),
            ),
          ),
          FilledButton(
            onPressed: onBookService,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.mint,
              foregroundColor: AppColors.petrol,
            ),
            child: Text(AppLocaleKey.bookService.tr()),
          ),
        ],
      ),
    );
  }
}
