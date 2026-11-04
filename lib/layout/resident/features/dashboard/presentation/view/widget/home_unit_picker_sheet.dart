import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';

/// Unit picker opened from the dashboard's unit selector arrow: one row per
/// saved home with the locally picked one marked. Returns the picked home —
/// null when dismissed.
Future<ResidentHome?> showHomeUnitPicker(
  BuildContext context, {
  required List<ResidentHome> homes,
  int? selectedId,
}) =>
    showModalBottomSheet<ResidentHome>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocaleKey.myUnit.tr(),
                textAlign: TextAlign.start,
                style: AppTextStyles.extraBold20.copyWith(color: AppColors.petrol),
              ),
              const SizedBox(height: 8),
              if (homes.isEmpty)
                Text(
                  AppLocaleKey.unitsEmptyBody.tr(),
                  textAlign: TextAlign.start,
                  style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
                )
              else
                ...homes.map((home) {
                  final String title = home.name.trim().isNotEmpty
                      ? home.name.trim()
                      : (home.unitLabel.trim().isNotEmpty
                          ? home.unitLabel.trim()
                          : AppLocaleKey.myUnit.tr());
                  final String subtitle = [
                    home.address,
                    home.district,
                    home.city,
                  ].where((s) => s.trim().isNotEmpty).join(', ');
                  final bool selected =
                      selectedId != null && home.id == selectedId;
                  return ListTile(
                    leading: Icon(
                      selected ? Icons.check_circle : Icons.apartment_outlined,
                      color: selected ? AppColors.petrol : AppColors.orange,
                    ),
                    title: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: subtitle.trim().isEmpty
                        ? null
                        : Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                    onTap: home.id == null
                        ? null
                        : () => Navigator.pop(sheetContext, home),
                  );
                }),
            ],
          ),
        ),
      ),
    );
