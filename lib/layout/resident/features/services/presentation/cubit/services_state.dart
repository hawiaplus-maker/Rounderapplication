part of 'services_cubit.dart';

sealed class ServicesState {}
class ServicesLoading extends ServicesState {}
class ServicesReady extends ServicesState {ServicesReady(this.services);final List<ServiceOption> services;}
class ServicesFailure extends ServicesState {ServicesFailure(this.key);final String key;}
