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

  /// Resident linked homes: `GET` lists them, `DELETE {id}` removes one;
  /// linking a new one is [linkHome].
  static const String homes = '$baseUrl/api/v1/resident/homes';

  /// Removes one linked unit (`DELETE`).
  static String homeDelete(int id) => '$homes/$id';

  /// Link a residence to the account (POST): property_code, unit_label.
  static const String linkHome = '$baseUrl/api/v1/resident/homes/link';

  /// Add a new residence unit (POST). Body: name, address, district, city_id,
  /// residence_type, area_sqm, floor_number, ownership_type, unit_number,
  /// is_primary.
  static const String addUnit = '$baseUrl/api/v1/resident/homes/add-unit';

  /// Cities list (GET) — paginated; used by the add-unit screen's city picker.
  static const String cities = '$baseUrl/api/v1/resident/cities';

  /// Resident dashboard summary (GET) — the home screen payload.
  static const String dashboard = '$baseUrl/api/v1/resident/dashboard';

  static const String getServiceCategories =
      '$baseUrl/api/v1/resident/service-categories';

  /// Bookable services catalog (GET).
  static const String services = '$baseUrl/api/v1/resident/services';

  /// Sub-services of one service (GET) — paginated with `page`, `per_page`
  /// and `service_id` query parameters.
  static const String subServices = '$baseUrl/api/v1/resident/sub-services';

  /// Service providers (GET) — filtered by `service_id`, `sub_service` and
  /// `home_id` query parameters.
  static const String serviceProviders =
      '$baseUrl/api/v1/resident/service-providers';

  /// Emergency types: `GET` lists the available emergency categories.
  static const String emergencyTypes =
      '$baseUrl/api/v1/resident/emergency-types';

  /// Emergency requests: `GET` lists requests and `POST` creates one.
  static const String emergencyRequests =
      '$baseUrl/api/v1/resident/emergency-requests';

  /// Bookings: `GET` lists them, `POST` creates one (multipart: home_id,
  /// service_id, sub_service_id, service_provider_id, price_id, scheduled_at,
  /// notes, images[]).
  static const String bookings = '$baseUrl/api/v1/resident/bookings';

  /// Cancel a booking (POST) with a `{reason}` body.
  static String bookingCancel(int id) => '$bookings/$id/cancel';

  /// Rate a completed booking (POST) with `{rating, comment, tags}`.
  static String bookingRating(int id) => '$bookings/$id/rating';

  /// Third-party Open-Meteo current weather (external, key-less): `latitude`,
  /// `longitude`, `current` and `timezone` query parameters.
  static const String weatherForecast =
      'https://api.open-meteo.com/v1/forecast';
}
