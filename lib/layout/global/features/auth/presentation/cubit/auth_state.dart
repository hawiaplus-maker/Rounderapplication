part of 'auth_cubit.dart';

sealed class AuthState {}
class AuthChecking extends AuthState {}
class Unauthenticated extends AuthState {}
class Authenticated extends AuthState {}
class AuthFailure extends AuthState {AuthFailure(this.messageKey);final String messageKey;}
