import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Label/value row of the service journey summaries.
class JourneyKv extends StatelessWidget {
  const JourneyKv({super.key, required this.labelKey, required this.value});

  final String labelKey;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.petrol,
            ),
          ),
        ),
        const Spacer(),
        Text(
          labelKey.tr(),
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    ),
  );
}
