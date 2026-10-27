import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/global/features/auth/data/model/validate_mobile_model.dart';
import 'package:rounder_application/layout/global/features/auth/data/repo/auth_repo.dart';

/// States of the validated-phone journey (validate-mobile → register /
/// send-otp). Each screen that runs the journey provides its own
/// [PhoneAuthCubit] instance, so [PhoneAuthInProgress] is scoped per screen:
/// the login "continue" spinner, the register submit and the OTP resend.
sealed class PhoneAuthState {}

class PhoneAuthIdle extends PhoneAuthState {}

class PhoneAuthInProgress extends PhoneAuthState {}

/// validate-mobile answered `is_registered` + the normalized mobile data;
/// the login screen branches to the register or the OTP screen on it.
class PhoneValidated extends PhoneAuthState {
  PhoneValidated(this.model);
  final ValidateMobileModel model;
}

/// register succeeded → the flow continues to the send-otp screen.
class PhoneRegistered extends PhoneAuthState {}

/// send-otp succeeded → the code page keeps waiting for the user's code.
class PhoneOtpSent extends PhoneAuthState {}

/// verify-otp succeeded → the flow continues to the confirmed-result page.
class PhoneOtpVerified extends PhoneAuthState {}

class PhoneAuthFailure extends PhoneAuthState {
  PhoneAuthFailure(this.message);

  /// Display text ready for the UI: the backend's message when it provided
  /// one, otherwise an [AppLocaleKey] value already resolved to text.
  final String message;
}

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  PhoneAuthCubit(this.repo) : super(PhoneAuthIdle());
  final AuthRepository repo;

  Future<void> validateMobile(String mobile) async {
    if (isClosed) return;
    emit(PhoneAuthInProgress());
    try {
      final result = await repo.validateMobile(mobile);
      if (isClosed) return;
      emit(
        PhoneValidated(
          result.data ??
              ValidateMobileModel(mobile: mobile, formattedMobile: mobile),
        ),
      );
    } catch (e) {
      _fail(e, fallback: AppLocaleKey.authFailed.tr());
    }
  }

  Future<void> registerPhone({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (isClosed) return;
    emit(PhoneAuthInProgress());
    try {
      await repo.registerPhone(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      if (isClosed) return;
      emit(PhoneRegistered());
    } catch (e) {
      _fail(e, fallback: AppLocaleKey.authFailed.tr());
    }
  }

  Future<void> sendOtp(String mobile) async {
    if (isClosed) return;
    emit(PhoneAuthInProgress());
    try {
      await repo.sendOtp(mobile);
      if (isClosed) return;
      emit(PhoneOtpSent());
    } catch (e) {
      _fail(e, fallback: AppLocaleKey.otpSendFailed.tr());
    }
  }

  /// The code step's verify-otp: wrong code, expiry and throttling come
  /// back localized from the backend; the fallback covers malformed
  /// failures only.
  Future<void> verifyOtp({required String mobile, required String otp}) async {
    if (isClosed) return;
    emit(PhoneAuthInProgress());
    try {
      await repo.verifyOtp(mobile: mobile, otp: otp);
      if (isClosed) return;
      emit(PhoneOtpVerified());
    } catch (e) {
      _fail(e, fallback: AppLocaleKey.invalidVerificationCode.tr());
    }
  }

  /// Backend messages are localized server-side (the interceptor sends
  /// Accept-Language), so they pass through raw; generic Dio cases map to
  /// the existing auth failure keys — same mapping as [AuthCubit].
  void _fail(Object e, {required String fallback}) {
    if (isClosed) return;
    final backend = _backendMessage(e);
    if (backend != null) {
      emit(PhoneAuthFailure(backend));
      return;
    }
    if (e is DioException && e.type == DioExceptionType.connectionError) {
      emit(PhoneAuthFailure(AppLocaleKey.connectionError.tr()));
      return;
    }
    emit(PhoneAuthFailure(fallback));
  }

  static String? _backendMessage(Object e) {
    if (e is PhoneAuthException) return e.message.isEmpty ? null : e.message;
    if (e is DioException && e.response?.data is Map) {
      final message = (e.response!.data as Map)['message']?.toString() ?? '';
      return message.isEmpty ? null : message;
    }
    return null;
  }
}
