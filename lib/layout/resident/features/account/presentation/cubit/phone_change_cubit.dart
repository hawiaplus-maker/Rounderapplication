import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/resident/features/account/data/repo/profile_repo.dart';
import 'package:rounder_application/logic/phone_number_logic.dart';

part 'phone_change_state.dart';

/// Real mobile-number change flow: validates the local number, asks the
/// backend to send an OTP to it (`POST /api/v1/auth/send-otp`), then
/// verifies and persists it (`PUT /api/v1/resident/mobile`).
class PhoneChangeCubit extends Cubit<PhoneChangeState> {
  PhoneChangeCubit(this.repo) : super(const PhoneChangeState());
  final ProfileRepository repo;

  Future<void> send(String value) async {
    final phone = normalizeSaudiLocalMobile(value);
    if (phone == null) {
      emit(
        PhoneChangeState(phone: value, errorKey: AppLocaleKey.localPhoneInvalid),
      );
      return;
    }
    emit(PhoneChangeState(step: PhoneChangeStep.code, phone: phone, loading: true));
    try {
      await repo.sendChangeMobileOtp(phone);
      if (isClosed) return;
      emit(PhoneChangeState(step: PhoneChangeStep.code, phone: phone));
    } catch (e) {
      if (isClosed) return;
      emit(
        PhoneChangeState(
          step: PhoneChangeStep.number,
          phone: phone,
          errorKey: _errorMessage(e),
        ),
      );
    }
  }

  Future<void> resend() async {
    if (state.phone.isEmpty) return;
    emit(PhoneChangeState(step: state.step, phone: state.phone, loading: true));
    try {
      await repo.sendChangeMobileOtp(state.phone);
      if (isClosed) return;
      emit(PhoneChangeState(step: PhoneChangeStep.code, phone: state.phone));
    } catch (e) {
      if (isClosed) return;
      emit(
        PhoneChangeState(
          step: PhoneChangeStep.code,
          phone: state.phone,
          errorKey: _errorMessage(e),
        ),
      );
    }
  }

  Future<void> verify(String code) async {
    if (state.step != PhoneChangeStep.code) return;
    final digits = normalizePhoneDigits(code);
    if (digits.length != 6) {
      emit(
        PhoneChangeState(
          step: state.step,
          phone: state.phone,
          errorKey: AppLocaleKey.invalidVerificationCode,
        ),
      );
      return;
    }
    emit(PhoneChangeState(step: state.step, phone: state.phone, loading: true));
    try {
      await repo.changeMobile(mobile: state.phone, otp: digits);
      if (isClosed) return;
      emit(PhoneChangeState(step: PhoneChangeStep.verified, phone: state.phone));
    } catch (e) {
      if (isClosed) return;
      emit(
        PhoneChangeState(
          step: PhoneChangeStep.code,
          phone: state.phone,
          errorKey: _errorMessage(e),
        ),
      );
    }
  }

  void editNumber() {
    emit(PhoneChangeState(phone: state.phone));
  }

  void clearError() {
    if (state.errorKey == null) return;
    emit(
      PhoneChangeState(step: state.step, phone: state.phone, loading: state.loading),
    );
  }

  String _errorMessage(Object e) {
    final backend = apiErrorMessage(e);
    if (backend != null) return backend;
    if (isConnectionFailure(e)) return AppLocaleKey.connectionError.tr();
    return AppLocaleKey.authFailed.tr();
  }
}
