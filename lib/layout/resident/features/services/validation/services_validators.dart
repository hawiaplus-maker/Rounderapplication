import 'package:easy_localization/easy_localization.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';

/// Form validators of the service journey (rounder-validation): the single
/// home of the journey step rules the pages compose — currently the problem
/// description rule of the details step, which renders its feedback inline
/// under the field instead of a snackbar.
abstract final class ServicesValidators {
  /// Problem description of the details step: at least five characters on
  /// the trimmed value.
  static String? issue(String? value) =>
      (value ?? '').trim().length < 5 ? AppLocaleKey.requiredField.tr() : null;
}
