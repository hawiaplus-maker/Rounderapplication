/// Fallback of a data field that has not been provided: missing values render
/// as nothing — the UI hides them instead of painting dashes or zeros.
abstract final class DisplayPlaceholder {
  static const String text = '';

  static const int number = 0;

  /// Zero for ratio/progress values, which need a [double] in const widgets.
  static const double progress = 0;
}
