import 'package:rounder_application/core/network/api_consumer.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/core/network/end_points.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/notification_item_model.dart';

/// Resident notifications: the list the notifications page renders and the
/// per-item read acknowledgement. The backend has no bulk-read route, so
/// "mark all read" is one `PUT` per unread item.
class NotificationsRepository {
  NotificationsRepository(this.api);

  final ApiConsumer api;

  Future<List<NotificationItem>> list() async {
    final response = await api.get<Map<String, dynamic>>(
      EndPoints.notifications,
    );
    final Object? rawBody = response.data;
    final Map<String, dynamic> body = rawBody is Map<String, dynamic>
        ? rawBody
        : const <String, dynamic>{};
    // Tolerate envelopes without a `status` field: only an explicit `false`
    // counts as a business failure.
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
    return _values(body)
        .whereType<Map<String, dynamic>>()
        .map(NotificationItem.fromJson)
        .where((NotificationItem item) => item.id != null)
        .toList();
  }

  Future<void> markRead(int id) async {
    final response = await api.put<Map<String, dynamic>>(
      EndPoints.notificationRead(id),
    );
    final Object? rawBody = response.data;
    if (rawBody is Map<String, dynamic> && rawBody['status'] == false) {
      throw ApiFailure(rawBody['message']?.toString() ?? '');
    }
  }

  Future<void> markAllRead(Iterable<int> ids) async {
    for (final int id in ids) {
      await markRead(id);
    }
  }

  /// `data: [...]`, a paginated `data: {data: [...]}`, or a bare list body.
  List<Object?> _values(Map<String, dynamic> body) {
    final Object? data = body['data'];
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    if (body['notifications'] is List) return body['notifications'] as List;
    return const <Object?>[];
  }
}
