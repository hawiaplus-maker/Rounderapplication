import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_code_actions.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_code_panel.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_header.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_intro_card.dart';

/// OTP code step: number confirmation, code field and its actions. When the
/// validated-phone journey drives this screen the resend action mirrors the
/// send-otp call state.
class OtpCodeView extends StatelessWidget {
  const OtpCodeView({
    super.key,
    required this.maskedPhone,
    required this.code,
    required this.canVerify,
    required this.onResend,
    required this.onVerify,
    required this.onChangePhone,
    this.sendingCode = false,
    this.verifying = false,
    this.errorText,
  });

  final String maskedPhone;
  final TextEditingController code;
  final bool canVerify;
  final VoidCallback onResend;
  final VoidCallback onVerify;
  final VoidCallback onChangePhone;
  final bool sendingCode;
  final bool verifying;
  final String? errorText;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey('otp-code'),
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
    children: [
      OtpHeader(title: AppLocaleKey.confirmNumber.tr()),
      const SizedBox(height: 12),
      OtpIntroCard(
        icon: Icons.person_rounded,
        firstLine: AppLocaleKey.otpIntro.tr(),
        phoneLine: maskedPhone,
      ),
      const SizedBox(height: 12),
      OtpCodePanel(
        title: AppLocaleKey.otpCodeTitle.tr(),
        prompt: AppLocaleKey.otpPrompt.tr(),
        controller: code,
      ),
      const SizedBox(height: 12),
      OtpCodeActions(
        canVerify: canVerify,
        sendingCode: sendingCode,
        verifying: verifying,
        errorText: errorText,
        onResend: onResend,
        onVerify: onVerify,
        onChangePhone: onChangePhone,
      ),
    ],
  );
}
