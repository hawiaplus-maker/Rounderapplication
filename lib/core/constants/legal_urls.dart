/// Hosted legal documents. Replace the placeholder values with the real URLs
/// before submitting to the stores — both Google Play and the App Store require
/// a publicly reachable privacy policy, and App Review expects the in-app link
/// to open it.
class LegalUrls {
  const LegalUrls._();

  /// Privacy policy URL (must be hosted and reachable without login).
  static const String privacyPolicy = 'https://rounder-sa.com/privacy';

  /// Terms & conditions URL.
  static const String termsConditions = 'https://rounder-sa.com/terms';

  static bool isConfigured(String url) =>
      url.trim().isNotEmpty && !url.contains('REPLACE_ME');
}
