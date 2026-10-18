import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';

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
  Future<void> restoreSession() async {
    emit(AuthChecking());
    emit(await repo.hasSession() ? Authenticated() : Unauthenticated());
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
      if (e is DioException && e.response?.statusCode == 422)
        emit(AuthFailure('check_fields'));
      else if (e is DioException && e.type == DioExceptionType.connectionError)
        emit(AuthFailure('connection_error'));
      else
        emit(AuthFailure('auth_failed'));
    }
  }

  Future<void> signOut() async {
    await repo.signOut();
    emit(Unauthenticated());
  }
}
