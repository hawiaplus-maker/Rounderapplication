import 'package:rounder_application/logic/weather_logic.dart';

/// Live weather shown on the home top bar: the device's city as the geocoder
/// resolved it and the Open-Meteo current conditions at those coordinates.
class WeatherInfo {
  const WeatherInfo({
    this.city = '',
    required this.tempC,
    required this.kind,
    this.cityFellBack = false,
  });

  /// Locality name from reverse geocoding; empty when the geocoder had
  /// nothing (the widget shows its placeholder then).
  final String city;

  /// Current temperature in Celsius.
  final double tempC;

  /// Icon/label family resolved from Open-Meteo's `weather_code`.
  final WeatherKind kind;

  /// True when [city] is the app's default city because the device location
  /// was unavailable or denied (the widget localizes the name).
  final bool cityFellBack;

  /// Open-Meteo `current` block (`temperature_2m`, `weather_code`); missing or
  /// malformed fields fall back to zero degrees / partly cloudy.
  factory WeatherInfo.fromJson(
    Map<String, dynamic> json, {
    String city = '',
    bool cityFellBack = false,
  }) {
    final current = json['current'] is Map ? json['current'] as Map : json;
    return WeatherInfo(
      city: city,
      cityFellBack: cityFellBack,
      tempC: double.tryParse('${current['temperature_2m'] ?? ''}') ?? 0,
      kind: weatherKindFromCode(
        int.tryParse('${current['weather_code'] ?? ''}') ?? -1,
      ),
    );
  }
}
