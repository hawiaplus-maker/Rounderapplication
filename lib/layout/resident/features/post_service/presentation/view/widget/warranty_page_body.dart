import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/post_service/presentation/view/widget/aftercare_action_button.dart';
import 'package:rounder_application/layout/resident/features/post_service/presentation/view/widget/warranty_coverage_card.dart';
import 'package:rounder_application/layout/resident/features/post_service/presentation/view/widget/warranty_summary_card.dart';

/// Warranty summary page of the after-service journey.
class WarrantyPageBody extends StatelessWidget {
  const WarrantyPageBody({
    super.key,
    required this.onBackToOrder,
    required this.onWarrantyInquiry,
  });

  final VoidCallback onBackToOrder;
  final VoidCallback onWarrantyInquiry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WarrantySummaryCard(),
        const SizedBox(height: 12),
        const WarrantyCoverageCard(),
        const SizedBox(height: 16),
        AftercareActionButton(
          label: AppLocaleKey.backToOrder.tr(),
          fill: AppColors.coral,
          onPressed: onBackToOrder,
        ),
        const SizedBox(height: 12),
        AftercareActionButton(
          label: AppLocaleKey.warrantyInquiry.tr(),
          fill: AppColors.mintLight,
          onPressed: onWarrantyInquiry,
        ),
      ],
    );
  }
}
