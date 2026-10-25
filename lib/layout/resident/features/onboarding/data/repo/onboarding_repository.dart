import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists whether the resident already went through the first-launch
/// onboarding (approved frames 00.1–00.3) so it shows exactly once per install.
class OnboardingRepository {
  OnboardingRepository(this._storage);
  final FlutterSecureStorage _storage;

  static const _seenKey = 'rounder_onboarding_seen';

  Future<bool> hasSeenIntro() async => (await _storage.read(key: _seenKey)) != null;

  Future<void> markIntroSeen() => _storage.write(key: _seenKey, value: 'true');
}
