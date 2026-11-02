/// Pure number text of the app (rounder-logic): counts and amounts follow the
/// interface language's digits — Arabic-Indic in Arabic, Latin elsewhere.
library;

import 'package:easy_localization/easy_localization.dart' show NumberFormat;

String localizedNumber(num value, String languageCode) =>
    NumberFormat.decimalPattern(languageCode).format(value);

/// A unit label as shown: a purely numeric label follows the interface digits
/// ("١٢٤"), any other label (e.g. "A-12") is returned trimmed and unchanged.
String localizedNumericText(String raw, String languageCode) {
  final String value = raw.trim();
  final int? numeric = int.tryParse(value);
  return numeric == null ? value : localizedNumber(numeric, languageCode);
}
