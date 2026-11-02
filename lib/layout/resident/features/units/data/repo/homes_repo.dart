import 'package:intl/intl.dart';
import 'package:rounder_application/core/network/api_consumer.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/core/network/end_points.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/city_model.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';

/// The resident's linked homes: the units page renders the list and the
/// account profile reads its count and current home.
class HomesRepository {
  HomesRepository(this.api);

  final ApiConsumer api;

  Future<List<ResidentHome>>? _cachedHomes;
  DateTime? _cachedAt;

  /// The language the cached list was fetched in: unit labels and addresses
  /// are localized, so a different locale must refetch.
  String? _cachedLocale;

  /// Drops the cached homes so the next [list] call refetches (e.g. after a
  /// language change).
  void invalidate() {
    _cachedHomes = null;
    _cachedAt = null;
    _cachedLocale = null;
  }
  static const Duration _cacheAge = Duration(minutes: 5);

  Future<List<ResidentHome>> list({bool force = false}) async {
    final DateTime? cachedAt = _cachedAt;
    final String locale = Intl.getCurrentLocale();
    if (!force &&
        _cachedHomes != null &&
        cachedAt != null &&
        _cachedLocale == locale &&
        DateTime.now().difference(cachedAt) < _cacheAge) {
      return _cachedHomes!;
    }
    final future = _fetchHomes();
    _cachedHomes = future;
    _cachedAt = DateTime.now();
    _cachedLocale = locale;
    try {
      return await future;
    } catch (_) {
      _cachedHomes = null;
      _cachedAt = null;
      _cachedLocale = null;
      rethrow;
    }
  }

  Future<List<ResidentHome>> _fetchHomes() async {
    final response = await api.get<Map<String, dynamic>>(EndPoints.homes);
    final Map<String, dynamic> body =
        response.data ?? const <String, dynamic>{};
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
    return _values(
      body,
    ).whereType<Map<String, dynamic>>().map(ResidentHome.fromJson).toList();
  }

  /// Cities for the add-unit screen's city picker. Fetches the first page
  /// (per_page=100) — the endpoint is paginated (4581 total); a full fetch
  /// is intentionally avoided to keep the screen responsive.
  Future<List<City>> cities() async {
    final response = await api.get<Map<String, dynamic>>(
      '${EndPoints.cities}?per_page=100&page=1',
    );
    final Map<String, dynamic> body =
        response.data ?? const <String, dynamic>{};
    final Object? data = body['data'];
    final List<Object?> values = data is List
        ? data
        : (data is Map && data['data'] is List)
            ? data['data'] as List
            : const <Object?>[];
    return values
        .whereType<Map<String, dynamic>>()
        .map(City.fromJson)
        .toList();
  }

  /// Creates a new residence unit.
  Future<void> addUnit({
    required String name,
    required String address,
    required String district,
    required int cityId,
    required String residenceType,
    required String unitNumber,
    String? floorNumber,
    double? areaSqm,
    String ownershipType = 'owner',
    bool isPrimary = true,
  }) async {
    final response = await api.post<Map<String, dynamic>>(
      EndPoints.addUnit,
      data: <String, dynamic>{
        'name': name,
        'address': address,
        'district': district,
        'city_id': cityId,
        'residence_type': residenceType,
        'area_sqm': areaSqm,
        'floor_number': floorNumber,
        'ownership_type': ownershipType,
        'unit_number': unitNumber,
        'is_primary': isPrimary,
      },
    );
    final Map<String, dynamic> body =
        response.data ?? const <String, dynamic>{};
    if (body['status'] == false) {
      throw ApiFailure(body['message']?.toString() ?? '');
    }
    _cachedHomes = null;
    _cachedAt = null;
    _cachedLocale = null;
  }

  /// `data: [...]`, a paginated `data: {data: [...]}`, a `homes` list, or a
  /// bare list body.
  List<Object?> _values(Map<String, dynamic> body) {
    final Object? data = body['data'];
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    if (data is Map && data['homes'] is List) return data['homes'] as List;
    if (body['homes'] is List) return body['homes'] as List;
    return const <Object?>[];
  }
}
