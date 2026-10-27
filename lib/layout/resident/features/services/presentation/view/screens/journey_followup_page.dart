import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_next_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_select_pill.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';

/// Follow-up step: pick the follow-up visit date and time.
class JourneyFollowupPage extends StatelessWidget {
  const JourneyFollowupPage({
    super.key,
    required this.onBack,
    required this.dateLabel,
    required this.timeLabel,
    required this.onPickDate,
    required this.onPickTime,
    required this.onRequestSent,
  });

  final VoidCallback onBack;
  final String dateLabel;
  final String timeLabel;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onRequestSent;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.followUp,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            Text(
              AppLocaleKey.technicianOnWay.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            JourneySelectPill(
              label: dateLabel,
              icon: Icons.calendar_today,
              selected: false,
              onTap: onPickDate,
            ),
            JourneySelectPill(
              label: timeLabel,
              icon: Icons.access_time,
              selected: false,
              onTap: onPickTime,
            ),
          ],
        ),
        JourneyNextButton(
          labelKey: AppLocaleKey.requestSent,
          onPressed: onRequestSent,
        ),
      ],
    );
  }
}
