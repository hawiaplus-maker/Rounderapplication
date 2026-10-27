import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_next_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_select_pill.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';

/// Schedule step: service location, visit mode, date and time.
class JourneySchedulePage extends StatelessWidget {
  const JourneySchedulePage({
    super.key,
    required this.onBack,
    required this.location,
    required this.mode,
    required this.dateLabel,
    required this.timeLabel,
    required this.onLocationChanged,
    required this.onModeChanged,
    required this.onEmergency,
    required this.onPickDate,
    required this.onPickTime,
    required this.onNext,
  });

  final VoidCallback onBack;
  final String location;
  final int mode;
  final String dateLabel;
  final String timeLabel;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<int> onModeChanged;
  final VoidCallback onEmergency;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.whenService,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            Text(
              AppLocaleKey.whereService.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            const SizedBox(height: 8),
            JourneySelectPill(
              label: AppLocaleKey.myUnit.tr(),
              icon: Icons.apartment_outlined,
              selected: location == AppLocaleKey.myUnit,
              onTap: () => onLocationChanged(AppLocaleKey.myUnit),
            ),
            JourneySelectPill(
              label: AppLocaleKey.sharedFacilities.tr(),
              icon: Icons.groups_outlined,
              selected: location == AppLocaleKey.sharedFacilities,
              onTap: () => onLocationChanged(AppLocaleKey.sharedFacilities),
            ),
          ],
        ),
        JourneyPanel(
          children: [
            Text(
              AppLocaleKey.whenService.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [
                _ModeChip(
                  labelKey: AppLocaleKey.scheduled,
                  icon: Icons.calendar_month_outlined,
                  selected: mode == 0,
                  onTap: () => onModeChanged(0),
                ),
                _ModeChip(
                  labelKey: AppLocaleKey.urgent,
                  icon: Icons.schedule,
                  selected: mode == 1,
                  onTap: () => onModeChanged(1),
                ),
                _ModeChip(
                  labelKey: AppLocaleKey.emergencyMode,
                  icon: Icons.warning_amber_rounded,
                  selected: mode == 2,
                  onTap: onEmergency,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: JourneySelectPill(
                    label: dateLabel,
                    icon: Icons.calendar_today,
                    selected: false,
                    onTap: onPickDate,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: JourneySelectPill(
                    label: timeLabel,
                    icon: Icons.access_time,
                    selected: false,
                    onTap: onPickTime,
                  ),
                ),
              ],
            ),
            Text(
              AppLocaleKey.providerTiming.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
        JourneyNextButton(
          labelKey: AppLocaleKey.nextProviders,
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.labelKey,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String labelKey;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    avatar: Icon(
      icon,
      size: 17,
      color: selected ? AppColors.orange : AppColors.petrol,
    ),
    label: Text(labelKey.tr()),
    selected: selected,
    onSelected: (_) => onTap(),
    selectedColor: AppColors.mint,
    backgroundColor: Colors.white,
  );
}
