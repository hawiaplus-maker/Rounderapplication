import 'dart:ui' show ImageFilter;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_action.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/register_field_entry.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/register_phone_summary.dart';
import 'package:rounder_application/layout/global/features/auth/validation/auth_validators.dart';

/// Approved frosted register panel (mirrors the login form card): white 80%
/// panel with a 24px backdrop blur, create-account copy, the name/email and
/// matched password pair the phone journey registers with, the validated
/// number read-only and the coral continue action. Validation errors grow
/// under their fields; [onContinue] runs after the screen's Form passes.
class RegisterFormCard extends StatelessWidget {
  const RegisterFormCard({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.formattedMobile,
    required this.onContinue,
    this.inProgress = false,
    this.errorText,
  });
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final String formattedMobile;
  final VoidCallback onContinue;
  final bool inProgress;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 18),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: .8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.white.withValues(alpha: .94)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocaleKey.createAccount.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.petrol,
                  fontSize: 32,
                  height: 44 / 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                AppLocaleKey.registerIntro.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.petrol,
                  fontSize: 16,
                  height: 24 / 16,
                ),
              ),
              const SizedBox(height: 24),
              RegisterFieldEntry(
                label: AppLocaleKey.fullName.tr(),
                controller: nameController,
              ),
              const SizedBox(height: 12),
              RegisterFieldEntry(
                label: AppLocaleKey.email.tr(),
                controller: emailController,
                keyboard: TextInputType.emailAddress,
                ltr: true,
                validator: AuthValidators.email,
              ),
              const SizedBox(height: 12),
              RegisterFieldEntry(
                label: AppLocaleKey.password.tr(),
                controller: passwordController,
                obscure: true,
                validator: AuthValidators.password,
              ),
              const SizedBox(height: 12),
              RegisterFieldEntry(
                label: AppLocaleKey.confirmPassword.tr(),
                controller: confirmController,
                obscure: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onContinue(),
                validator: AuthValidators.confirm(passwordController),
              ),
              const SizedBox(height: 12),
              RegisterPhoneSummary(formattedMobile: formattedMobile),
              const SizedBox(height: 24),
              OtpAction(
                label: AppLocaleKey.createAccount.tr(),
                fill: AppColors.coral,
                height: 54,
                radius: 12,
                labelSize: 20,
                labelLineHeight: 32,
                inProgress: inProgress,
                onPressed: onContinue,
              ),
              if (errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.coral,
                    fontSize: 12,
                    height: 22 / 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
