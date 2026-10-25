import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/post_service/presentation/view/widget/aftercare_action_button.dart';
import 'package:rounder_application/layout/resident/features/post_service/presentation/view/widget/claim_summary_card.dart';

/// Ali-assisted warranty claim page of the after-service journey.
class ClaimPageBody extends StatelessWidget {
  const ClaimPageBody({
    super.key,
    required this.onViewOriginalDoc,
    required this.onSubmitForReview,
  });

  final VoidCallback onViewOriginalDoc;
  final VoidCallback onSubmitForReview;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClaimSummaryCard(
          title: AppLocaleKey.claimSummaryTitle.tr(),
          body: AppLocaleKey.claimSummaryBody.tr(),
        ),
        const SizedBox(height: 12),
        // Design original-documentation entry stays local here: it returns to
        // the order details (the evaluating context that opened this journey).
        AftercareActionButton(
          label: AppLocaleKey.viewOriginalDoc.tr(),
          fill: AppColors.mintLight,
          onPressed: onViewOriginalDoc,
        ),
        const SizedBox(height: 10),
        Text(
          AppLocaleKey.claimCoverageNote.tr(),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.white.withValues(alpha: .85),
            fontSize: 13,
            height: 22 / 13,
          ),
        ),
        const SizedBox(height: 12),
        AftercareActionButton(
          label: AppLocaleKey.submitForReview.tr(),
          fill: AppColors.coral,
          onPressed: onSubmitForReview,
        ),
      ],
    );
  }
}
