import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Top bar of the intro steps: approved wordmark with an optional skip action.
/// Child order stays RTL-safe (wordmark first → starts on the reading side).
class WelcomeIntroHeader extends StatelessWidget {
  const WelcomeIntroHeader({super.key, required this.onSkip});
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Image.asset(AppImages.rounderWordmark, height: 24, fit: BoxFit.contain),
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 54, minHeight: 44),
            child: TextButton(
              onPressed: onSkip,
              child: Text(
                AppLocaleKey.skip.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.mintLight, fontSize: 14, height: 24 / 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
