import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/resident_dashboard.dart';
import '../../data/repositories/resident_repository.dart';
sealed class ResidentDashboardState {}
class DashboardLoading extends ResidentDashboardState {}
class DashboardReady extends ResidentDashboardState { DashboardReady(this.data); final ResidentDashboard data; }
class DashboardFailed extends ResidentDashboardState { DashboardFailed(this.key); final String key; }
class ResidentDashboardCubit extends Cubit<ResidentDashboardState> {
  ResidentDashboardCubit(this.repo):super(DashboardLoading()); final ResidentRepository repo;
  Future<void> load() async { emit(DashboardLoading()); try { emit(DashboardReady(await repo.getDashboard())); } catch(e) { emit(DashboardFailed(repo.errorKey(e))); } }
}
