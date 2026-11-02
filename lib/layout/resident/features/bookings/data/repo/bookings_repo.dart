import 'package:rounder_application/core/network/api_consumer.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/resident/features/bookings/data/model/booking_item_model.dart';

class BookingsRepository {
  BookingsRepository(this.api);

  final ApiConsumer api;

  Future<List<BookingItem>> list() async {
    final r = await api.get<Map<String, dynamic>>('/resident/bookings');
    final body = r.data ?? const <String, dynamic>{};
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
    final Object? data = body['data'];
    List<Object?> values;
    if (data is List) {
      values = data;
    } else if (data is Map) {
      // Single booking object, or paginated `{data: [...]}`.
      if (data['data'] is List) {
        values = data['data'] as List;
      } else if (data['id'] != null) {
        values = <Object?>[data];
      } else {
        values = const <Object?>[];
      }
    } else if (body['bookings'] is List) {
      values = body['bookings'] as List;
    } else {
      values = const <Object?>[];
    }
    return values
        .whereType<Map<String, dynamic>>()
        .map(BookingItem.fromJson)
        .toList();
  }

  Future<void> cancel(int id, String reason) async {
    await api.post('/resident/bookings/$id/cancel', data: {'reason': reason});
  }
}
