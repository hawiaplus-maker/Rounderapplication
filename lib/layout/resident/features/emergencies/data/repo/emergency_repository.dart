import 'package:rounder_application/core/network/api_consumer.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/core/network/end_points.dart';
import 'package:rounder_application/layout/resident/features/emergencies/data/model/emergency_request_model.dart';
import 'package:rounder_application/layout/resident/features/emergencies/data/model/emergency_type_model.dart';

/// Emergency types, request history, and emergency-request submission.
class EmergencyRepository {
  EmergencyRepository(this.api);

  final ApiConsumer api;

  /// Available emergency categories (fire, medical, gas leak, …). Names come
  /// from the backend already localized through `Accept-Language`.
  Future<List<EmergencyType>> list() async {
    final response = await api.get<Map<String, dynamic>>(
      EndPoints.emergencyTypes,
    );
    final Map<String, dynamic> body =
        response.data ?? const <String, dynamic>{};
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
    final Object? data = body['data'];
    final List<Object?> values = data is List ? data : const <Object?>[];
    return values
        .whereType<Map<String, dynamic>>()
        .map(EmergencyType.fromJson)
        .toList();
  }

  /// Lists submitted emergency requests for the signed-in resident.
  Future<List<EmergencyRequestItem>> listRequests() async {
    final response = await api.get<Map<String, dynamic>>(
      EndPoints.emergencyRequests,
    );
    final Map<String, dynamic> body =
        response.data ?? const <String, dynamic>{};
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }

    Object? values =
        body['data'] ?? body['emergency_requests'] ?? body['requests'];
    while (values is Map) {
      if (values['data'] is List) {
        values = values['data'];
      } else if (values['emergency_requests'] is List) {
        values = values['emergency_requests'];
      } else if (values['requests'] is List) {
        values = values['requests'];
      } else if (values['id'] != null) {
        values = <Object?>[values];
      } else {
        values = const <Object?>[];
      }
    }
    if (values is! List) return const <EmergencyRequestItem>[];
    return values
        .whereType<Map>()
        .map(
          (item) =>
              EmergencyRequestItem.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  /// Creates a new emergency request. Returns the raw response body so the
  /// caller can surface the reference the backend assigns.
  Future<Map<String, dynamic>?> submit({
    required int residentHomeId,
    required int emergencyTypeId,
    required String contactPhone,
    required String locationDetails,
    required String description,
    required bool confirmEmergency,
  }) async {
    final response = await api.post<Map<String, dynamic>>(
      EndPoints.emergencyRequests,
      data: <String, dynamic>{
        'resident_home_id': residentHomeId,
        'emergency_type_id': emergencyTypeId,
        'contact_phone': contactPhone,
        'location_details': locationDetails,
        'description': description,
        'confirm_emergency': confirmEmergency,
      },
    );
    final Map<String, dynamic> body =
        response.data ?? const <String, dynamic>{};
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
    return body;
  }
}
