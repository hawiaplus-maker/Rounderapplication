import 'package:easy_localization/easy_localization.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';

/// Form validators of the link-home journey (rounder-validation): the single
/// home of the property-code and unit-number rules.
abstract final class PropertiesValidators {
  /// Property code: required and at least five characters.
  static String? propertyCode(String? value) =>
      value == null || value.trim().length < 5
      ? AppLocaleKey.requiredField.tr()
      : null;

  /// Unit number: required.
  static String? unitNumber(String? value) =>
      value == null || value.trim().isEmpty
      ? AppLocaleKey.requiredField.tr()
      : null;
}
