/// OAuth configuration that is not a secret (client IDs are public).
///
/// Pass the values at build time, e.g.:
/// `flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=xxxx.apps.googleusercontent.com`
class AuthConfig {
  const AuthConfig._();

  /// Google **Web** OAuth client ID (Google Cloud Console → Credentials →
  /// OAuth 2.0 Client IDs → "Web application"). Required on Android so the
  /// SDK returns an `id_token`; on iOS it is optional when
  /// `GoogleService-Info.plist` is present.
  ///
  /// The default is the "Rounder Web" client of project 628249143147 (public
  /// data, not a secret). Override with
  /// `--dart-define=GOOGLE_SERVER_CLIENT_ID=...`.
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '628249143147-dn1pv2jnmahu0v3vgblfllmhimn9gf0u'
        '.apps.googleusercontent.com',
  );

  /// Apple Service ID used by the web flow on Android (Apple Developer →
  /// Identifiers → Services IDs). Empty keeps the native iOS flow only.
  static const String appleServiceId = String.fromEnvironment(
    'APPLE_SERVICE_ID',
    defaultValue: '',
  );

  /// Redirect URI registered for the Apple Service ID (must match the backend
  /// callback).
  static const String appleRedirectUri = String.fromEnvironment(
    'APPLE_REDIRECT_URI',
    defaultValue: 'https://rounder-sa.com/api/v1/auth/apple/callback',
  );
}
