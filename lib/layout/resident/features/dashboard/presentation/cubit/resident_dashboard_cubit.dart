import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/model/resident_dashboard_model.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/resident_repo.dart';
part 'resident_dashboard_state.dart';

class ResidentDashboardCubit extends LocaleAwareCubit<ResidentDashboardState> {
  ResidentDashboardCubit(this.repo)
    : isPreview = false,
      super(DashboardLoading());
  ResidentDashboardCubit.preview(this.repo)
    : isPreview = true,
      super(DashboardReady(_preview()));
  final ResidentRepository repo;
  final bool isPreview;

  /// Guest preview: the full home layout backed by empty data, so no sample
  /// resident, unit or amount is ever shown.
  static ResidentDashboard _preview([String homeName = '']) =>
      ResidentDashboard(homeName: homeName, hasHome: true);

  void previewHome(String label) {
    if (isPreview) emit(DashboardReady(_preview(label)));
  }

  Future<void> load() async {
    if (isPreview) return;
    emit(DashboardLoading());
    try {
      emit(DashboardReady(await repo.getDashboard()));
    } catch (e) {
      emit(DashboardFailed(repo.errorKey(e)));
    }
  }

  @override
  Future<void> reloadForLocale() => load();
}
