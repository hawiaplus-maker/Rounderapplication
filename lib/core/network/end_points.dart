class EndPoints {
  static const String baseUrl = 'https://rounder-sa.com';
  static const String validateMobile = '$baseUrl/api/v1/auth/validate-mobile';
  static const String register = '$baseUrl/api/v1/auth/register';
  static const String sendOtp = '$baseUrl/api/v1/auth/send-otp';
  static const String verifyOtp = '$baseUrl/api/v1/auth/verify-otp';
  static const String login = '$baseUrl/api/v1/auth/login';
  static const String me = '$baseUrl/api/v1/me';
  static const String logout = '$baseUrl/api/v1/auth/logout';

  /// Resident account: `GET` reads the profile, `PUT` updates it — the
  /// backend exposes no POST on this route.
  static const String profile = '$baseUrl/api/v1/resident/profile';

  /// Resident notifications: `GET` lists them, `PUT {id}/read` marks one.
  static const String notifications = '$baseUrl/api/v1/resident/notifications';
  static String notificationRead(int id) => '$notifications/$id/read';

  /// Resident linked homes: `GET` lists them; linking a new one is the
  /// dashboard's `POST /resident/homes/link`.
  static const String homes = '$baseUrl/api/v1/resident/homes';

  /// Add a new residence unit (POST). Body: name, address, district, city_id,
  /// residence_type, area_sqm, floor_number, ownership_type, unit_number,
  /// is_primary.
  static const String addUnit = '$baseUrl/api/v1/resident/homes/add-unit';

  /// Cities list (GET) — paginated; used by the add-unit screen's city picker.
  static const String cities = '$baseUrl/api/v1/resident/cities';

  static const String getServiceCategories =
      '$baseUrl/api/v1/resident/service-categories';

  /// Emergency types: `GET` lists the available emergency categories.
  static const String emergencyTypes =
      '$baseUrl/api/v1/resident/emergency-types';

  /// Emergency requests: `POST` creates a new emergency request.
  static const String emergencyRequests =
      '$baseUrl/api/v1/resident/emergency-requests';
}
