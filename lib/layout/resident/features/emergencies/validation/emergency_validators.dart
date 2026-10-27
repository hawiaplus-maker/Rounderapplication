import 'package:easy_localization/easy_localization.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/logic/phone_number_logic.dart';

/// Form validators of the emergency request (rounder-validation): the single
/// home of the contact, location and details rules the SOS form composes.
abstract final class EmergencyValidators {
  /// Required international contact number (`+<digits>`).
  static String? contactPhone(String? value) =>
      isIntlPhone((value ?? '').trim()) ? null : AppLocaleKey.invalidPhone.tr();

  /// Required address of at least four characters.
  static String? location(String? value) =>
      value == null || value.trim().length < 4
      ? AppLocaleKey.requiredField.tr()
      : null;

  /// Required incident description of at least ten characters.
  static String? details(String? value) =>
      value == null || value.trim().length < 10
      ? AppLocaleKey.requiredField.tr()
      : null;
}
