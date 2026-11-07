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
    this.homeId,
    this.homeName,
    this.statusId,
    this.serviceId,
    this.subServiceId,
    this.serviceProviderId,
    this.canCancelFlag,
    this.isRated = false,
    this.canRateFlag,
    this.rating,
    this.currentStage,
    this.provider,
    this.images = const <BookingImage>[],
  });

  final int id;
  final int? statusId;
  final String serviceName;
  final String statusName;
  final String statusCode;
  final String scheduledAt;
  final double? amount;
  final String? subServiceName;
  final String? providerName;
  final List<String> mediaUrls;
  final int? homeId;
  final String? homeName;

  /// Backend ids of the service tree (`service_id`, `sub_service_id`,
  /// `service_provider_id`).
  final int? serviceId;
  final int? subServiceId;
  final int? serviceProviderId;

  /// `can_cancel` of the response; null keeps the statusCode rule.
  final bool? canCancelFlag;

  /// `is_rated` of the response — the completed booking already carries a
  /// rating entry.
  final bool isRated;

  /// `can_rate` of the response; null keeps the statusId rule.
  final bool? canRateFlag;

  /// The rating entry a resident left on the booking, when rated.
  final BookingRating? rating;

  /// `current_stage` — the workflow step the booking sits at.
  final BookingStage? currentStage;

  /// The booked provider (`service_provider` / `provider` nested object).
  final BookingServiceProvider? provider;

  /// Work images of the booking; [mediaUrls] flattens their urls.
  final List<BookingImage> images;

  /// The response's booleans; anything else (absent / not a bool) stays
  /// unknown.
  static bool? _boolOf(Object? value) => value is bool ? value : null;

  /// `can_cancel` when the backend sends it, else the statusCode rule.
  bool get canCancel =>
      canCancelFlag ?? (statusCode == 'pending' || statusCode == 'confirmed');

  /// Backend status id of a completed service — the state that offers the
  /// resident the rate-service entry on the order details.
  static const int completedStatusId = 9;

  /// The rating stays open for a completed booking that was not rated yet
  /// (`can_rate` when the backend sends it, else statusId == 9).
  bool get canRate =>
      !isRated && (canRateFlag ?? statusId == completedStatusId);

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
    final int? statusId = int.tryParse(
      '${j['status_id'] ?? status['id'] ?? ''}',
    );
    final int? serviceId = int.tryParse(
      '${j['service_id'] ?? service['id'] ?? ''}',
    );
    final int? subServiceId = int.tryParse(
      '${j['sub_service_id'] ?? sub?['id'] ?? ''}',
    );
    final int? serviceProviderId = int.tryParse(
      '${j['service_provider_id'] ?? provider['id'] ?? ''}',
    );
    final bool? canCancelFlag = _boolOf(j['can_cancel']);
    final bool isRated = _boolOf(j['is_rated']) ?? false;
    final bool? canRateFlag = _boolOf(j['can_rate']);
    final String flatProviderName = (j['service_provider_name'] ?? '').toString();

    final List<BookingImage> images =
        ((j['images'] as List?) ?? (j['booking_media'] as List?))
            ?.whereType<Map<String, dynamic>>()
            .map(BookingImage.fromJson)
            .toList() ??
        const <BookingImage>[];

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
    final String homeName = (j['home_name'] ?? '').toString();

    final Object? ratingRaw = j['rating'];
    final Object? stageRaw = j['current_stage'];
    final Object? providerRaw = j['service_provider'] ?? j['provider'];

    return BookingItem(
      id: int.tryParse('${j['id'] ?? ''}') ?? 0,
      serviceName: serviceName,
      statusName: statusName,
      statusCode: statusCode,
      statusId: statusId,
      serviceId: serviceId,
      subServiceId: subServiceId,
      serviceProviderId: serviceProviderId,
      canCancelFlag: canCancelFlag,
      isRated: isRated,
      canRateFlag: canRateFlag,
      rating: ratingRaw is Map<String, dynamic>
          ? BookingRating.fromJson(ratingRaw)
          : null,
      currentStage: stageRaw is Map<String, dynamic>
          ? BookingStage.fromJson(stageRaw)
          : null,
      provider: providerRaw is Map<String, dynamic>
          ? BookingServiceProvider.fromJson(providerRaw)
          : null,
      scheduledAt: (j['scheduled_at'] ?? '').toString(),
      amount: j['total_amount'] == null && j['amount'] == null
          ? null
          : double.tryParse('${j['total_amount'] ?? j['amount']}'),
      subServiceName: subServiceName,
      providerName: providerName,
      mediaUrls: <String>[for (final BookingImage image in images) image.url],
      images: images,
      homeId: int.tryParse('${j['home_id'] ?? ''}'),
      homeName: homeName.isEmpty ? null : homeName,
    );
  }
}

