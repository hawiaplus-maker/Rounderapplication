import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';

/// Waiting step: the request was sent and a provider is being assigned.
class JourneyWaitingPage extends StatelessWidget {
  const JourneyWaitingPage({
    super.key,
    required this.onBack,
    required this.onCancel,
    required this.onAccept,
    required this.onServices,
  });

  final VoidCallback onBack;
  final VoidCallback onCancel;
  final VoidCallback onAccept;
  final VoidCallback onServices;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.waitingProvider,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            const Icon(Icons.hourglass_top_rounded, size: 42, color: AppColors.orange),
            Text(
              AppLocaleKey.waitingProvider.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.extraBold20.copyWith(color: AppColors.petrol),
            ),
            Text(
              AppLocaleKey.requestSent.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
            ),
          ],
        ),
        JourneyActionButton(labelKey: AppLocaleKey.cancel, icon: Icons.close, onAction: onCancel),
        JourneyActionButton(
          labelKey: AppLocaleKey.services,
          icon: Icons.home_repair_service_outlined,
          onAction: onServices,
        ),
        // JourneyNextButton(
        //   labelKey: AppLocaleKey.providerAccepted,
        //   onPressed: onAccept,
        // ),
      ],
    );
  }
}
