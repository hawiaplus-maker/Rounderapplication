import 'dart:ui' show ImageFilter;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_legal_links.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_phone_entry.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_social_buttons.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_action.dart';

/// Approved frosted form (design `Login / Frosted form`): white 80% panel with
/// a 24px backdrop blur, welcome copy, phone entry, the coral continue action,
/// the social block and the legal row. Content hugs its padding and the panel
/// keeps a 510px minimum height so other locales can grow instead of clipping.
class LoginFormCard extends StatelessWidget {
  const LoginFormCard({
    super.key,
    required this.phoneController,
    required this.onContinue,
    required this.onGoogle,
    required this.onApple,
    this.phoneError,
  });
  final TextEditingController phoneController;
  final String? phoneError;
  final VoidCallback onContinue;
  final VoidCallback onGoogle;
  final VoidCallback onApple;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          constraints: const BoxConstraints(minHeight: 510),
          padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 6),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: .8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.white.withValues(alpha: .94)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocaleKey.loginGreeting.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.petrol,
                  fontSize: 32,
                  height: 44 / 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                AppLocaleKey.loginTagline.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.petrol, fontSize: 16, height: 24 / 16),
              ),
              const SizedBox(height: 24),
              LoginPhoneEntry(
                controller: phoneController,
                errorText: phoneError,
                onContinue: onContinue,
              ),
              const SizedBox(height: 24),
              OtpAction(
                label: AppLocaleKey.continueWithPhone.tr(),
                fill: AppColors.coral,
                height: 54,
                radius: 12,
                labelSize: 20,
                labelLineHeight: 32,
                onPressed: onContinue,
              ),
              const SizedBox(height: 16),
              LoginSocialButtons(onGoogle: onGoogle, onApple: onApple),
              const SizedBox(height: 12),
              // Not const: the labels follow the active locale at runtime.
              LoginLegalLinks(),
            ],
          ),
        ),
      ),
    );
  }
}
