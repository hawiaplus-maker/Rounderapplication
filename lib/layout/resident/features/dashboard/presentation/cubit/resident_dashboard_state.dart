part of 'resident_dashboard_cubit.dart';

sealed class ResidentDashboardState {}
class DashboardLoading extends ResidentDashboardState {}
class DashboardReady extends ResidentDashboardState { DashboardReady(this.data); final ResidentDashboard data; }
class DashboardFailed extends ResidentDashboardState { DashboardFailed(this.key); final String key; }
