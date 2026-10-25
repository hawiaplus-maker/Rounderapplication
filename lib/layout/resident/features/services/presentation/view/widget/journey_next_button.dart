import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Primary continue action of the service journey pages.
class JourneyNextButton extends StatelessWidget {
  const JourneyNextButton({
    super.key,
    required this.labelKey,
    required this.onPressed,
  });

  final String labelKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: SizedBox(
      height: 50,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
        ),
        child: Text(labelKey.tr()),
      ),
    ),
  );
}
