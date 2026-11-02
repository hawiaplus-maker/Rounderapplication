import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounder_application/core/network/api_consumer.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_category_model.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_option_model.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_provider_model.dart';

class ServicesRepository {
  ServicesRepository(this.api);

  final ApiConsumer api;

  Future<List<ServiceOption>> list() async {
    final r = await api.get<Map<String, dynamic>>('/resident/services');
    final data = r.data?['data'];
    if (data is! List) return [];
    return data.whereType<Map<String, dynamic>>().map(ServiceOption.fromJson).toList();
  }

  Future<List<ServiceCategory>> categories() async {
    final r = await api.get<Map<String, dynamic>>('/resident/service-categories');
    final data = r.data?['data'];
    if (data is! List) return [];
    return data.whereType<Map<String, dynamic>>().map(ServiceCategory.fromJson).toList();
  }

  Future<List<ServiceProvider>> serviceProviders(int serviceId) async {
    final r = await api.get<Map<String, dynamic>>(
        '/resident/service-providers?service_id=$serviceId');
    final data = r.data?['data'];
    if (data is! List) return [];
    return data.whereType<Map<String, dynamic>>().map(ServiceProvider.fromJson).toList();
  }

  Future<void> book({
    required int homeId,
    required int serviceId,
    required DateTime date,
    int? subServiceId,
    int? serviceProviderId,
    String? notes,
    List<XFile>? images,
  }) async {
    final form = FormData();
    form.fields
      ..add(MapEntry('home_id', '$homeId'))
      ..add(MapEntry('service_id', '$serviceId'))
      ..add(MapEntry('sub_service_id', '${subServiceId ?? ''}'))
      ..add(MapEntry('service_provider_id', '${serviceProviderId ?? ''}'))
      ..add(MapEntry('scheduled_at', date.toIso8601String()))
      ..add(MapEntry('notes', notes ?? ''));
    if (images != null) {
      for (final f in images) {
        form.files.add(MapEntry(
          'images[]',
          await MultipartFile.fromFile(f.path, filename: f.name),
        ));
      }
    }
    final response = await api.post<Map<String, dynamic>>(
      '/resident/bookings',
      data: form,
    );
    final Map<String, dynamic> body =
        response.data ?? const <String, dynamic>{};
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
  }

  String get errorKey => 'connection_error';
}
