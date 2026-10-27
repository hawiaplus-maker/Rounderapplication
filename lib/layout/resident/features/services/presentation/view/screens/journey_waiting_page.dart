import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_next_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_sub_page.dart';

/// Waiting step: the request was sent and a provider is being assigned.
class JourneyWaitingPage extends StatelessWidget {
  const JourneyWaitingPage({
    super.key,
    required this.onBack,
    required this.onCancel,
    required this.onAccept,
  });

  final VoidCallback onBack;
  final VoidCallback onCancel;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.waitingProvider,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            const Icon(
              Icons.hourglass_top_rounded,
              size: 42,
              color: AppColors.orange,
            ),
            Text(
              AppLocaleKey.waitingProvider.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            Text(
              AppLocaleKey.requestSent.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted),
            ),
          ],
        ),
        JourneyActionButton(
          labelKey: AppLocaleKey.cancel,
          icon: Icons.close,
          onAction: onCancel,
        ),
        JourneyNextButton(
          labelKey: AppLocaleKey.providerAccepted,
          onPressed: onAccept,
        ),
      ],
    );
  }
}
