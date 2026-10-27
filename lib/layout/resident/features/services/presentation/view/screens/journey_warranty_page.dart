import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_kv.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_next_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_sub_page.dart';

/// Warranty step after a completed service.
class JourneyWarrantyPage extends StatelessWidget {
  const JourneyWarrantyPage({
    super.key,
    required this.onBack,
    required this.onFollowUp,
    required this.onHome,
  });

  final VoidCallback onBack;
  final VoidCallback onFollowUp;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.warranty,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            const Icon(
              Icons.verified_user_outlined,
              size: 42,
              color: AppColors.petrol,
            ),
            Text(
              AppLocaleKey.warranty.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            Text(
              AppLocaleKey.serviceComplete.tr(),
              textAlign: TextAlign.right,
            ),
            JourneyKv(
              labelKey: AppLocaleKey.followUp,
              value: AppLocaleKey.days30.tr(),
            ),
          ],
        ),
        JourneyActionButton(
          labelKey: AppLocaleKey.followUp,
          icon: Icons.event_available_outlined,
          onAction: onFollowUp,
        ),
        JourneyNextButton(
          labelKey: AppLocaleKey.home,
          onPressed: onHome,
        ),
      ],
    );
  }
}
