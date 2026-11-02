
import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/model/weather_model.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/weather_repo.dart';
part 'weather_state.dart';

/// Home top bar weather: a long-lived singleton so switching tabs never
/// refetches, refreshed at most every [_maxAge] (30 minutes).
class WeatherCubit extends LocaleAwareCubit<WeatherState> {
  WeatherCubit(this.repo) : super(WeatherPending());
  final WeatherRepository repo;

  DateTime? _fetchedAt;

  /// Fetches only when there is no live data or the last read is older than
  /// 30 minutes; used by the provider creation and any manual refresh.
  Future<void> ensureLoaded() async {
    final DateTime? fetchedAt = _fetchedAt;
    if (state is WeatherReady &&
        fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < _maxAge) {
      return;
    }
    await load();
  }

  Future<void> load() async {
    emit(WeatherPending());
    try {
      final info = await repo.getWeather();
      emit(WeatherReady(info));
      _fetchedAt = DateTime.now();
    } catch (_) {
      emit(WeatherFailed());
    }
  }

  static const Duration _maxAge = Duration(minutes: 30);

  /// The city and condition come from the API in the selected language.
  @override
  Future<void> reloadForLocale() => load();
}