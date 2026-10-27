import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/logic/phone_number_logic.dart';

part 'phone_change_state.dart';

/// Offline preview only. Replace this adapter with server verification when API
/// integration is enabled; this code must never authorize a real account change.
class PhoneChangeCubit extends Cubit<PhoneChangeState> {
  PhoneChangeCubit() : super(const PhoneChangeState());
  Timer? _timer;
  DateTime? _expiresAt;
  int _attempts = 0;
  static const previewCode = '123456';

  void send(String value) {
    final phone = normalizePhoneDigits(value);
    if (!isIntlPhone(phone)) {
      emit(PhoneChangeState(phone: phone, errorKey: AppLocaleKey.invalidPhone));
      return;
    }
    _attempts = 0;
    _expiresAt = DateTime.now().add(const Duration(minutes: 5));
    _timer?.cancel();
    emit(
      PhoneChangeState(step: PhoneChangeStep.code, phone: phone, remaining: 30),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed || state.remaining <= 1) {
        timer.cancel();
        if (!isClosed) emit(PhoneChangeState(step: state.step, phone: state.phone));
      } else {
        emit(
          PhoneChangeState(
            step: state.step,
            phone: state.phone,
            remaining: state.remaining - 1,
            errorKey: state.errorKey,
          ),
        );
      }
    });
  }

  void resend() {
    if (state.remaining == 0) send(state.phone);
  }

  void verify(String code) {
    if (state.step != PhoneChangeStep.code) return;
    final expired = _expiresAt == null || DateTime.now().isAfter(_expiresAt!);
    if (expired ||
        _attempts >= 5 ||
        normalizePhoneDigits(code) != previewCode) {
      _attempts++;
      emit(
        PhoneChangeState(
          step: state.step,
          phone: state.phone,
          remaining: state.remaining,
          errorKey: expired || _attempts >= 5
              ? AppLocaleKey.codeExpired
              : AppLocaleKey.invalidVerificationCode,
        ),
      );
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

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
