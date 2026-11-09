/// One support ticket returned by `POST /resident/support/tickets`. The
/// reference is what the success page shows; [createdAt] is the reception time
/// when the backend sends it.
class SupportTicket {
  const SupportTicket({
    this.id,
    this.reference = '',
    this.status = '',
    this.createdAt,
  });

  final int? id;
  final String reference, status;
  final DateTime? createdAt;

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = _unwrap(json);
    final int? id = int.tryParse('${data['id'] ?? ''}');
    return SupportTicket(
      id: id,
      reference: _text(data, const [
        'reference',
        'ticket_number',
        'ticket_no',
        'number',
        'code',
      ]).ifEmpty(id?.toString() ?? ''),
      status: _text(data, const ['status_name', 'status', 'state']),
      createdAt: DateTime.tryParse(
        _text(data, const ['created_at', 'submitted_at', 'date']),
      )?.toLocal(),
    );
  }
}

/// `{data: {...}}`, `{ticket: {...}}` or the object itself.
Map<String, dynamic> _unwrap(Map<String, dynamic> json) {
  final Object? data = json['data'];
  if (data is Map) return _unwrap(Map<String, dynamic>.from(data));
  final Object? ticket = json['ticket'];
  return ticket is Map ? Map<String, dynamic>.from(ticket) : json;
}

String _text(Map<String, dynamic> json, List<String> keys) {
  for (final String key in keys) {
    final Object? value = json[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    if (value is num) return value.toString();
  }
  return '';
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