/// One work image of a booking (`images` of `/resident/bookings`).
class BookingImage {
  const BookingImage({
    required this.url,
    this.id,
    this.kind = '',
    this.mimeType = '',
    this.sizeBytes,
  });

  final String url;

  /// Backend id (`images.id`) — used when referencing media on follow-ups.
  final int? id;

  /// Media kind, e.g. `photo` — today only photos are surfaced.
  final String kind;
  final String mimeType;
  final int? sizeBytes;

  factory BookingImage.fromJson(Map<String, dynamic> j) => BookingImage(
        id: int.tryParse('${j['id'] ?? ''}'),
        url: (j['url'] ?? '').toString(),
        kind: (j['kind'] ?? '').toString(),
        mimeType: (j['mime_type'] ?? '').toString(),
        sizeBytes: int.tryParse('${j['size_bytes'] ?? ''}'),
      );
}

/// The rating a resident left on a completed booking (`rating` of
/// `/resident/bookings`).
class BookingRating {
  const BookingRating({
    required this.id,
    required this.score,
    this.comment = '',
    this.tags = const <String>[],
    this.createdAt,
  });

  final int id;
  final int score;
  final String comment;

  /// Quick-feedback tags exactly as they are displayed to the resident.
  final List<String> tags;
  final DateTime? createdAt;

  factory BookingRating.fromJson(Map<String, dynamic> j) {
    return BookingRating(
      id: int.tryParse('${j['id'] ?? ''}') ?? 0,
      score: int.tryParse('${j['score'] ?? 0}') ?? 0,
      comment: (j['comment'] ?? '').toString(),
      tags: (j['tags'] as List?)
              ?.map((Object? tag) => tag?.toString())
              .whereType<String>()
              .where((String tag) => tag.isNotEmpty)
              .toList() ??
          const <String>[],
      createdAt: DateTime.tryParse((j['created_at'] ?? '').toString()),
    );
  }
}

/// `current_stage` of a booking — the workflow step it sits at (`code`
/// mirrors the top-level `status_code`).
class BookingStage {
  const BookingStage({
    required this.id,
    required this.code,
    required this.name,
  });

  final int? id;
  final String code;
  final String name;

  factory BookingStage.fromJson(Map<String, dynamic> j) => BookingStage(
        id: int.tryParse('${j['id'] ?? ''}'),
        code: (j['code'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
      );
}

/// The booked service provider (`service_provider` / `provider` nested
/// object of `/resident/bookings`).
class BookingServiceProvider {
  const BookingServiceProvider({
    this.id,
    this.companyName = '',
    this.contactName = '',
    this.phone = '',
    this.email = '',
  });

  final int? id;
  final String companyName;
  final String contactName;
  final String phone;
  final String email;

  factory BookingServiceProvider.fromJson(Map<String, dynamic> j) {
    return BookingServiceProvider(
      id: int.tryParse('${j['id'] ?? ''}'),
      companyName: (j['company_name'] ?? '').toString(),
      contactName: (j['contact_name'] ?? '').toString(),
      phone: (j['phone'] ?? '').toString(),
      email: (j['email'] ?? '').toString(),
    );
  }
}
