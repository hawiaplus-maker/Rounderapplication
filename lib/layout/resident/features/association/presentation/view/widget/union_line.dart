import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Label/value row used in association lists.
class UnionLine extends StatelessWidget {
  const UnionLine({super.key, required this.titleKey, required this.value});

  final String titleKey;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.white,
      contentPadding: EdgeInsets.zero,
      title: Text(
        titleKey.tr(),
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.petrol,
        ),
      ),
      subtitle: Text(
        value,
        textAlign: TextAlign.right,
        style: const TextStyle(color: AppColors.muted),
      ),
    );
  }
}
