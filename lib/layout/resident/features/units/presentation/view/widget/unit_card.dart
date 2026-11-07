import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// One linked-unit card (design current / other unit cards): the mint badge
/// on the current card, building name + role, unit-number / city / area guide
/// rows, then the action pills on the reading start side.
class UnitCard extends StatelessWidget {
  const UnitCard({
    super.key,
    required this.isCurrent,
    required this.name,
    required this.role,
    required this.unitNo,
    required this.city,
    required this.area,
    required this.currentBadge,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryIcon,
    this.secondaryDestructive = false,
    this.busy = false,
  });

  final bool isCurrent;
  final String name;
  final String role;
  final String unitNo;
  final String city;
  final String area;
  final String currentBadge;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  /// The delete pill's leading icon (home for an action, trash for removal).
  final IconData? secondaryIcon;

  /// Tints the secondary pill as a destructive (removal) action.
  final bool secondaryDestructive;

  /// While an action is in flight the pills turn inert and the delete
  /// (secondary) pill spins in place.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCurrent
              ? AppColors.teal.withValues(alpha: .5)
              : AppColors.white,
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                name,
                textAlign: TextAlign.start,
                style: AppTextStyles.headingBold22.copyWith(
                  color: AppColors.petrol,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isCurrent ? AppColors.mintLight : AppColors.sand,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isCurrent ? currentBadge : role,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.captionBold.copyWith(
                    color: AppColors.teal,
                    height: 18 / 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (isCurrent)
            Text(
              role,
              textAlign: TextAlign.start,
              style: AppTextStyles.bodyBold14.copyWith(
                color: AppColors.teal,
                height: 20 / 14,
              ),
            ),
          const SizedBox(height: 6),
          if (unitNo.trim().isNotEmpty) _SpecRow(value: unitNo),
          if (city.trim().isNotEmpty) _SpecRow(value: city),
          if (area.trim().isNotEmpty) _SpecRow(value: area, small: true),
          const Divider(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (secondaryLabel != null)
                _Pill(
                  label: secondaryLabel!,
                  fill: secondaryDestructive
                      ? AppColors.emergencyWash
                      : AppColors.mintLight,
                  icon: secondaryIcon ?? Icons.home_outlined,
                  tint: secondaryDestructive ? AppColors.emergency : null,
                  busy: busy,
                  onTap: busy ? null : onSecondary,
                ),
              _Pill(
                label: primaryLabel,
                fill: isCurrent ? AppColors.coral : AppColors.sand,
                onTap: busy ? null : onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.value, this.small = false});

  final String value;
  final bool small;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Text(
      value,
      textAlign: TextAlign.start,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.muted,
        height: small ? 18 / 12 : 22 / 14,
      ),
    ),
  );
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.fill,
    required this.onTap,
    this.icon,
    this.tint,
    this.busy = false,
  });

  final String label;
  final Color fill;
  final VoidCallback? onTap;
  final IconData? icon;

  /// The pill's text/icon color when it deviates from the petroleum default.
  final Color? tint;

  /// A spinner in place of the icon while the pill's action is in flight.
  final bool busy;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (busy)
            SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: tint ?? AppColors.petrol,
              ),
            )
          else if (icon != null) ...[
            Icon(icon, size: 16, color: tint ?? AppColors.petrol),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.captionBold13.copyWith(
                color: tint ?? AppColors.petrol,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
