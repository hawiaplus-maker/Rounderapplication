import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_action.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_header.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_intro_card.dart';

/// Verified-result step of the OTP flow.
class OtpResultView extends StatelessWidget {
  const OtpResultView({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey('otp-result'),
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
    children: [
      OtpHeader(title: AppLocaleKey.signIn.tr()),
      const SizedBox(height: 12),
      OtpIntroCard(
        icon: Icons.verified_rounded,
        firstLine: AppLocaleKey.otpKeptNote.tr(),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: .92),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocaleKey.otpVerifiedTitle.tr(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 20,
                height: 30 / 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocaleKey.otpVerifiedBody.tr(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 15,
                height: 26 / 15,
              ),
            ),
            const SizedBox(height: 18),
            OtpAction(
              label: AppLocaleKey.otpContinue.tr(),
              fill: AppColors.coral,
              onPressed: onContinue,
            ),
            const SizedBox(height: 12),
            OtpAction(
              label: AppLocaleKey.backToLogin.tr(),
              fill: AppColors.mintLight,
              onPressed: onBack,
            ),
          ],
        ),
      ),
    ],
  );
}
