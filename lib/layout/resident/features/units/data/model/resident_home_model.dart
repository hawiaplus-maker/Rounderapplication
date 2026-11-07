/// Model of one linked home of `GET ${EndPoints.homes}`. The backend may wrap
/// the property in a nested object and name the fields differently per
/// endpoint, so every field is read defensively and stays optional: a partial
/// payload still renders with the page's placeholders, never sample content.
class ResidentHome {
  const ResidentHome({
    this.id,
    this.name = '',
    this.unitLabel = '',
    this.city = '',
    this.address = '',
    this.district = '',
    this.area,
    this.isPrimary = false,
    this.isOwner = true,
    this.residenceType,
    this.residenceTypeLabel,
    this.floorNumber,
    this.ownershipType,
    this.ownershipTypeLabel,
    this.propertyCode,
  });

  final int? id;
  final String name, unitLabel, city, address, district;
  final double? area;
  final bool isPrimary, isOwner;

  /// The flat payload's unit extras of `/resident/homes`: the residence shape
  /// and ownership as code + localized label, the floor and the linked
  /// property code (`HOM-…`).
  final String? residenceType, residenceTypeLabel;
  final int? floorNumber;
  final String? ownershipType, ownershipTypeLabel;
  final String? propertyCode;

  bool get hasArea => area != null && area! > 0;

  factory ResidentHome.fromJson(Map<String, dynamic> j) {
    final Map<String, dynamic> property = _map(j['property']);
    final Map<String, dynamic> unit = _map(j['unit']);
    final Map<String, dynamic> source = property.isNotEmpty ? property : j;
    final Object? role = j['role'] ?? j['ownership_type'] ?? j['ownership'];
    final bool? explicitOwner = _bool(j['is_owner'] ?? source['is_owner']);
    return ResidentHome(
      id: int.tryParse(
        '${j['id'] ?? j['home_id'] ?? j['property_id'] ?? j['resident_home_id'] ?? source['id'] ?? ''}',
      ),
      name:
          _text(j, const [
            'custom_name',
            'name',
            'home_name',
            'property_name',
            'title',
          ]) ??
          _text(source, const ['custom_name', 'name', 'property_name', 'title']) ??
          '',
      unitLabel:
          _text(j, const [
            'unit_label',
            'unit_number',
            'unit_no',
            'unit',
            'apartment',
          ]) ??
          _text(unit, const ['label', 'number', 'name']) ??
          '',
      city:
          _text(j, const ['city', 'city_name', 'town']) ??
          _text(source, const ['city', 'city_name', 'town']) ??
           '',
       address:
           _text(j, const ['address', 'street', 'street_address', 'location']) ??
           _text(source, const ['address', 'street', 'street_address', 'location']) ??
           _text(unit, const ['address', 'street']) ??
           '',
       district:
           _text(j, const ['district', 'district_name', 'neighborhood', 'area_name']) ??
           _text(source, const ['district', 'district_name', 'neighborhood', 'area_name']) ??
           '',
      area: _number(
        j['area'] ??
            j['area_sqm'] ??
            j['area_m2'] ??
            j['space'] ??
            source['area'] ??
            source['area_sqm'] ??
            source['area_m2'],
      ),
      residenceType: _text(j, const ['residence_type']),
      residenceTypeLabel: _text(j, const ['residence_type_label']),
      floorNumber: int.tryParse(
        '${j['floor_number'] ?? unit['floor_number'] ?? unit['floor'] ?? ''}',
      ),
      ownershipType: _text(j, const ['ownership_type']),
      ownershipTypeLabel: _text(j, const ['ownership_type_label']),
      propertyCode: _text(j, const ['property_code']),
      isPrimary:
          _bool(j['is_primary'] ?? j['primary'] ?? j['is_current']) ?? false,
      isOwner: explicitOwner ?? _ownerFromRole(role?.toString()),
    );
  }

  /// The role text of the backend (`owner`/`tenant`, Arabic, or an unknown
  /// value) as the owner flag. Unknown values keep the design's owner default.
  static bool _ownerFromRole(String? role) {
    final String value = (role ?? '').trim().toLowerCase();
    if (value.isEmpty) return true;
    if (value.contains('tenant') || value.contains('مستأجر')) return false;
    if (value.contains('owner') || value.contains('مالك')) return true;
    return true;
  }

  static Map<String, dynamic> _map(Object? value) =>
      value is Map<String, dynamic> ? value : const <String, dynamic>{};

  static String? _text(Map<String, dynamic> j, List<String> keys) {
    for (final String key in keys) {
      final Object? value = j[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  static double? _number(Object? value) => value is num
      ? value.toDouble()
      : double.tryParse(value?.toString().trim() ?? '');

  static bool? _bool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final String text = value.trim().toLowerCase();
      if (text == 'true' || text == '1') return true;
      if (text == 'false' || text == '0') return false;
    }
    return null;
  }
}
