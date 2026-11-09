/// Support channels returned by `GET /resident/support/info`. The fields are
/// read defensively with the aliases the backend may use; an empty value lets
/// the contact page fall back to its localized defaults.
class SupportInfo {
  const SupportInfo({
    this.phone = '',
    this.email = '',
    this.workingHours = '',
    this.whatsapp = '',
    this.address = '',
    this.categories = const [],
  });

  final String phone, email, workingHours, whatsapp, address;

  /// Ticket categories exposed by the backend (already localized). Empty when
  /// the endpoint does not return them, in which case the form keeps its
  /// built-in categories.
  final List<SupportCategory> categories;

  factory SupportInfo.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = _unwrap(json);
    return SupportInfo(
      phone: _text(data, const [
        'phone',
        'support_phone',
        'contact_phone',
        'mobile',
      ]),
      email: _text(data, const ['email', 'support_email', 'contact_email']),
      workingHours: _text(data, const [
        'working_hours',
        'workingHours',
        'support_hours',
        'support_working_hours',
        'business_hours',
        'chat_hours',
        'hours',
      ]),
      whatsapp: _text(data, const [
        'whatsapp',
        'whatsapp_number',
        'chat_phone',
      ]),
      address: _text(data, const ['address', 'location']),
      categories: _categories(data),
    );
  }
}

/// One ticket category of the support form. [value] is what the tickets
/// endpoint validates against; [label] is the display text.
class SupportCategory {
  const SupportCategory({required this.value, required this.label});

  final String value, label;

  factory SupportCategory.fromJson(Object? json) {
    if (json is String && json.trim().isNotEmpty) {
      final String value = json.trim();
      return SupportCategory(value: value, label: value);
    }
    if (json is Map) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(json);
      final String value = _text(map, const [
        'value',
        'code',
        'slug',
        'key',
        'id',
      ]);
      final String label = _text(map, const ['name', 'title', 'label']);
      return SupportCategory(
        value: value.isEmpty ? label : value,
        label: label.isEmpty ? value : label,
      );
    }
    return const SupportCategory(value: '', label: '');
  }
}

List<SupportCategory> _categories(Map<String, dynamic> data) {
  final Object? raw =
      data['categories'] ??
      data['ticket_categories'] ??
      data['support_categories'] ??
      data['types'] ??
      data['subjects'];
  if (raw is List) {
    return raw
        .map(SupportCategory.fromJson)
        .where((SupportCategory category) => category.value.isNotEmpty)
        .toList();
  }
  // `{id: label}` maps are accepted as well.
  if (raw is Map) {
    return raw.entries
        .map(
          (MapEntry<Object?, Object?> entry) => SupportCategory(
            value: entry.key.toString(),
            label: entry.value.toString(),
          ),
        )
        .where((SupportCategory category) => category.value.isNotEmpty)
        .toList();
  }
  return const [];
}

/// `{data: {...}}`, `{support: {...}}` or the object itself.
Map<String, dynamic> _unwrap(Map<String, dynamic> json) {
  final Object? data = json['data'];
  if (data is Map) return _unwrap(Map<String, dynamic>.from(data));
  final Object? support = json['support'] ?? json['info'];
  return support is Map ? Map<String, dynamic>.from(support) : json;
}

String _text(Map<String, dynamic> json, List<String> keys) {
  for (final String key in keys) {
    final Object? value = json[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    if (value is num) return value.toString();
  }
  return '';
}
