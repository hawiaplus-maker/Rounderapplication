import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_action.dart';

/// Resend / verify / change-phone actions of the OTP code step. When the
/// send-otp call is in flight the resend action spins, the verify action
/// spins on its own [verifying] flag and the `[errorText]` line renders
/// under the actions.
class OtpCodeActions extends StatelessWidget {
  const OtpCodeActions({
    super.key,
    required this.canVerify,
    required this.onResend,
    required this.onVerify,
    required this.onChangePhone,
    this.sendingCode = false,
    this.verifying = false,
    this.errorText,
  });

  final bool canVerify;
  final VoidCallback onResend;
  final VoidCallback onVerify;
  final VoidCallback onChangePhone;
  final bool sendingCode;

  /// Verify-otp in flight — the verify pill spins (and stays disabled)
  /// until the journey emits one of its two outcomes.
  final bool verifying;
  final String? errorText;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      OtpAction(
        label: AppLocaleKey.resendCode.tr(),
        fill: AppColors.mintLight,
        inProgress: sendingCode,
        onPressed: onResend,
      ),
      const SizedBox(height: 12),
      OtpAction(
        label: AppLocaleKey.otpVerify.tr(),
        fill: AppColors.coral,
        inProgress: verifying,
        onPressed: canVerify ? onVerify : null,
      ),
      const SizedBox(height: 12),
      OtpAction(
        label: AppLocaleKey.changePhone.tr(),
        fill: AppColors.mintLight,
        onPressed: onChangePhone,
      ),
      if (errorText != null) ...[
        const SizedBox(height: 6),
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
  );
}
