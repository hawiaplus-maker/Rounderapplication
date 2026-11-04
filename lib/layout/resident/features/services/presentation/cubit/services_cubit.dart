import 'package:image_picker/image_picker.dart';
import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_option_model.dart';
import 'package:rounder_application/layout/resident/features/services/data/repo/services_repo.dart';
part 'services_state.dart';

class ServicesCubit extends LocaleAwareCubit<ServicesState> {
  ServicesCubit(this.repository) : super(ServicesLoading());

  final ServicesRepository repository;

  Future<void> load() async {
    emit(ServicesLoading());
    try {
      emit(ServicesReady(await repository.list()));
    } catch (_) {
      emit(ServicesFailure(repository.errorKey));
    }
  }

  Future<int?> book({
    required int homeId,
    required int serviceId,
    required DateTime date,
    int? subServiceId,
    int? serviceProviderId,
    int? priceId,
    String? notes,
    List<XFile>? images,
  }) async => repository.book(
    homeId: homeId,
    serviceId: serviceId,
    date: date,
    subServiceId: subServiceId,
    serviceProviderId: serviceProviderId,
    priceId: priceId,
    notes: notes,
    images: images,
  );

  /// Service names come from the API in the selected language.
  @override
  Future<void> reloadForLocale() => load();
}
