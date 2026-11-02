part of 'weather_cubit.dart';

sealed class WeatherState {}

/// Never fetched (or awaiting a retry): the top bar shows its placeholders.
class WeatherPending extends WeatherState {}

/// Live data ready (with the device's city or the app's default city).
class WeatherReady extends WeatherState {
  WeatherReady(this.info);
  final WeatherInfo info;
}

/// Fetch failed entirely: the top bar keeps its placeholders.
class WeatherFailed extends WeatherState {}
