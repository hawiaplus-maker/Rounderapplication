/// Pure helpers of the Rounder phone journey (rounder-logic): normalization
/// and shape handling of the numbers the app exchanges with the endpoints.
/// No widgets, no locale, no side effects — input in, stable output out.
library;

/// The local `05…` mobile form the backend expects (its `data.mobile`):
///
/// - `0512345678` (10 digits starting `0`) passes through as-is,
/// - `512345678`  (9 digits starting `5`) gains the leading local zero,
/// - any other digit shape is not a Saudi local mobile → `null`; callers
///   resolve their own error message (no locale leaks into this helper).
String? normalizeSaudiLocalMobile(String rawDigits) {
  final digits = digitsOnly(rawDigits);
  if (digits.startsWith('0')) return digits.length == 10 ? digits : null;
  if (digits.startsWith('5')) return digits.length == 9 ? '0$digits' : null;
  return null;
}

/// Whether the phone entry may hold `digits` while still growing into the
/// accepted shapes — the entry-side mirror of [normalizeSaudiLocalMobile]:
/// empty travels, `0…` may reach 10 digits, `5…` stops at 9, and any other
/// leading digit can never normalize, so the field rejects it at the
/// keystroke instead of waiting for the submit error.
bool saudiLocalMobileAllows(String digits) {
  if (digits.isEmpty) return true;
  if (digits.startsWith('0')) return digits.length <= 10;
  if (digits.startsWith('5')) return digits.length <= 9;
  return false;
}

/// Western decimal digits only, converting the Arabic-Indic and Eastern
/// Arabic-Indic shapes the device keyboards emit.
String digitsOnly(String value) =>
    _westernDigits(value).replaceAll(RegExp(r'\D'), '');

/// Normalizes the international phone entry the phone-change sheet accepts:
/// Western digits, no spaces, parentheses or dashes; a leading `+` survives.
String normalizePhoneDigits(String value) =>
    _westernDigits(value).replaceAll(RegExp(r'[\s()-]'), '');

/// International E.164-ish shape (`+` then 8–15 digits, no zero start).
bool isIntlPhone(String value) =>
    RegExp(r'^\+[1-9][0-9]{7,14}$').hasMatch(value);

String _westernDigits(String value) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  const urdu = '۰۱۲۳۴۵۶۷۸۹';
  for (var i = 0; i < 10; i++) {
    value = value.replaceAll(arabic[i], '$i').replaceAll(urdu[i], '$i');
  }
  return value;
}
