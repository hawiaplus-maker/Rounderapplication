import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Bridges easy_localization's locale with the rest of the app.
///
/// easy_localization swaps the translated strings but leaves `Intl` on its
/// startup default. `Intl` is what the network layer reads for the
/// `Accept-Language` header and what `DateFormat`/`NumberFormat` use, so it
/// must follow the selected language: otherwise the API keeps answering in the
/// old language and dates stay formatted for it.
void syncIntlLocale(Locale locale) {
  Intl.defaultLocale = locale.toLanguageTag();
}

final StreamController<Locale> _localeChanges =
    StreamController<Locale>.broadcast();

/// Emits the new locale after every app language change.
Stream<Locale> get appLocaleChanges => _localeChanges.stream;

/// Applies [locale] to `Intl` and tells the locale-aware cubits to refetch.
///
/// Called once a language change succeeded; every [LocaleAwareCubit] listening
/// reloads its data so no screen keeps text fetched in the previous language.
void notifyLocaleChanged(Locale locale) {
  syncIntlLocale(locale);
  _localeChanges.add(locale);
}
