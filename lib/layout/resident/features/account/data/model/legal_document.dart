/// A legal document returned by `/api/v1/privacy` and `/api/v1/terms`:
/// `{data: {id, slug, title, content, updated_at}}`.
class LegalDocument {
  const LegalDocument({
    required this.id,
    required this.slug,
    required this.title,
    required this.content,
    this.updatedAt,
  });

  final int id;
  final String slug;
  final String title;
  final String content;
  final DateTime? updatedAt;

  factory LegalDocument.fromJson(Map<String, dynamic> json) {
    return LegalDocument(
      id: (json['id'] as num?)?.toInt() ?? 0,
      slug: json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }
}
