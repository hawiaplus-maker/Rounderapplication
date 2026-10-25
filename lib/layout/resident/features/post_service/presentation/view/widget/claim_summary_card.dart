import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Claim summary glass card (design علي يساعدك / المشكلة · ملخص ومرفقات):
/// the reported issue title line and its summary body, with the attachment
/// row reserved for the design's follow-up states.
class ClaimSummaryCard extends StatelessWidget {
  const ClaimSummaryCard({super.key, required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.mintLight.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              body,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 14,
                height: 24 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
