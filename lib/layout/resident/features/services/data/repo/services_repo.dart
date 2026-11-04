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

  /// The catalog snapshot carries only this many sub-services per service;
  /// the rest are paged through [subServices].
  static const int subServicesLimit = 7;

  /// Page size of the paginated sub-services endpoint.
  static const int subServicesPerPage = 10;

  Future<List<ServiceOption>> list() async {
    final r = await api.get<Map<String, dynamic>>('/resident/services');
    final data = r.data?['data'];
    if (data is! List) return [];
    return data.whereType<Map<String, dynamic>>().map(ServiceOption.fromJson).toList();
  }

  Future<List<ServiceCategory>> categories() async {
    final r = await api.get<Map<String, dynamic>>(
      '/resident/service-categories?sub_services_limit=$subServicesLimit',
    );
    final data = r.data?['data'];
    if (data is! List) return [];
    return data.whereType<Map<String, dynamic>>().map(ServiceCategory.fromJson).toList();
  }

  /// Loads one page of a service's sub-services ([page] starts at 1). Whether
  /// the page is the last is taken from the shape's `last_page` (top level,
  /// inside `meta` or inside the paged `data` map) — without one, fetching a
  /// full page implies more pages may follow.
  Future<ServiceSubItemPage> subServices({required int serviceId, required int page}) async {
    final r = await api.get<Map<String, dynamic>>(
      '/resident/sub-services'
      '?page=$page&per_page=$subServicesPerPage&service_id=$serviceId',
    );
    final Map<String, dynamic> body = r.data ?? const <String, dynamic>{};
    final Object? data = body['data'];
    final List<Object?> values = data is List
        ? data
        : (data is Map && data['data'] is List)
        ? data['data'] as List
        : const <Object?>[];
    final items = values.whereType<Map<String, dynamic>>().map(ServiceSubItem.fromJson).toList();
    final Object? meta = body['meta'] ?? (data is Map ? data['meta'] : const <Object?>{});
    final Object? lastPageValue =
        (meta is Map ? meta['last_page'] : null) ?? (data is Map ? data['last_page'] : null);
    final int? lastPage = lastPageValue == null ? null : int.tryParse('$lastPageValue');
    return ServiceSubItemPage(
      items: items,
      hasMore: lastPage != null ? page < lastPage : items.length == subServicesPerPage,
    );
  }

  Future<List<ServiceProvider>> serviceProviders({
    required int serviceId,
    int? subServiceId,
    int? homeId,
  }) async {
    final queryParameters = <String, String>{
      'service_id': '$serviceId',
      if (subServiceId != null) 'sub_service': '$subServiceId',
      if (homeId != null) 'home_id': '$homeId',
    };
    final query = Uri(queryParameters: queryParameters).query;
    final r = await api.get<Map<String, dynamic>>('/resident/service-providers?$query');
    final data = r.data?['data'];
    if (data is! List) return [];
    return data.whereType<Map<String, dynamic>>().map(ServiceProvider.fromJson).toList();
  }

  /// Creates the booking and returns its backend id (parsed from the
  /// response's `data.id` / `booking_id`); null when the body omits it — the
  /// rating step then keeps working in its prototype mode.
  Future<int?> book({
    required int homeId,
    required int serviceId,
    required DateTime date,
    int? subServiceId,
    int? serviceProviderId,
    int? priceId,
    String? notes,
    List<XFile>? images,
  }) async {
    final form = FormData();
    form.fields
      ..add(MapEntry('home_id', '$homeId'))
      ..add(MapEntry('service_id', '$serviceId'))
      ..add(MapEntry('sub_service_id', '${subServiceId ?? ''}'))
      ..add(MapEntry('service_provider_id', '${serviceProviderId ?? ''}'))
      ..add(MapEntry('price_id', '${priceId ?? ''}'))
      ..add(MapEntry('scheduled_at', date.toIso8601String()))
      ..add(MapEntry('notes', notes ?? ''));
    if (images != null) {
      for (final f in images) {
        form.files.add(
          MapEntry('images[]', await MultipartFile.fromFile(f.path, filename: f.name)),
        );
      }
    }
    final response = await api.post<Map<String, dynamic>>('/resident/bookings', data: form);
    final Map<String, dynamic> body = response.data ?? const <String, dynamic>{};
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
    final Object? data = body['data'];
    final Object? rawId = data is Map && data['booking'] is Map
        ? (data['id'] ?? data['booking_id'] ?? (data['booking'] as Map)['id'])
        : body['booking_id'];
    return int.tryParse('${rawId ?? ''}');
  }

  String get errorKey => 'connection_error';
}
