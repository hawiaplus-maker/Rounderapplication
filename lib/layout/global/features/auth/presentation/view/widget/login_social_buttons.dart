import 'dart:ui' as ui_direction show TextDirection;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Approved alternate sign-in block (design `Alternate sign-in / Divider` +
/// `Continue / Google` + `Continue / Apple`): divider label, white Google
/// button and black Apple button, both 46px with radius 12.
class LoginSocialButtons extends StatelessWidget {
  const LoginSocialButtons({
    super.key,
    required this.onGoogle,
    required this.onApple,
  });
  final VoidCallback onGoogle;
  final VoidCallback onApple;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: _Rule()),
            const SizedBox(width: 12),
            Text(
              AppLocaleKey.orContinueWith.tr(),
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 12,
                height: 22 / 12,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: _Rule()),
          ],
        ),
        const SizedBox(height: 8),
        _GoogleButton(onPressed: onGoogle),
        const SizedBox(height: 10),
        _AppleButton(onPressed: onApple),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 46,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.petrol,
        side: const BorderSide(color: AppColors.stroke),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        // Approved frame anchors the brand icon on the physical left in both
        // directions; the label stays centered.
        textDirection: ui_direction.TextDirection.ltr,
        children: [
          Image.asset(AppImages.googleG, width: 22, height: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocaleKey.continueWithGoogle.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 14,
                height: 26 / 14,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AppleButton extends StatelessWidget {
  const _AppleButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 46,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        textDirection: ui_direction.TextDirection.ltr,
        children: [
          SvgPicture.asset(AppImages.appleLogo, width: 22, height: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocaleKey.continueWithApple.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                height: 26 / 14,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Rule extends StatelessWidget {
  const _Rule();

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: AppColors.stroke);
}
