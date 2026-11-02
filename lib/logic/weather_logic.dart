/// Pure weather domain rules (rounder-logic): the WMO weather codes returned
/// by Open-Meteo mapped to the app's weather kinds, plus the temperature
/// presentation. No UI text here — the widget resolves the kind's label key.
library;

import 'package:rounder_application/logic/number_text_logic.dart';

/// The weather families the home top bar can illustrate.
enum WeatherKind { sunny, cloudy, rain, snow, fog, storm }

/// Maps an Open-Meteo `current.weather_code` (WMO 4677) to a [WeatherKind];
/// unknown codes read as partly cloudy, never as rain or storm.
WeatherKind weatherKindFromCode(int code) {
  if (code == 0) return WeatherKind.sunny;
  if (code >= 1 && code <= 3) return WeatherKind.cloudy;
  if (code == 45 || code == 48) return WeatherKind.fog;
  if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
    return WeatherKind.rain;
  }
  if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
    return WeatherKind.snow;
  }
  if (code >= 95) return WeatherKind.storm;
  return WeatherKind.cloudy;
}

/// Temperature as displayed next to it: `32°` with the interface digits —
/// Arabic-Indic `٣٢°` in Arabic, Latin `32°` otherwise.
String weatherCelsiusText(num celsius, String languageCode) =>
    '${localizedNumber(celsius.round(), languageCode)}°';
