import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
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
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            Text(AppLocaleKey.serviceReport.tr(), textAlign: TextAlign.right),
            Text(
              '50 ${AppLocaleKey.currencySar.tr()}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: AppColors.orange,
              ),
            ),
            TextField(
              controller: notes,
              textAlign: TextAlign.right,
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
