import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_kv.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_next_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_sub_page.dart';

/// Review step: service, provider, schedule and amount summary.
class JourneyReviewPage extends StatelessWidget {
  const JourneyReviewPage({
    super.key,
    required this.onBack,
    required this.serviceKey,
    required this.problemText,
    required this.providerKey,
    required this.dateTimeLabel,
    required this.locationLabel,
    required this.basePriceLabel,
    required this.totalLabel,
    required this.onSummary,
    required this.onSubmit,
  });

  final VoidCallback onBack;
  final String serviceKey;
  final String problemText;
  final String providerKey;
  final String dateTimeLabel;
  final String locationLabel;
  final String basePriceLabel;
  final String totalLabel;
  final VoidCallback onSummary;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.reviewRequest,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            Text(
              serviceKey.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            Text(
              problemText.isEmpty
                  ? AppLocaleKey.problemHint.tr()
                  : problemText,
              textAlign: TextAlign.right,
            ),
            const Divider(height: 24),
            JourneyKv(
              labelKey: providerKey,
              value: dateTimeLabel,
            ),
            JourneyKv(
              labelKey: AppLocaleKey.orderPlace,
              value: locationLabel,
            ),
            JourneyKv(
              labelKey: AppLocaleKey.basePrice,
              value: basePriceLabel,
            ),
            JourneyKv(
              labelKey: AppLocaleKey.total,
              value: totalLabel,
            ),
          ],
        ),
        JourneyActionButton(
          labelKey: AppLocaleKey.serviceSummary,
          icon: Icons.receipt_long_outlined,
          onAction: onSummary,
        ),
        JourneyNextButton(
          labelKey: AppLocaleKey.submitRequest,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}
