class EmergencyRequestItem {
  const EmergencyRequestItem({
    required this.id,
    required this.reference,
    required this.typeName,
    required this.statusName,
    required this.location,
    required this.description,
    required this.contactPhone,
    required this.createdAt,
  });

  final int id;
  final String reference;
  final String typeName;
  final String statusName;
  final String location;
  final String description;
  final String contactPhone;
  final String createdAt;

  factory EmergencyRequestItem.fromJson(Map<String, dynamic> json) {
    final emergencyType = _map(json['emergency_type'] ?? json['type']);
    final status = _map(json['status']);
    final id = int.tryParse('${json['id'] ?? ''}') ?? 0;

    return EmergencyRequestItem(
      id: id,
      reference: _firstText(json, const [
        'reference',
        'reference_no',
        'request_reference',
      ]).ifEmpty(id == 0 ? '' : id.toString()),
      typeName: _firstText(json, const [
        'emergency_type_name',
        'type_name',
        'type',
      ], nested: emergencyType),
      statusName: _firstText(json, const [
        'status_name',
        'status_label',
        'status',
      ], nested: status),
      location: _firstText(json, const [
        'location_details',
        'location',
        'address',
      ]),
      description: _firstText(json, const [
        'description',
        'details',
        'message',
      ]),
      contactPhone: _firstText(json, const ['contact_phone', 'phone']),
      createdAt: _firstText(json, const ['created_at', 'submitted_at']),
    );
  }
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const <String, dynamic>{};

String _firstText(
  Map<String, dynamic> source,
  List<String> keys, {
  Map<String, dynamic> nested = const <String, dynamic>{},
}) {
  for (final key in keys) {
    final value = source[key] ?? nested[key];
    if (value == null || value is Map) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  final nestedName = nested['name']?.toString().trim();
  return nestedName ?? '';
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
