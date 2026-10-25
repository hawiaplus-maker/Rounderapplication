import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_next_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_sub_page.dart';

/// Tracking step: live order status, technician actions and work files.
class JourneyTrackingPage extends StatelessWidget {
  const JourneyTrackingPage({
    super.key,
    required this.onBack,
    required this.stage,
    required this.reference,
    required this.providerLabel,
    required this.onChat,
    required this.onCall,
    required this.onFiles,
    required this.onAdditional,
    required this.onAdvance,
    required this.onReport,
  });

  final VoidCallback onBack;
  final int stage;
  final String? reference;
  final String providerLabel;
  final VoidCallback onChat;
  final VoidCallback onCall;
  final VoidCallback onFiles;
  final VoidCallback onAdditional;
  final VoidCallback onAdvance;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final statusKey = switch (stage) {
      0 => AppLocaleKey.providerAccepted,
      1 => AppLocaleKey.technicianOnWay,
      2 => AppLocaleKey.serviceInProgress,
      _ => AppLocaleKey.serviceComplete,
    };
    return JourneySubPage(
      titleKey: stage < 2
          ? AppLocaleKey.technicianOnWay
          : AppLocaleKey.serviceInProgress,
      onBack: onBack,
      children: [
        JourneyPanel(
          glass: true,
          children: [
            Text(
              '${AppLocaleKey.orderReference.tr()} • ${reference ?? '—'}',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              statusKey.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: (stage + 1) / 4,
              color: AppColors.orange,
              backgroundColor: Colors.white24,
              minHeight: 8,
            ),
            const SizedBox(height: 10),
            Text(
              AppLocaleKey.providerTiming.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        JourneyPanel(
          children: [
            Text(
              providerLabel,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: JourneyActionButton(
                    labelKey: AppLocaleKey.chat,
                    icon: Icons.chat_bubble_outline,
                    onAction: onChat,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: JourneyActionButton(
                    labelKey: AppLocaleKey.callTechnician,
                    icon: Icons.call_outlined,
                    onAction: onCall,
                  ),
                ),
              ],
            ),
          ],
        ),
        JourneyActionButton(
          labelKey: AppLocaleKey.serviceFiles,
          icon: Icons.photo_library_outlined,
          onAction: onFiles,
        ),
        JourneyActionButton(
          labelKey: AppLocaleKey.addWork,
          icon: Icons.add_circle_outline,
          onAction: onAdditional,
        ),
        if (stage < 3)
          JourneyNextButton(
            labelKey: AppLocaleKey.serviceInProgress,
            onPressed: onAdvance,
          )
        else
          JourneyNextButton(
            labelKey: AppLocaleKey.serviceReport,
            onPressed: onReport,
          ),
      ],
    );
  }
}
