class EndPoints {
  static const String baseUrl = 'https://rounder-sa.com';
  static const String validateMobile = '$baseUrl/api/v1/auth/validate-mobile';
  static const String register = '$baseUrl/api/v1/auth/register';
  static const String sendOtp = '$baseUrl/api/v1/auth/send-otp';
  static const String verifyOtp = '$baseUrl/api/v1/auth/verify-otp';
  static const String login = '$baseUrl/api/v1/auth/login';
  static const String me = '$baseUrl/api/v1/me';
  static const String logout = '$baseUrl/api/v1/auth/logout';
  static const String getProfile = '$baseUrl/api/v1/resident/profile';
  static const String updateProfile = '$baseUrl/api/v1/resident/profile';
}
