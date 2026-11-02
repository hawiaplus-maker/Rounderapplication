import 'package:easy_localization/easy_localization.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';

/// Form validators of the add-unit journey (rounder-validation): the single
/// home of the unit-field required rules.
abstract final class UnitsValidators {
  /// A required free-text unit field (address, unit number, …).
  static String? required(String? value) =>
      value == null || value.trim().isEmpty
      ? AppLocaleKey.requiredField.tr()
      : null;
}
