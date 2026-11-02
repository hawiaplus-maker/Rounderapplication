/// Model of one row of `GET ${EndPoints.notifications}`. Fields are read
/// defensively with the aliases the backend may use; an item without an id
/// cannot be marked read and is dropped by the repository.
class NotificationItem {
  const NotificationItem({
    this.id,
    required this.title,
    this.body = '',
    this.context = '',
    this.createdAt,
    this.isRead = false,
    this.requiresAction = false,
    this.actionLabel = '',
    this.referenceType,
    this.referenceId,
  });

  final int? id;
  final String title, body, context, actionLabel;
  final DateTime? createdAt;
  final bool isRead, requiresAction;
  /// Stored for potential navigation (e.g. opening the related booking).
  final String? referenceType;
  final int? referenceId;

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
    id: id,
    title: title,
    body: body,
    context: context,
    createdAt: createdAt,
    isRead: isRead ?? this.isRead,
    requiresAction: requiresAction,
    actionLabel: actionLabel,
    referenceType: referenceType,
    referenceId: referenceId,
  );

  factory NotificationItem.fromJson(Map<String, dynamic> j) {
    final Object? readAt = j['read_at'];
    final Object? action = j['action'];
    final Object? referenceTypeRaw = j['reference_type'] ?? j['referenceType'];
    final Object? referenceIdRaw = j['reference_id'] ?? j['referenceId'];
    return NotificationItem(
      id: int.tryParse('${j['id']}'),
      title: _text(j, const ['title', 'subject']) ?? '',
      body: _text(j, const ['body', 'message', 'description']) ?? '',
      context: _text(j, const ['context', 'subtitle', 'reference']) ?? '',
      createdAt: DateTime.tryParse(
        _text(j, const ['created_at', 'date', 'sent_at']) ?? '',
      ),
      isRead:
          j['is_read'] == true ||
          j['read'] == true ||
          (readAt != null && readAt.toString().isNotEmpty),
      requiresAction:
          j['requires_action'] == true ||
          j['action_required'] == true ||
          j['needs_action'] == true,
      actionLabel:
          _text(j, const ['action_label', 'action_text']) ??
          (action is Map<String, dynamic>
              ? _text(action, const ['label'])
              : null) ??
          '',
      referenceType: referenceTypeRaw == null
          ? null
          : referenceTypeRaw.toString().trim().isEmpty
              ? null
              : referenceTypeRaw.toString().trim(),
      referenceId: referenceIdRaw == null
          ? null
          : int.tryParse('$referenceIdRaw'),
    );
  }

  static String? _text(Map<String, dynamic> j, List<String> keys) {
    for (final String key in keys) {
      final Object? value = j[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }
}
