import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/global/features/auth/data/repo/auth_repo.dart';

sealed class AuthState {}

class AuthChecking extends AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {}

class AuthFailure extends AuthState {
  AuthFailure(this.messageKey);
  final String messageKey;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repo) : super(AuthChecking());
  final AuthRepository repo;

  /// The stored token is only the hint — the backend decides. The cached
  /// session enters the app immediately: the boot splash must not wait on a
  /// network round-trip (a bad connection used to hold it for the whole
  /// timeout). `me` still verifies in the background: a rejected token falls
  /// to the login branch, while a connection failure (offline, timeout) keeps
  /// the session so an offline launch is not dumped on the login screen.
  Future<void> restoreSession() async {
    emit(AuthChecking());
    if (!await repo.hasSession()) {
      emit(Unauthenticated());
      return;
    }
    emit(Authenticated());
    try {
      await repo.me();
    } catch (e) {
      if (!isConnectionFailure(e) && !isClosed) emit(Unauthenticated());
    }
  }

  Future<void> signIn(String email, String password) async =>
      _run(() => repo.signIn(email.trim(), password));

  /// Social sign-in: exchanges a provider id_token for a session. A 503 here
  /// means the backend has no provider credentials configured — surface it as
  /// "method unavailable" instead of a rejected-credentials message.
  Future<void> signInWithSocial({
    required String provider,
    required String idToken,
  }) async => _run(
    () => repo.socialLogin(provider: provider, idToken: idToken),
    serviceUnavailableKey: 'social_unavailable',
  );
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String locale,
  }) async => _run(
    () => repo.register(
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      password: password,
      locale: locale,
    ),
  );
  Future<void> _run(
    Future<void> Function() action, {
    String? serviceUnavailableKey,
  }) async {
    emit(AuthChecking());
    try {
      await action();
      emit(Authenticated());
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 422) {
        emit(AuthFailure('check_fields'));
      } else if (isConnectionFailure(e)) {
        emit(AuthFailure('connection_error'));
      } else if (serviceUnavailableKey != null &&
          e is DioException &&
          e.response?.statusCode == 503) {
        emit(AuthFailure(serviceUnavailableKey));
      } else {
        emit(AuthFailure('auth_failed'));
      }
    }
  }

  /// The phone journey's verify-otp already cached the session token —
  /// flips the app-level session so the boot gate reveals the resident
  /// home without another `me` round-trip.
  void markAuthenticated() {
    if (!isClosed) emit(Authenticated());
  }

  Future<void> signOut() async {
    if (isClosed) return;
    await repo.signOut();
    if (isClosed) return;
    emit(Unauthenticated());
  }
}
