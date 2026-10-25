import 'package:flutter/material.dart';
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
                style: const TextStyle(
                  color: AppColors.petrol,
                  fontSize: 22,
                  height: 32 / 22,
                  fontWeight: FontWeight.w700,
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
                  style: const TextStyle(
                    color: AppColors.teal,
                    fontSize: 12,
                    height: 18 / 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            role,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.teal,
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _SpecRow(value: unitNo),
          _SpecRow(value: city),
          _SpecRow(value: area, small: true),
          const Divider(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (secondaryLabel != null)
                _Pill(
                  label: secondaryLabel!,
                  fill: AppColors.mintLight,
                  icon: Icons.home_outlined,
                  onTap: onSecondary,
                ),
              _Pill(
                label: primaryLabel,
                fill: isCurrent ? AppColors.coral : AppColors.sand,
                onTap: onPrimary,
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
      style: TextStyle(
        color: AppColors.muted,
        fontSize: small ? 12 : 14,
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
  });

  final String label;
  final Color fill;
  final VoidCallback? onTap;
  final IconData? icon;

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
          if (icon != null) ...[
            Icon(icon, size: 16, color: AppColors.petrol),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 13,
                height: 20 / 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
