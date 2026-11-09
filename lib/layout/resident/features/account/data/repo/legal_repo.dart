import 'package:rounder_application/core/network/api_consumer.dart';
import 'package:rounder_application/core/network/end_points.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/legal_document.dart';

/// Public legal documents (privacy policy, terms & conditions).
class LegalRepository {
  LegalRepository(this.api);

  final ApiConsumer api;

  Future<LegalDocument> getPrivacy() => _get(EndPoints.privacy);
  Future<LegalDocument> getTerms() => _get(EndPoints.terms);

  Future<LegalDocument> _get(String path) async {
    final response = await api.get<Map<String, dynamic>>(path);
    final body = response.data;
    final data = body is Map<String, dynamic>
        ? (body['data'] is Map<String, dynamic>
            ? body['data'] as Map<String, dynamic>
            : body)
        : const <String, dynamic>{};
    return LegalDocument.fromJson(data);
  }
}
