import 'package:flutter_test/flutter_test.dart';
import 'package:rounder_application/core/constants/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

void main() {
  test('brand tokens and centralized locale keys are configured', () {
    expect(AppColors.petrol.value, 0xFF073D43);
    expect(AppLocaleKey.home, 'home');
    expect(AppLocaleKey.urdu, 'urdu');
  });
}
