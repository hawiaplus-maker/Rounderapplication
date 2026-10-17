import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/layout/resident/data/models/service_option.dart';
import 'package:rounder_application/layout/resident/data/repositories/services_repository.dart';
sealed class ServicesState {}
class ServicesLoading extends ServicesState {}
class ServicesReady extends ServicesState {ServicesReady(this.services);final List<ServiceOption> services;}
class ServicesFailure extends ServicesState {ServicesFailure(this.key);final String key;}
class ServicesCubit extends Cubit<ServicesState> {
 ServicesCubit(this.repository):super(ServicesLoading());final ServicesRepository repository;
 Future<void> load() async {emit(ServicesLoading());try{emit(ServicesReady(await repository.list()));}catch(_){emit(ServicesFailure(repository.errorKey));}}
 Future<void> book({required int homeId,required int serviceId,required DateTime date}) async=>repository.book(homeId:homeId,serviceId:serviceId,date:date);
}
