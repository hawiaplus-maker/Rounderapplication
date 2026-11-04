import 'package:easy_localization/easy_localization.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/homes_repo.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/selected_home_store.dart';

part 'homes_state.dart';

/// The resident's linked homes, loaded by the units page and read by the
/// account profile for its count and current home.
class HomesCubit extends LocaleAwareCubit<HomesState> {
  HomesCubit(this.repo, this.store) : super(const HomesLoading());

  final HomesRepository repo;

  /// The dashboard's booked unit choice: a deleted unit must not keep
  /// leading the booking journey.
  final SelectedHomeStore store;

  Future<void> load() async {
    emit(const HomesLoading());
    try {
      emit(HomesReady(await repo.list()));
    } catch (error) {
      emit(
        HomesFailure(
          apiErrorMessage(error) ?? AppLocaleKey.unitsLoadFailed.tr(),
        ),
      );
    }
  }

  /// Deletes the linked unit and refreshes the loaded list in place —
  /// the page never blanks for one row's action. Returns the failure
  /// message for the screen's snackbar, or null when the unit was removed
  /// (the same shape as `EmergencyCubit.submit`).
  Future<String?> deleteUnit(ResidentHome home) async {
    final int? id = home.id;
    final List<ResidentHome> homes;
    if (state is HomesReady) {
      homes = (state as HomesReady).homes;
    } else {
      return null;
    }
    if (id == null) return null;
    emit(HomesDeleting(homes, id));
    try {
      await repo.deleteHome(id);
      if (store.readId() == id) {
        await store.writeId(null);
      }
      try {
        emit(HomesReady(await repo.list()));
      } catch (_) {
        // The refetch failed (offline): the deleted row drops so it never
        // renders again instead of showing the stale list.
        emit(
          HomesReady(homes.where((ResidentHome row) => row.id != id).toList()),
        );
      }
    } catch (error) {
      emit(HomesReady(homes));
      return apiErrorMessage(error) ?? AppLocaleKey.deleteUnitFailed.tr();
    }
    return null;
  }

  /// Unit labels and addresses are localized by the backend.
  @override
  Future<void> reloadForLocale() => load();
}
