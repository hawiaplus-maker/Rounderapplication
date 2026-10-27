import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_kv.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_next_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_sub_page.dart';

/// Invoice step: completed order, amounts and receipt/payment actions.
class JourneyInvoicePage extends StatelessWidget {
  const JourneyInvoicePage({
    super.key,
    required this.onBack,
    required this.reference,
    required this.basePriceLabel,
    required this.acceptedAdditional,
    required this.totalLabel,
    required this.onConfirmReceipt,
    required this.onPay,
    required this.onProof,
  });

  final VoidCallback onBack;
  final String? reference;
  final String basePriceLabel;
  final bool acceptedAdditional;
  final String totalLabel;
  final VoidCallback onConfirmReceipt;
  final VoidCallback onPay;
  final VoidCallback onProof;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.invoice,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            Text(
              '${AppLocaleKey.orderReference.tr()} • ${reference ?? '—'}',
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted),
            ),
            Text(
              AppLocaleKey.serviceComplete.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            JourneyKv(
              labelKey: AppLocaleKey.basePrice,
              value: basePriceLabel,
            ),
            if (acceptedAdditional)
              JourneyKv(
                labelKey: AppLocaleKey.addWork,
                value: '50 ${AppLocaleKey.currencySar.tr()}',
              ),
            const Divider(),
            JourneyKv(
              labelKey: AppLocaleKey.total,
              value: totalLabel,
            ),
            Text(
              AppLocaleKey.warranty.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted),
            ),
          ],
        ),
        JourneyNextButton(
          labelKey: AppLocaleKey.confirmReceipt,
          onPressed: onConfirmReceipt,
        ),
        JourneyActionButton(
          labelKey: AppLocaleKey.payNow,
          icon: Icons.payments_outlined,
          onAction: onPay,
        ),
        JourneyActionButton(
          labelKey: AppLocaleKey.proofOfWork,
          icon: Icons.description_outlined,
          onAction: onProof,
        ),
      ],
    );
  }
}
