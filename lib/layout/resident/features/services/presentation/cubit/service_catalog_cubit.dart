import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_category_model.dart';
import 'package:rounder_application/layout/resident/features/services/data/repo/services_repo.dart';

part 'service_catalog_state.dart';

class ServiceCatalogCubit extends LocaleAwareCubit<ServiceCatalogState> {
  ServiceCatalogCubit(this.repo) : super(const ServiceCatalogLoading());

  final ServicesRepository repo;

  Future<void> load() async {
    emit(const ServiceCatalogLoading());
    try {
      emit(ServiceCatalogReady(await repo.categories()));
    } catch (_) {
      emit(ServiceCatalogFailure(repo.errorKey));
    }
  }

  /// Categories and services are named in the selected language.
  @override
  Future<void> reloadForLocale() => load();
}
