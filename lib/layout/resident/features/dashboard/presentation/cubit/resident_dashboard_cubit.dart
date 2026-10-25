import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/model/resident_dashboard_model.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/resident_repo.dart';
part 'resident_dashboard_state.dart';

class ResidentDashboardCubit extends Cubit<ResidentDashboardState> {
  ResidentDashboardCubit(this.repo):isPreview=false,super(DashboardLoading());
  ResidentDashboardCubit.preview(this.repo):isPreview=true,super(DashboardReady(_preview()));
  final ResidentRepository repo;
  final bool isPreview;

  static ResidentDashboard _preview([String homeName=''])=>ResidentDashboard(homeName:homeName,hasHome:true,associationBalance:25000,propertyHealthPercent:87,unitLabel:'1204',periodStartBalance:20000);

  void previewHome(String label) {
    if(isPreview)emit(DashboardReady(_preview(label)));
  }
  Future<void> load() async { if(isPreview)return; emit(DashboardLoading()); try { emit(DashboardReady(await repo.getDashboard())); } catch(e) { emit(DashboardFailed(repo.errorKey(e))); } }
}
