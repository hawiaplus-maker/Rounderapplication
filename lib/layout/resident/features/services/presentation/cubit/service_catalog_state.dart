part of 'service_catalog_cubit.dart';

sealed class ServiceCatalogState {
  const ServiceCatalogState();
}

class ServiceCatalogLoading extends ServiceCatalogState {
  const ServiceCatalogLoading() : super();
}

class ServiceCatalogReady extends ServiceCatalogState {
  const ServiceCatalogReady(this.categories) : super();
  final List<ServiceCategory> categories;
}

class ServiceCatalogFailure extends ServiceCatalogState {
  const ServiceCatalogFailure(this.key) : super();
  final String key;
}
