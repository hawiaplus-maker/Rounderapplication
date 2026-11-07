import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/constants/display_placeholder.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/unit_card.dart';
import 'package:rounder_application/logic/number_text_logic.dart';

/// The resident's linked homes plus the "add unit" action (design 536:943):
/// the current home first, then the remaining homes under their section
/// label. Each card carries the remove action of `DELETE /resident/homes/{id}`.
class UnitsLinkedList extends StatelessWidget {
  const UnitsLinkedList({
    super.key,
    required this.homes,
    required this.onOpenUnit,
    required this.onAddUnit,
    required this.onDeleteUnit,
    this.busyId,
  });

  final List<ResidentHome> homes;
  final ValueChanged<ResidentHome> onOpenUnit;
  final ValueChanged<ResidentHome> onDeleteUnit;
  final VoidCallback onAddUnit;

  /// The unit whose deletion is in flight: its card's pills turn inert.
  final int? busyId;

  @override
  Widget build(BuildContext context) {
    final ResidentHome current = homes.firstWhere(
      (ResidentHome home) => home.isPrimary,
      orElse: () => homes.first,
    );
    final List<ResidentHome> others = homes
        .where((ResidentHome home) => home != current)
        .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HomeCard(
          home: current,
          isCurrent: true,
          busy: busyId != null && current.id == busyId,
          onOpen: () => onOpenUnit(current),
          onDelete: () => onDeleteUnit(current),
        ),
        if (others.isNotEmpty) ...[
          const SizedBox(height: 18),
          Text(
            AppLocaleKey.otherUnit.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.headingH4.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 10),
          for (final ResidentHome home in others) ...[
            _HomeCard(
              home: home,
              busy: busyId != null && home.id == busyId,
              onOpen: () => onOpenUnit(home),
              onDelete: () => onDeleteUnit(home),
            ),
            const SizedBox(height: 12),
          ],
        ],
        const SizedBox(height: 18),
        FilledButton(
          onPressed: onAddUnit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.coral,
            foregroundColor: AppColors.petrol,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            AppLocaleKey.unitsAddUnit.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBold14.copyWith(color: AppColors.petrol),
          ),
        ),
      ],
    );
  }
}

/// One model row as the design's unit card: the reading labels are composed
/// here so the card itself stays a presentation widget.
class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.home,
    required this.onOpen,
    required this.onDelete,
    this.isCurrent = false,
    this.busy = false,
  });

  final ResidentHome home;
  final VoidCallback onOpen;
  final VoidCallback onDelete;
  final bool isCurrent;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final String language = Localizations.localeOf(context).languageCode;
    final String unit = home.unitLabel.trim();
    return UnitCard(
      isCurrent: isCurrent,
      busy: busy,
      name: home.name.isEmpty ? DisplayPlaceholder.text : home.name,
      role: (home.isOwner ? AppLocaleKey.ownerRole : AppLocaleKey.tenantRole)
          .tr(),
      unitNo: unit.isEmpty
          ? DisplayPlaceholder.text
          : '${AppLocaleKey.homeUnitWord.tr()} '
                '${localizedNumericText(unit, language)}',
      city: home.city.isEmpty ? DisplayPlaceholder.text : home.city,
      area: home.hasArea
          ? AppLocaleKey.areaApprovedValue.tr(
              namedArgs: {'area': localizedNumber(home.area!, language)},
            )
          : '',
      currentBadge: AppLocaleKey.currentUnit.tr(),
      primaryLabel: AppLocaleKey.viewUnit.tr(),
      onPrimary: onOpen,
      secondaryLabel: AppLocaleKey.deleteUnit.tr(),
      secondaryIcon: Icons.delete_outline,
      secondaryDestructive: true,
      onSecondary: onDelete,
    );
  }
}
