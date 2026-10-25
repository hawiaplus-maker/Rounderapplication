import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/screen/email_login_screen.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/screen/otp_flow_screen.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_brand.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_form_card.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_guest_action.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_hero.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_prototype_links.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/resident_repo.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/screen/resident_home_screen.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/screen/resident_welcome_flow.dart';

/// Approved login (design `00 — تسجيل الدخول • APPROVED`): brand wordmark,
/// Ali phone hero, frosted phone-entry form with the alternate social actions
/// and the guest action, all on the brand gradient. The phone journey opens the
/// OTP flow; the prototype links under the fold keep the working email
/// sign-in and the design previews reachable.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phone = TextEditingController();
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    phone.addListener(_clearPhoneError);
  }

  @override
  void dispose() {
    phone.removeListener(_clearPhoneError);
    phone.dispose();
    super.dispose();
  }

  void _clearPhoneError() {
    if (_phoneError != null) setState(() => _phoneError = null);
  }

  void _continueWithPhone() {
    final digits = phone.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 9) {
      setState(() => _phoneError = AppLocaleKey.localPhoneInvalid.tr());
      return;
    }
    setState(() => _phoneError = null);
    _push(OtpFlowScreen(phone: '+966$digits', onContinue: _continueToPreviewHome));
  }

  void _push(Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));

  /// The OTP result page's "متابعة" leads to the design's الرئيسية destination
  /// (the prototype preview home).
  void _continueToPreviewHome() {
    Navigator.of(context).pop();
    _browseAsGuest();
  }

  void _openEmailSignIn() => _push(const EmailLoginScreen());

  void _openWelcomeSteps() => _push(const ResidentWelcomeFlow());

  void _browseAsGuest() => _push(
    BlocProvider(
      create: (_) => ResidentDashboardCubit.preview(sl<ResidentRepository>()),
      child: const ResidentHomeScreen(),
    ),
  );

  Future<void> _chooseLanguage() async {
    final selected = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(AppLocaleKey.arabic.tr()),
              onTap: () => Navigator.pop(sheetContext, const Locale('ar')),
            ),
            ListTile(
              title: Text(AppLocaleKey.english.tr()),
              onTap: () => Navigator.pop(sheetContext, const Locale('en')),
            ),
            ListTile(
              title: Text(AppLocaleKey.urdu.tr()),
              onTap: () => Navigator.pop(sheetContext, const Locale('ur')),
            ),
          ],
        ),
      ),
    );
    if (selected != null && mounted) context.setLocale(selected);
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
              stops: [0, .17, .31, .52, .77, 1],
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
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 24, 12, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const LoginBrand(),
                        const LoginHero(),
                        LoginFormCard(
                          phoneController: phone,
                          phoneError: _phoneError,
                          onContinue: _continueWithPhone,
                          onGoogle: () => _push(
                            OtpFlowScreen(startAtResult: true, onContinue: _continueToPreviewHome),
                          ),
                          onApple: () => _push(
                            OtpFlowScreen(startAtResult: true, onContinue: _continueToPreviewHome),
                          ),
                        ),
                        LoginGuestAction(onTap: _browseAsGuest),
                        const SizedBox(height: 12),
                        LoginPrototypeLinks(
                          onEmailSignIn: _openEmailSignIn,
                          onWelcomeSteps: _openWelcomeSteps,
                          onLanguage: _chooseLanguage,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
