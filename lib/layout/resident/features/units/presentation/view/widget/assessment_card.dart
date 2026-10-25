import 'package:flutter/material.dart';
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
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 18,
              height: 28 / 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            score,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 48,
              height: 64 / 48,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summaryTitle,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 15,
              height: 22 / 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            residentialLine,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 16,
              height: 32 / 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            facilitiesLine,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 16,
              height: 32 / 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            pendingNote,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.teal,
              fontSize: 14,
              height: 24 / 14,
            ),
          ),
        ],
      ),
    );
  }
}
