import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/global/features/auth/data/model/validate_mobile_model.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/phone_auth_cubit.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/auth_gradient_backdrop.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/screens/otp_code_view.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/screens/otp_result_view.dart';

/// Design journey (الدخول / رمز التحقق بتأكيد رقم الشخص + نتيجة التحقق). When
/// pushed with a [ValidateMobileModel] (the validated-phone journey push
/// sites) this screen also calls send-otp on entry and on resend, using the
/// model's exact `data.mobile`, and calls verify-otp on the code step's
/// submit; pushed from the login's prototype links (no model) it stays a
/// pure preview. A `BlocProvider` of `PhoneAuthCubit` wraps this screen in
/// every push site.
class OtpFlowScreen extends StatefulWidget {
  const OtpFlowScreen({
    super.key,
    this.phone = '',
    this.startAtResult = false,
    this.onContinue,
    this.validated,
  });
  final String phone;

  /// Opens on the verified-result page — the design's destination for the
  /// Google / Apple sign-in buttons.
  final bool startAtResult;

  /// Result-page "متابعة" action; falls back to popping the flow.
  final VoidCallback? onContinue;

  /// validate-mobile's answer while the journey drives this screen.
  final ValidateMobileModel? validated;

  @override
  State<OtpFlowScreen> createState() => _OtpFlowScreenState();
}

enum _Page { code, result }

class _OtpFlowScreenState extends State<OtpFlowScreen> {
  late _Page _page = widget.startAtResult ? _Page.result : _Page.code;
  final code = TextEditingController();

  /// Current failure line of the code step (send or verify rejection).
  String? _otpError;

  /// Verify-otp in flight — the verify pill spins (and blocks re-press)
  /// until the listener clears it on either outcome.
  bool _verifying = false;

  /// The verify pill activates the moment the entered code reaches six
  /// digits — the controller listener flips this, the build follows.
  bool _canVerify = false;

  void _onCodeChanged() {
    final can = code.text.trim().length == 6;
    if (can != _canVerify) setState(() => _canVerify = can);
  }

  @override
  void initState() {
    super.initState();
    code.addListener(_onCodeChanged);
    if (widget.validated != null) {
      // The cubit lives above this frame (journey push sites provide it);
      // read it once the first build exists.
      WidgetsBinding.instance.addPostFrameCallback((_) => _sendOtp());
    }
  }

  @override
  void dispose() {
    code.removeListener(_onCodeChanged);
    code.dispose();
    super.dispose();
  }

  /// Journey calls send the validated number as-is — validate-mobile's
  /// `data.mobile` (local `05…` form), no local re-derivation.
  void _sendOtp() =>
      context.read<PhoneAuthCubit>().sendOtp(widget.validated!.mobile);

  /// The code step's submit: the journey path calls verify-otp with the
  /// validated number's local `05…` form; the prototype link (no journey
  /// model) keeps its instant local switch to the result preview.
  void _verifyCode() {
    // Same single-flight rule as resend: a double tap must not queue a
    // second verify-otp while the first is pending.
    if (_verifying ||
        context.read<PhoneAuthCubit>().state is PhoneAuthInProgress) {
      return;
    }
    final validated = widget.validated;
    if (validated == null) {
      setState(() => _page = _Page.result);
      return;
    }
    setState(() => _verifying = true);
    context.read<PhoneAuthCubit>().verifyOtp(
      mobile: validated.mobile,
      otp: code.text.trim(),
    );
  }

  /// Result-page continue: prototype callers keep their own callback; a
  /// verified journey pops to the root so the boot gate swaps to the
  /// resident home (the session was marked on verify success).
  void _continueFromResult() {
    final onContinue = widget.onContinue;
    if (onContinue != null) {
      onContinue();
      return;
    }
    if (widget.validated == null) {
      Navigator.maybePop(context);
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
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
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        switch (state) {
          case PhoneAuthFailure(:final message):
            if (mounted) {
              setState(() {
                _otpError = message;
                _verifying = false;
              });
            }
          case PhoneOtpSent():
            if (mounted) {
              setState(() {
                _otpError = null;
                _verifying = false;
              });
            }
          case PhoneOtpVerified():
            if (mounted) {
              // verify-otp cached the session token — the session is live,
              // so the gate under this route is ready to show the home.
              context.read<AuthCubit>().markAuthenticated();
              setState(() {
                _otpError = null;
                _verifying = false;
                _page = _Page.result;
              });
            }
          default:
            break;
        }
      },
      child: BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
        builder: (context, cubitState) {
          final sending = cubitState is PhoneAuthInProgress;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: _overlayStyle,
            child: Scaffold(
              body: AuthGradientBackdrop(
                stops: const [0, .25, .42, .6, .78, 1],
                child: SafeArea(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: KeyedSubtree(
                      key: ValueKey(_page.name),
                      child: switch (_page) {
                        _Page.code => OtpCodeView(
                          maskedPhone: maskedPhone,
                          code: code,
                          canVerify: _canVerify,
                          sendingCode: sending,
                          verifying: _verifying,
                          errorText: _otpError,
                          onResend: () {
                            // One resend per flight: a double tap before
                            // the rebuild disables the button must not
                            // queue a second send-otp request.
                            if (context.read<PhoneAuthCubit>().state
                                is PhoneAuthInProgress) {
                              return;
                            }
                            setState(() {
                              _otpError = null;
                              _verifying = false;
                              code.clear();
                            });
                            if (widget.validated != null) _sendOtp();
                          },
                          onVerify: _verifyCode,
                          onChangePhone: () => Navigator.maybePop(context),
                        ),
                        _Page.result => OtpResultView(
                          onContinue: _continueFromResult,
                          onBack: () => Navigator.maybePop(context),
                        ),
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
