import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/data/model/booking_item_model.dart';
import 'package:rounder_application/layout/resident/features/bookings/data/repo/bookings_repo.dart';
part 'bookings_state.dart';

class BookingsCubit extends LocaleAwareCubit<BookingsState> {
  BookingsCubit(this.repo) : super(BookingsLoading());

  final BookingsRepository repo;

  Future<void> load() async {
    emit(BookingsLoading());
    try {
      emit(BookingsReady(await repo.list()));
    } catch (_) {
      emit(BookingsFailure());
    }
  }

  Future<void> cancel(BookingItem booking, String reason) async {
    await repo.cancel(booking.id, reason);
    await load();
  }

  /// Status names and service names are localized by the backend.
  @override
  Future<void> reloadForLocale() => load();
}
