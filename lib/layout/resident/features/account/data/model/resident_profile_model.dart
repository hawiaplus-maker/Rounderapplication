/// Model of `GET ${EndPoints.profile}` — the resident account the profile and
/// edit pages render. The envelope wraps the user in `data`; a bare body is
/// accepted too. Every field is optional so a partial payload still renders
/// (missing values become the page's placeholders, never sample content).
class ResidentProfile {
  const ResidentProfile({
    this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.avatarUrl = '',
    this.locale = '',
  });

  final int? id;
  final String name, email, phone, avatarUrl;
  final String locale;

  bool get isEmpty =>
      name.isEmpty && email.isEmpty && phone.isEmpty && avatarUrl.isEmpty;

  ResidentProfile copyWith({String? name, String? email, String? phone, String? locale}) =>
      ResidentProfile(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl,
        locale: locale ?? this.locale,
      );

  factory ResidentProfile.fromJson(Map<String, dynamic> j) => ResidentProfile(
    id: int.tryParse('${j['id']}'),
    name: _text(j, const ['name', 'full_name']),
    email: _text(j, const ['email']),
    phone: _text(j, const ['phone', 'mobile']),
    avatarUrl: _text(j, const ['avatar_url', 'avatar', 'photo']),
    locale: _text(j, const ['locale']),
  );

  /// First present alias, as a trimmed string.
  static String _text(Map<String, dynamic> j, List<String> keys) {
    for (final String key in keys) {
      final Object? value = j[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }
}
