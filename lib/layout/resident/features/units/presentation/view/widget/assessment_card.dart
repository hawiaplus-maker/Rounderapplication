import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// The property assessment glass card (design تقييم العقار / Content):
/// unit line, large score, condition summary lines and the pending note.
/// Pure display widget — all strings arrive translated from the screen.
class AssessmentCard extends StatelessWidget {
  const AssessmentCard({
    super.key,
    required this.unitLine,
    required this.score,
    required this.summaryTitle,
    required this.residentialLine,
    required this.facilitiesLine,
    required this.pendingNote,
  });

  final String unitLine;
  final String score;
  final String summaryTitle;
  final String residentialLine;
  final String facilitiesLine;
  final String pendingNote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.teal.withValues(alpha: .4),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            unitLine,
            textAlign: TextAlign.start,
            style: AppTextStyles.headingH3.copyWith(color: AppColors.petrol),
          ),
          const SizedBox(height: 8),
          Text(
            score,
            textAlign: TextAlign.start,
            style: AppTextStyles.displayBold48.copyWith(color: AppColors.petrol, height: 64 / 48),
          ),
          const SizedBox(height: 8),
          Text(
            summaryTitle,
            textAlign: TextAlign.start,
            style: AppTextStyles.bodyRegular15.copyWith(color: AppColors.petrol, height: 22 / 15),
          ),
          const SizedBox(height: 8),
          Text(
            residentialLine,
            textAlign: TextAlign.start,
            style: AppTextStyles.medium16.copyWith(color: AppColors.petrol, height: 32 / 16),
          ),
          Text(
            facilitiesLine,
            textAlign: TextAlign.start,
            style: AppTextStyles.medium16.copyWith(color: AppColors.petrol, height: 32 / 16),
          ),
          const SizedBox(height: 10),
          Text(
            pendingNote,
            textAlign: TextAlign.start,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal, height: 24 / 14),
          ),
        ],
      ),
    );
  }
}
