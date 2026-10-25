import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Title bar shared by all association pages.
class UnionHeader extends StatelessWidget {
  const UnionHeader({
    super.key,
    required this.titleKey,
    this.onBack,
    this.showBack = false,
  }) : assert(!showBack || onBack != null);

  final String titleKey;
  final VoidCallback? onBack;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left, color: AppColors.white),
            )
          else
            const SizedBox(width: 8),
          const Spacer(),
          Text(
            titleKey.tr(),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          if (!showBack) const Icon(Icons.apartment, color: AppColors.white),
        ],
      ),
    );
  }
}
