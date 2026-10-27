import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  /// The stored token is only the hint — the backend decides: `me` must
  /// answer for the boot gate to show the resident home; no token, or any
  /// failure (rejection, offline), falls to the login branch.
  Future<void> restoreSession() async {
    emit(AuthChecking());
    if (!await repo.hasSession()) {
      emit(Unauthenticated());
      return;
    }
    try {
      await repo.me();
      emit(Authenticated());
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> signIn(String email, String password) async =>
      _run(() => repo.signIn(email.trim(), password));
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
  Future<void> _run(Future<void> Function() action) async {
    emit(AuthChecking());
    try {
      await action();
      emit(Authenticated());
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 422) {
        emit(AuthFailure('check_fields'));
      } else if (e is DioException &&
          e.type == DioExceptionType.connectionError) {
        emit(AuthFailure('connection_error'));
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
