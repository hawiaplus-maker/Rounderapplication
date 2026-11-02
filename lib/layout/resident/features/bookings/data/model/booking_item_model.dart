import 'package:intl/intl.dart';

class BookingItem {
  const BookingItem({
    required this.id,
    required this.serviceName,
    required this.statusName,
    required this.statusCode,
    required this.scheduledAt,
    required this.amount,
    this.subServiceName,
    this.providerName,
    this.mediaUrls = const <String>[],
  });

  final int id;
  final String serviceName;
  final String statusName;
  final String statusCode;
  final String scheduledAt;
  final double amount;
  final String? subServiceName;
  final String? providerName;
  final List<String> mediaUrls;

  bool get canCancel => statusCode == 'pending' || statusCode == 'confirmed';

  static String _localeName(List<dynamic>? translations) {
    final locale = Intl.getCurrentLocale().split('_').first;
    String? fallback;
    for (final t in translations ?? const []) {
      if (t is! Map) continue;
      final name = t['name']?.toString();
      if (name == null || name.isEmpty) continue;
      if (t['locale']?.toString() == locale) return name;
      fallback ??= name;
    }
    return fallback ?? '';
  }

  factory BookingItem.fromJson(Map<String, dynamic> j) {
    final service = j['service'] is Map<String, dynamic>
        ? j['service'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final status = j['status'] is Map<String, dynamic>
        ? j['status'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final provider = j['service_provider'] is Map<String, dynamic>
        ? j['service_provider'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final sub = j['sub_service'] is Map<String, dynamic>
        ? j['sub_service'] as Map<String, dynamic>
        : null;

    // Flat shape coming from /resident/bookings (service_name, status_name, ...).
    final String flatServiceName = (j['service_name'] ?? '').toString();
    final String flatSubServiceName = (j['sub_service_name'] ?? '').toString();
    final String flatStatusName = (j['status_name'] ?? '').toString();
    final String flatStatusCode = (j['status_code'] ?? '').toString();
    final String flatProviderName = (j['service_provider_name'] ?? '').toString();

    final media = (j['images'] as List? ?? j['booking_media'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((m) => m['url']?.toString())
            .whereType<String>()
            .toList() ??
        const <String>[];

    final String serviceName = flatServiceName.isNotEmpty
        ? flatServiceName
        : _localeName(service['translations'] as List?);
    final String statusName = flatStatusName.isNotEmpty
        ? flatStatusName
        : _localeName(status['translations'] as List?);
    final String statusCode = flatStatusCode.isNotEmpty
        ? flatStatusCode
        : (status['code'] ?? j['status_code'] ?? '').toString();
    final String? subServiceName = flatSubServiceName.isNotEmpty
        ? flatSubServiceName
        : (sub == null ? null : _localeName(sub['translations'] as List?));
    final String? providerName = flatProviderName.isNotEmpty
        ? flatProviderName
        : provider['company_name']?.toString();

    return BookingItem(
      id: int.tryParse('${j['id'] ?? ''}') ?? 0,
      serviceName: serviceName,
      statusName: statusName,
      statusCode: statusCode,
      scheduledAt: (j['scheduled_at'] ?? '').toString(),
      amount: double.tryParse('${j['total_amount'] ?? j['amount'] ?? 0}') ?? 0,
      subServiceName: subServiceName,
      providerName: providerName,
      mediaUrls: media,
    );
  }
}
