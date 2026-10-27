import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_code_view.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/otp_result_view.dart';

/// Design journey (الدخول / رمز التحقق بتأكيد رقم الشخص + نتيجة التحقق):
/// a local two-step verification prototype — the code + result pages of the
/// approved auth frames. Reached from the login prototype links; it does not
/// call the auth endpoints.
class OtpFlowScreen extends StatefulWidget {
  const OtpFlowScreen({super.key, this.phone = '', this.startAtResult = false, this.onContinue});
  final String phone;

  /// Opens on the verified-result page — the design's destination for the
  /// Google / Apple sign-in buttons.
  final bool startAtResult;

  /// Result-page "متابعة" action; falls back to popping the flow.
  final VoidCallback? onContinue;

  @override
  State<OtpFlowScreen> createState() => _OtpFlowScreenState();
}

enum _Page { code, result }

class _OtpFlowScreenState extends State<OtpFlowScreen> {
  late _Page _page = widget.startAtResult ? _Page.result : _Page.code;
  final code = TextEditingController();

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  /// Masks the number so only the last two digits stay visible; falls back to
  /// the frame's placeholder when no phone arrives (sign-in path).
  String get maskedPhone {
    final phone = widget.phone;
    if (phone.length >= 6) {
      // Keep the full country code (+966) visible, then mask the rest.
      final prefixLength = phone.startsWith('+966')
          ? 4
          : phone.startsWith('+')
          ? 3
          : 0;
      final visibleTail = phone.substring(phone.length - 2);
      final masked =
          '${phone.substring(0, prefixLength)}${'•' * (phone.length - prefixLength - 2)}$visibleTail';
      return masked;
    }
    return AppLocaleKey.otpMaskedPhone.tr();
  }

  /// The frame top is brand petrol, so the system status icons must be light.
  static const _overlayStyle = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, .25, .42, .6, .78, 1],
              colors: [
                AppColors.petrol,
                AppColors.petrol,
                AppColors.teal,
                AppColors.mintLight,
                AppColors.canvas,
                AppColors.sand,
              ],
            ),
          ),
          child: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: KeyedSubtree(
                key: ValueKey(_page.name),
                child: switch (_page) {
                  _Page.code => OtpCodeView(
                    maskedPhone: maskedPhone,
                    code: code,
                    canVerify: code.text.trim().length == 6,
                    onResend: () => setState(() => code.clear()),
                    onVerify: () => setState(() => _page = _Page.result),
                    onChangePhone: () => Navigator.maybePop(context),
                  ),
                  _Page.result => OtpResultView(
                    onContinue:
                        widget.onContinue ?? () => Navigator.maybePop(context),
                    onBack: () => Navigator.maybePop(context),
                  ),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
