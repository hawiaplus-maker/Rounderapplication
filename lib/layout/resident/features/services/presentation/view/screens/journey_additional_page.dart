import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';

/// Additional-work offer step.
class JourneyAdditionalPage extends StatelessWidget {
  const JourneyAdditionalPage({
    super.key,
    required this.onBack,
    required this.notes,
    required this.onApprove,
    required this.onDecline,
  });

  final VoidCallback onBack;
  final TextEditingController notes;
  final VoidCallback onApprove;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.additionalOffer,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            Text(
              AppLocaleKey.additionalOffer.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.extraBold20.copyWith(color: AppColors.petrol),
            ),
            Text(AppLocaleKey.serviceReport.tr(), textAlign: TextAlign.start),
            Text(
              '0 ${AppLocaleKey.currencySar.tr()}',
              textAlign: TextAlign.start,
              style: AppTextStyles.extraBold21.copyWith(color: AppColors.orange),
            ),
            TextField(
              controller: notes,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: AppLocaleKey.ratingNote.tr(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: onApprove,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.orange,
                ),
                child: Text(AppLocaleKey.approveOffer.tr()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: onDecline,
                child: Text(AppLocaleKey.declineOffer.tr()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
