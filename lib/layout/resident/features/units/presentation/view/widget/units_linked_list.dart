import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/unit_card.dart';

/// The resident's linked homes plus the "add unit" action (design 536:943).
class UnitsLinkedList extends StatelessWidget {
  const UnitsLinkedList({
    super.key,
    required this.onOpenUnit,
    required this.onAddUnit,
  });

  final VoidCallback onOpenUnit;
  final VoidCallback onAddUnit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UnitCard(
          isCurrent: true,
          name: AppLocaleKey.unitTitle.tr(),
          role: AppLocaleKey.ownerRole.tr(),
          unitNo: AppLocaleKey.unitRowPalm.tr(),
          city: AppLocaleKey.dammamCity.tr(),
          area: AppLocaleKey.areaApproved.tr(),
          currentBadge: AppLocaleKey.currentUnit.tr(),
          primaryLabel: AppLocaleKey.viewUnit.tr(),
          onPrimary: onOpenUnit,
        ),
        const SizedBox(height: 12),
        UnitCard(
          isCurrent: false,
          name: AppLocaleKey.jasmineBuilding.tr(),
          role: AppLocaleKey.tenantRole.tr(),
          unitNo: AppLocaleKey.unitRowJasmine.tr(),
          city: AppLocaleKey.khobarCity.tr(),
          area: AppLocaleKey.areaNotAdded.tr(),
          currentBadge: AppLocaleKey.otherUnit.tr(),
          primaryLabel: AppLocaleKey.viewUnit.tr(),
          onPrimary: onOpenUnit,
          secondaryLabel: AppLocaleKey.setAsCurrent.tr(),
          onSecondary: onOpenUnit,
        ),
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
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 14,
              height: 22 / 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
