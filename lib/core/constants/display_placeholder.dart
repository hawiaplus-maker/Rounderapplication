/// Values shown when a data field has not been provided yet: numbers read `0`
/// and every other value reads dashes, so the layouts keep their shape without
/// showing sample content.
abstract final class DisplayPlaceholder {
  static const String text = '----';

  static const int number = 0;

  /// Zero for ratio/progress values, which need a [double] in const widgets.
  static const double progress = 0;
}
