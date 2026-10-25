import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_action.dart';

/// Resend / verify / change-phone actions of the OTP code step.
class OtpCodeActions extends StatelessWidget {
  const OtpCodeActions({
    super.key,
    required this.canVerify,
    required this.onResend,
    required this.onVerify,
    required this.onChangePhone,
  });

  final bool canVerify;
  final VoidCallback onResend;
  final VoidCallback onVerify;
  final VoidCallback onChangePhone;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      OtpAction(
        label: AppLocaleKey.resendCode.tr(),
        fill: AppColors.mintLight,
        onPressed: onResend,
      ),
      const SizedBox(height: 12),
      OtpAction(
        label: AppLocaleKey.otpVerify.tr(),
        fill: AppColors.coral,
        onPressed: canVerify ? onVerify : null,
      ),
      const SizedBox(height: 12),
      OtpAction(
        label: AppLocaleKey.changePhone.tr(),
        fill: AppColors.mintLight,
        onPressed: onChangePhone,
      ),
    ],
  );
}
