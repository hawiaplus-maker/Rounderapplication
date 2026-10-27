import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_kv.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_next_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_sub_page.dart';

/// Payment step: the total and the payment-complete actions.
class JourneyPaymentPage extends StatelessWidget {
  const JourneyPaymentPage({
    super.key,
    required this.onBack,
    required this.totalLabel,
    required this.onComplete,
    required this.onNext,
  });

  final VoidCallback onBack;
  final String totalLabel;
  final VoidCallback onComplete;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.payNow,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            Text(
              AppLocaleKey.invoice.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            JourneyKv(
              labelKey: AppLocaleKey.total,
              value: totalLabel,
            ),
            JourneyActionButton(
              labelKey: AppLocaleKey.paymentComplete,
              icon: Icons.credit_card,
              onAction: onComplete,
            ),
          ],
        ),
        JourneyNextButton(
          labelKey: AppLocaleKey.paymentComplete,
          onPressed: onNext,
        ),
      ],
    );
  }
}
