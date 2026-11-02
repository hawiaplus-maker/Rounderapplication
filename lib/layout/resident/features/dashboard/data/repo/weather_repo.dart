import 'package:easy_localization/easy_localization.dart' show Intl;
import 'package:flutter/widgets.dart' show Locale;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rounder_application/core/network/api_consumer.dart';

import 'package:rounder_application/layout/resident/features/dashboard/data/model/weather_model.dart';

/// Device location → city name → Open-Meteo current weather. Cloud-agnostic
/// (no key). When the location is denied or broken the weather falls back to
/// the app's default city, and the top bar keeps its placeholders for whatever
/// piece is missing — the section never blocks the home loading.
class WeatherRepository {
  WeatherRepository(this.api);
  final ApiConsumer api;

  /// Dammam fallback (the home's default city) when the device location is
  /// unavailable, denied or timed out.
  static const double _fallbackLat = 26.4207, _fallbackLng = 50.0888;

  /// Permission, position and reverse geocoding are all best effort: any
  /// failure degrades to the fallback coordinates / an empty city name and the
  /// caller still gets the weather part.
  Future<WeatherInfo> getWeather() async {
    bool fellBack = false;
    double lat = _fallbackLat, lng = _fallbackLng;

    // Prefer a cached last-known position so the top bar resolves the real
    // city quickly even when a fresh GPS fix is slow or unavailable.
    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        lat = last.latitude;
        lng = last.longitude;
        fellBack = false;
      } else {
        throw StateError('no last known position');
      }
    } catch (_) {
      try {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever ||
            permission == LocationPermission.unableToDetermine) {
          throw StateError('location permission denied: $permission');
        }
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 3),
          ),
        );
        lat = position.latitude;
        lng = position.longitude;
        fellBack = false;
      } catch (_) {
        fellBack = true;
        lat = _fallbackLat;
        lng = _fallbackLng;
      }
    }

    final String city = await _resolveCity(lat, lng);

    final response = await api.get<Map<String, dynamic>>(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$lat&longitude=$lng'
      '&current=temperature_2m,weather_code&timezone=auto',
    );
    return WeatherInfo.fromJson(
      response.data ?? const <String, dynamic>{},
      city: city,
      cityFellBack: fellBack,
    );
  }

  /// Reverse geocoding is optional decoration: an empty/failed lookup yields
  /// no city name instead of failing the whole weather fetch.
  Future<String> _resolveCity(double lat, double lng) async {
    try {
      final language = Intl.getCurrentLocale().split('_').first;
      final geocoding = Geocoding(locale: Locale(language));
      final marks = await geocoding.placemarkFromCoordinates(lat, lng).timeout(
        const Duration(seconds: 5),
      );
      for (final mark in marks) {
        final String candidate = (mark.locality?.trim() ?? '').isNotEmpty
            ? mark.locality!.trim()
            : (mark.administrativeArea?.trim() ?? '');
        if (candidate.isNotEmpty) return candidate;
      }
    } catch (_) {
      // Reverse geocoding is usually offline-glitchy; the placeholder wins.
    }
    return '';
  }
}