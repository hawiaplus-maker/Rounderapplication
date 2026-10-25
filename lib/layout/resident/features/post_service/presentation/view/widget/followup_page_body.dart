import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/post_service/presentation/view/widget/aftercare_action_button.dart';

/// Remedy follow-up steps page of the after-service journey.
class FollowupPageBody extends StatelessWidget {
  const FollowupPageBody({super.key, required this.onBackToOrder});

  final VoidCallback onBackToOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepRow(label: AppLocaleKey.requestSent.tr(), done: true),
          _StepRow(label: AppLocaleKey.providerAccepted.tr(), done: true),
          _StepRow(label: AppLocaleKey.technicianOnWay.tr(), done: false),
          _StepRow(label: AppLocaleKey.serviceComplete.tr(), done: false),
          const SizedBox(height: 14),
          AftercareActionButton(
            label: AppLocaleKey.backToOrder.tr(),
            fill: AppColors.coral,
            onPressed: onBackToOrder,
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18,
            color: done ? AppColors.teal : AppColors.muted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: done ? AppColors.petrol : AppColors.muted,
                fontSize: 14,
                height: 22 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
