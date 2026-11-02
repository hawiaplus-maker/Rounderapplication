import 'package:rounder_application/core/network/api_consumer.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/core/network/end_points.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/resident_profile_model.dart';

/// Resident account profile: read on entering the account tab, written by the
/// edit page. The backend route accepts `GET` and `PUT` only.
class ProfileRepository {
  ProfileRepository(this.api);

  final ApiConsumer api;

  Future<ResidentProfile> get() async {
    final response = await api.get<Map<String, dynamic>>(EndPoints.profile);
    return ResidentProfile.fromJson(_data(response.data));
  }

  /// Name and email are the fields the edit page owns. The phone is not sent:
  /// changing it needs the verification endpoints the backend does not expose
  /// yet, so an unverified number must never reach the account.
  Future<void> update({
    required String name,
    required String email,
    String? locale,
  }) async {
    final data = <String, dynamic>{'name': name, 'email': email};
    if (locale != null && locale.isNotEmpty) data['locale'] = locale;
    final response = await api.put<Map<String, dynamic>>(
      EndPoints.profile,
      data: data,
    );
    final Map<String, dynamic>? body = response.data;
    if (body != null && body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
  }

  /// Persists the resident's preferred language on the backend. Other
  /// endpoints (services, bookings, ...) answer in this language, so it must
  /// be updated before refetching data after a language switch.
  Future<void> setLocale(String locale) async {
    final response = await api.put<Map<String, dynamic>>(
      EndPoints.profile,
      data: {'locale': locale},
    );
    final Map<String, dynamic>? body = response.data;
    if (body != null && body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
  }
  /// The user object of the envelope, or the bare body when it carries no
  /// `data` wrapper.
  Map<String, dynamic> _data(Map<String, dynamic>? body) {
    if (body == null) return const <String, dynamic>{};
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
    final Object? data = body['data'];
    return data is Map<String, dynamic> ? data : body;
  }
}
