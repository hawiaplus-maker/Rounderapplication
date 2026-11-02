import 'package:easy_localization/easy_localization.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/homes_repo.dart';

part 'homes_state.dart';

/// The resident's linked homes, loaded by the units page and read by the
/// account profile for its count and current home.
class HomesCubit extends LocaleAwareCubit<HomesState> {
  HomesCubit(this.repo) : super(const HomesLoading());

  final HomesRepository repo;

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

  /// Unit labels and addresses are localized by the backend.
  @override
  Future<void> reloadForLocale() => load();
}
