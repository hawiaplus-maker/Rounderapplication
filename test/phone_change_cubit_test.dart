import 'package:flutter_test/flutter_test.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/phone_change_cubit.dart';
import 'package:rounder_application/logic/phone_number_logic.dart';

void main() {
  test('phone preview normalizes Arabic and Urdu digits', () {
    expect(normalizePhoneDigits('+٩٦٦ (٥٠) ۱۲۳-۴۵۶۷'), '+966501234567');
  });
  test('invalid number cannot reach verification', () async {
    final cubit = PhoneChangeCubit();
    cubit.send('05');
    expect(cubit.state.step, PhoneChangeStep.number);
    expect(cubit.state.errorKey, isNotNull);
    await cubit.close();
  });
  test('wrong code does not verify, preview code verifies the draft', () async {
    final cubit = PhoneChangeCubit();
    cubit.send('+966501234567');
    cubit.verify('000000');
    expect(cubit.state.step, PhoneChangeStep.code);
    expect(cubit.state.errorKey, isNotNull);
    cubit.verify(PhoneChangeCubit.previewCode);
    expect(cubit.state.step, PhoneChangeStep.verified);
    expect(cubit.state.phone, '+966501234567');
    await cubit.close();
  });
  test('editing number clears the current verification attempt', () async {
    final cubit = PhoneChangeCubit();
    cubit.send('+966501234567');
    cubit.editNumber();
    cubit.verify(PhoneChangeCubit.previewCode);
    expect(cubit.state.step, PhoneChangeStep.number);
    await cubit.close();
  });
}
