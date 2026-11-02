import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_provider_model.dart';
import 'package:rounder_application/layout/resident/features/services/data/repo/services_repo.dart';

part 'service_providers_state.dart';

class ServiceProvidersCubit extends LocaleAwareCubit<ServiceProvidersState> {
  ServiceProvidersCubit(this.repo) : super(const ServiceProvidersLoading());

  final ServicesRepository repo;

  /// The service whose providers are on screen, kept for locale reloads.
  int? _serviceId;

  Future<void> load(int serviceId) async {
    _serviceId = serviceId;
    emit(const ServiceProvidersLoading());
    try {
      emit(ServiceProvidersReady(await repo.serviceProviders(serviceId)));
    } catch (_) {
      emit(ServiceProvidersFailure(repo.errorKey));
    }
  }

  /// Provider names are localized by the backend.
  @override
  Future<void> reloadForLocale() async {
    final int? serviceId = _serviceId;
    if (serviceId != null) await load(serviceId);
  }
}
