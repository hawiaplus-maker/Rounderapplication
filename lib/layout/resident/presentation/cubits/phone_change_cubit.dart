import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';

enum PhoneChangeStep { number, code, verified }

class PhoneChangeState {
  const PhoneChangeState({this.step = PhoneChangeStep.number, this.phone = '',
    this.remaining = 0, this.errorKey});
  final PhoneChangeStep step;
  final String phone;
  final int remaining;
  final String? errorKey;
}

/// Offline preview only. Replace this adapter with server verification when API
/// integration is enabled; this code must never authorize a real account change.
class PhoneChangeCubit extends Cubit<PhoneChangeState> {
  PhoneChangeCubit() : super(const PhoneChangeState());
  Timer? _timer;
  DateTime? _expiresAt;
  int _attempts = 0;
  static const previewCode = '123456';

  static String normalize(String value) {
    const arabic = '٠١٢٣٤٥٦٧٨٩';
    const urdu = '۰۱۲۳۴۵۶۷۸۹';
    for (var i = 0; i < 10; i++) {
      value = value.replaceAll(arabic[i], '$i').replaceAll(urdu[i], '$i');
    }
    return value.replaceAll(RegExp(r'[\s()-]'), '');
  }

  void send(String value) {
    final phone = normalize(value);
    if (!RegExp(r'^\+[1-9][0-9]{7,14}$').hasMatch(phone)) {
      emit(PhoneChangeState(phone: phone, errorKey: AppLocaleKey.invalidPhone));
      return;
    }
    _attempts = 0;
    _expiresAt = DateTime.now().add(const Duration(minutes: 5));
    _timer?.cancel();
    emit(PhoneChangeState(step: PhoneChangeStep.code, phone: phone, remaining: 30));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed || state.remaining <= 1) {
        timer.cancel();
        if (!isClosed) emit(PhoneChangeState(step: state.step, phone: state.phone));
      } else {
        emit(PhoneChangeState(step: state.step, phone: state.phone,
          remaining: state.remaining - 1, errorKey: state.errorKey));
      }
    });
  }

  void resend() { if (state.remaining == 0) send(state.phone); }

  void verify(String code) {
    if (state.step != PhoneChangeStep.code) return;
    final expired = _expiresAt == null || DateTime.now().isAfter(_expiresAt!);
    if (expired || _attempts >= 5 || normalize(code) != previewCode) {
      _attempts++;
      emit(PhoneChangeState(step: state.step, phone: state.phone, remaining: state.remaining,
        errorKey: expired || _attempts >= 5 ? AppLocaleKey.codeExpired : AppLocaleKey.invalidVerificationCode));
      return;
    }
    _timer?.cancel();
    emit(PhoneChangeState(step: PhoneChangeStep.verified, phone: state.phone));
  }

  void editNumber() {
    _timer?.cancel();
    _expiresAt = null;
    emit(PhoneChangeState(phone: state.phone));
  }

  @override Future<void> close() { _timer?.cancel(); return super.close(); }
}
