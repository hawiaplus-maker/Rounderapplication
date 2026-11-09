import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rounder_application/core/constants/auth_config.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/core/services/app_toast.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/global/features/auth/data/model/validate_mobile_model.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/phone_auth_cubit.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/screens/otp_flow_screen.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/screens/register_screen.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/auth_gradient_backdrop.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_brand.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_form_card.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_guest_action.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_hero.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/resident_repo.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/weather_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/screens/resident_home_screen.dart';
import 'package:rounder_application/logic/phone_number_logic.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
  bool _socialInProgress = false;

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
    // Both Saudi local shapes are accepted — 05… with 10 digits and 5… with
    // 9; the logic helper normalizes to the 05… form the journey exchanges
    // with validate-mobile and flags anything else.
    final mobile = normalizeSaudiLocalMobile(phone.text);
    if (mobile == null) {
      setState(() => _phoneError = AppLocaleKey.localPhoneInvalid.tr());
      return;
    }
    setState(() => _phoneError = null);
    context.read<PhoneAuthCubit>().validateMobile(mobile);
  }

  /// Phone validation branches the journey: an existing number goes to the
  /// send-otp screen, an unregistered one to the phone register screen. Each
  /// destination owns its own journey cubit (per-screen factory) and carries
  /// the exact validated model forward.
  void _continueAfterValidation(ValidateMobileModel model) {
    if (model.isRegistered) {
      _push(
        BlocProvider(
          create: (_) => sl<PhoneAuthCubit>(),
          child: OtpFlowScreen(phone: model.formattedMobile, validated: model),
        ),
      );
    } else {
      _push(
        BlocProvider(
          create: (_) => sl<PhoneAuthCubit>(),
          child: RegisterScreen(validated: model),
        ),
      );
    }
  }

  static bool _googleInitialized = false;

  Future<void> _signInWithGoogle() async {
    if (_socialInProgress) return;
    setState(() => _socialInProgress = true);
    try {
      final googleSignIn = GoogleSignIn.instance;
      if (!_googleInitialized) {
        // Android requires the *server* (web) client ID to return an
        // id_token; iOS can rely on GoogleService-Info.plist instead.
        await googleSignIn.initialize(
          serverClientId: AuthConfig.googleServerClientId.isEmpty
              ? null
              : AuthConfig.googleServerClientId,
        );
        _googleInitialized = true;
      }
      final account = await googleSignIn.authenticate();
      final idToken = account.authentication.idToken;
      debugPrint(
        '[social] google account=${account.email} '
        'idToken=${idToken == null ? 'null' : '${idToken.length} chars'}',
      );
      if (idToken == null || idToken.isEmpty) {
        throw Exception('missing id token');
      }
      if (!mounted) return;
      await context.read<AuthCubit>().signInWithSocial(provider: 'google', idToken: idToken);
      if (!mounted) return;
      final state = context.read<AuthCubit>().state;
      debugPrint('[social] backend state=${state.runtimeType}');
      if (state is AuthFailure) {
        _showSocialError(_socialFailureMessage(state.messageKey));
      }
    } catch (e) {
      debugPrint('[social] google sign-in failed: $e');
      if (!mounted) return;
      _showSocialError(_socialErrorMessage(e));
    } finally {
      if (mounted) setState(() => _socialInProgress = false);
    }
  }

  Future<void> _signInWithApple() async {
    if (_socialInProgress) return;
    setState(() => _socialInProgress = true);
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        webAuthenticationOptions: (Platform.isIOS || Platform.isMacOS)
            ? null
            : WebAuthenticationOptions(
                clientId: AuthConfig.appleServiceId,
                redirectUri: Uri.parse(AuthConfig.appleRedirectUri),
              ),
      );
      final idToken = credential.identityToken;
      debugPrint(
        '[social] apple idToken='
        '${idToken == null ? 'null' : '${idToken.length} chars'}',
      );
      if (idToken == null || idToken.isEmpty) {
        throw Exception('missing id token');
      }
      if (!mounted) return;
      await context.read<AuthCubit>().signInWithSocial(provider: 'apple', idToken: idToken);
      if (!mounted) return;
      final state = context.read<AuthCubit>().state;
      debugPrint('[social] backend state=${state.runtimeType}');
      if (state is AuthFailure) {
        _showSocialError(_socialFailureMessage(state.messageKey));
      }
    } catch (e) {
      debugPrint('[social] apple sign-in failed: $e');
      if (!mounted) return;
      _showSocialError(_socialErrorMessage(e));
    } finally {
      if (mounted) setState(() => _socialInProgress = false);
    }
  }

  /// Surfaces a social sign-in failure in the form *and* as a toast, so it is
  /// visible even when the phone form scrolled out of view.
  void _showSocialError(String? message) {
    if (message == null || message.isEmpty) return;
    setState(() => _phoneError = message);
    showApiToast(message);
  }

  String _socialFailureMessage(String key) {
    switch (key) {
      case 'connection_error':
        return AppLocaleKey.connectionError.tr();
      case 'check_fields':
        return AppLocaleKey.checkFields.tr();
      case 'social_unavailable':
        return AppLocaleKey.socialUnavailable.tr();
      default:
        return AppLocaleKey.authFailed.tr();
    }
  }

  String? _socialErrorMessage(Object e) {
    if (e is GoogleSignInException) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // Genuine user dismissal stays silent — but during development the
        // distinction between "user closed it" and "Google refused and
        // reported a cancellation" matters, so make it visible in debug.
        if (kDebugMode) return 'Google sign-in canceled (debug: ${e.code.name})';
        return null;
      }
      if (e.code == GoogleSignInExceptionCode.clientConfigurationError ||
          e.code == GoogleSignInExceptionCode.providerConfigurationError) {
        return AppLocaleKey.socialUnavailable.tr();
      }
      return e.description ?? AppLocaleKey.authFailed.tr();
    }
    if (e is SignInWithAppleAuthorizationException) {
      if (e.code == AuthorizationErrorCode.canceled) return null;
      return e.toString();
    }
    if (e is SignInWithAppleException) return null;
    if (isConnectionFailure(e)) return AppLocaleKey.connectionError.tr();
    return e.toString();
  }

  void _push(Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));

  void _browseAsGuest() => _push(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ResidentDashboardCubit.preview(sl<ResidentRepository>())),
        BlocProvider<WeatherCubit>.value(value: sl<WeatherCubit>()..ensureLoaded()),
      ],
      child: const ResidentHomeScreen(isGuest: true),
    ),
  );

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
            if (mounted) setState(() => _phoneError = message);
          case PhoneValidated(:final model):
            _continueAfterValidation(model);
          default:
            break;
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: _overlayStyle,
        child: Scaffold(
          body: AuthGradientBackdrop(
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
                          BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
                            builder: (context, journeyState) => LoginFormCard(
                              phoneController: phone,
                              phoneError: _phoneError,
                              inProgress: journeyState is PhoneAuthInProgress,
                              onContinue: _continueWithPhone,
                              onGoogle: _socialInProgress ? () {} : _signInWithGoogle,
                              onApple: _socialInProgress ? () {} : _signInWithApple,
                            ),
                          ),
                          if (_socialInProgress)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),
                          LoginGuestAction(onTap: _browseAsGuest),
                        ],
                      ),
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
