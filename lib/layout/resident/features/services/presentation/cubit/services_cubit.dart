import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_option_model.dart';
import 'package:rounder_application/layout/resident/features/services/data/repo/services_repo.dart';
part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
 ServicesCubit(this.repository):super(ServicesLoading());final ServicesRepository repository;
 Future<void> load() async {emit(ServicesLoading());try{emit(ServicesReady(await repository.list()));}catch(_){emit(ServicesFailure(repository.errorKey));}}
 Future<void> book({required int homeId,required int serviceId,required DateTime date}) async=>repository.book(homeId:homeId,serviceId:serviceId,date:date);
}
