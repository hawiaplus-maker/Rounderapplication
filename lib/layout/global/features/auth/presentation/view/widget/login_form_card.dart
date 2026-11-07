import 'dart:ui' show ImageFilter;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_legal_links.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_phone_entry.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_social_buttons.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_action.dart';

/// Social sign-in is still the approved design prototype: no OAuth SDK is
/// wired yet, so the buttons are hidden from release builds to keep a fake
/// success flow out of App Review. Enable once google_sign_in and
/// sign_in_with_apple are implemented (Apple requires Sign in with Apple when
/// Google sign-in is offered).
const bool _socialLoginEnabled = !kReleaseMode;

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
    this.inProgress = false,
  });
  final TextEditingController phoneController;
  final String? phoneError;
  final VoidCallback onContinue;
  final VoidCallback onGoogle;
  final VoidCallback onApple;
  final bool inProgress;

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
                style: AppTextStyles.displayHero.copyWith(color: AppColors.petrol),
              ),
              Text(
                AppLocaleKey.loginTagline.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.petrol, height: 24 / 16),
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
                inProgress: inProgress,
                onPressed: onContinue,
              ),
              const SizedBox(height: 16),
              if (_socialLoginEnabled) ...[
                LoginSocialButtons(onGoogle: onGoogle, onApple: onApple),
                const SizedBox(height: 12),
              ],
              // Not const: the labels follow the active locale at runtime.
              LoginLegalLinks(),
            ],
          ),
        ),
      ),
    );
  }
}
