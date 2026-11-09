import 'package:dio/dio.dart';
import 'package:rounder_application/core/network/api_consumer.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/core/network/end_points.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/support_info_model.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/support_ticket_model.dart';

/// Resident support: the contact channels (`GET /resident/support/info`) and
/// the ticket submission (`POST /resident/support/tickets`).
class SupportRepository {
  SupportRepository(this.api);

  final ApiConsumer api;

  /// The support channels the contact page renders. Missing fields stay empty
  /// so the page keeps its localized defaults.
  Future<SupportInfo> info() async {
    final Response<Map<String, dynamic>> response = await api
        .get<Map<String, dynamic>>(EndPoints.supportInfo);
    final Map<String, dynamic> body = _body(response.data);
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
    final Object? data = body['data'];
    return SupportInfo.fromJson(
      data is Map ? Map<String, dynamic>.from(data) : body,
    );
  }

  /// Creates a support ticket. JSON is used when no file is attached;
  /// otherwise the request goes as multipart so the image reaches the backend.
  Future<SupportTicket> createTicket({
    required String category,
    required String subject,
    required String message,
    String? attachmentPath,
    String? attachmentName,
  }) async {
    final Object payload;
    if (attachmentPath == null) {
      payload = <String, dynamic>{
        'category': category,
        'subject': subject,
        'message': message,
      };
    } else {
      payload = FormData.fromMap(<String, dynamic>{
        'category': category,
        'subject': subject,
        'message': message,
        'attachment': await MultipartFile.fromFile(
          attachmentPath,
          filename: attachmentName ?? 'attachment',
        ),
      });
    }

    final Response<Map<String, dynamic>> response = await api
        .post<Map<String, dynamic>>(EndPoints.supportTickets, data: payload);
    final Map<String, dynamic> body = _body(response.data);
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
    final Object? data = body['data'];
    return SupportTicket.fromJson(
      data is Map ? Map<String, dynamic>.from(data) : body,
    );
  }

  Map<String, dynamic> _body(Map<String, dynamic>? raw) =>
      raw ?? const <String, dynamic>{};
}
