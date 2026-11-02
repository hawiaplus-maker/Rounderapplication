import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_locale.dart';

/// Base class for cubits whose state is fetched from the API and may contain
/// localized text (service names, statuses, unit addresses, weather city…).
///
/// The backend answers in the language sent through `Accept-Language`, so the
/// data fetched before a language change is stale afterwards. Such cubits
/// reload themselves whenever the resident switches language, whether they are
/// alive in a background tab or created later.
abstract class LocaleAwareCubit<S> extends Cubit<S> {
  LocaleAwareCubit(super.initialState) {
    _localeSubscription = appLocaleChanges.listen((_) {
      if (!isClosed) unawaited(reloadForLocale());
    });
  }

  StreamSubscription<Locale>? _localeSubscription;

  /// Refetches the state in the locale that is now selected.
  Future<void> reloadForLocale();

  @override
  Future<void> close() async {
    await _localeSubscription?.cancel();
    await super.close();
  }
}
