import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/layout/resident/data/models/resident_dashboard.dart';
import 'package:rounder_application/layout/resident/data/repositories/resident_repository.dart';
sealed class ResidentDashboardState {}
class DashboardLoading extends ResidentDashboardState {}
class DashboardReady extends ResidentDashboardState { DashboardReady(this.data); final ResidentDashboard data; }
class DashboardFailed extends ResidentDashboardState { DashboardFailed(this.key); final String key; }
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
