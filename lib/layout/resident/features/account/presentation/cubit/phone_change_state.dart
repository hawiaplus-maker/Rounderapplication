part of 'phone_change_cubit.dart';

enum PhoneChangeStep { number, code, verified }

class PhoneChangeState {
  const PhoneChangeState({
    this.step = PhoneChangeStep.number,
    this.phone = '',
    this.loading = false,
    this.errorKey,
  });
  final PhoneChangeStep step;
  final String phone;
  final bool loading;
  final String? errorKey;
}

