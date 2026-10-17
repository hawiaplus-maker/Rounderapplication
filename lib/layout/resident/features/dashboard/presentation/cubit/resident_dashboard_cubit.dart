import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/model/resident_dashboard_model.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/resident_repo.dart';
part 'resident_dashboard_state.dart';

class ResidentDashboardCubit extends Cubit<ResidentDashboardState> {
  ResidentDashboardCubit(this.repo):isPreview=false,super(DashboardLoading());
  ResidentDashboardCubit.preview(this.repo):isPreview=true,super(DashboardReady(const ResidentDashboard(hasHome:true)));
  final ResidentRepository repo;
  final bool isPreview;

  void previewHome(String label) {
    if(isPreview)emit(DashboardReady(ResidentDashboard(homeName:label,hasHome:true)));
  }
  Future<void> load() async { if(isPreview)return; emit(DashboardLoading()); try { emit(DashboardReady(await repo.getDashboard())); } catch(e) { emit(DashboardFailed(repo.errorKey(e))); } }
}
