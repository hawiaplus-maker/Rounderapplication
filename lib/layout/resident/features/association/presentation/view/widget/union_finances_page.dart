import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_line.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_panel.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_sub_page.dart';

/// Association finances page: balance, expense split and payment history.
class UnionFinancesPage extends StatelessWidget {
  const UnionFinancesPage({
    super.key,
    required this.onBack,
    required this.onComingSoon,
  });

  final VoidCallback onBack;
  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    return UnionSubPage(
      titleKey: AppLocaleKey.associationFinance,
      onBack: onBack,
      children: [
        UnionPanel(
          glass: true,
          children: [
            Text(
              AppLocaleKey.availableBalance.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              '25,000 ${AppLocaleKey.currencySar.tr()}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Stat(
                  labelKey: AppLocaleKey.cleaning,
                  value: '1,000',
                  dot: AppColors.petrol,
                ),
                _Stat(
                  labelKey: AppLocaleKey.maintenance,
                  value: '2,500',
                  dot: AppColors.orange,
                ),
                _Stat(
                  labelKey: AppLocaleKey.utilities,
                  value: '2,500',
                  dot: AppColors.mint,
                ),
              ],
            ),
          ],
        ),
        UnionPanel(
          children: [
            Text(
              AppLocaleKey.expenses.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            const SizedBox(height: 8),
            const LinearProgressIndicator(
              value: .7,
              minHeight: 12,
              color: AppColors.petrol,
              backgroundColor: AppColors.mint,
            ),
            const SizedBox(height: 12),
            UnionLine(
              titleKey: AppLocaleKey.cleaning,
              value: '3,500 ${AppLocaleKey.currencySar.tr()}',
            ),
            UnionLine(
              titleKey: AppLocaleKey.maintenance,
              value: '2,500 ${AppLocaleKey.currencySar.tr()}',
            ),
            UnionLine(
              titleKey: AppLocaleKey.utilities,
              value: '1,000 ${AppLocaleKey.currencySar.tr()}',
            ),
          ],
        ),
        UnionPanel(
          children: [
            Text(
              AppLocaleKey.paymentHistory.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            UnionLine(
              titleKey: AppLocaleKey.cleaning,
              value: AppLocaleKey.pastCleaningPayment.tr(),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FilledButton(
            onPressed: onComingSoon,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.orange,
            ),
            child: Text(AppLocaleKey.financialDetails.tr()),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.labelKey,
    required this.value,
    required this.dot,
  });

  final String labelKey;
  final String value;
  final Color dot;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(Icons.circle, size: 9, color: dot),
      const SizedBox(height: 5),
      Text(
        labelKey.tr(),
        style: const TextStyle(color: Colors.white70, fontSize: 11),
      ),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
