part of 'service_providers_cubit.dart';

sealed class ServiceProvidersState {
  const ServiceProvidersState();
}

class ServiceProvidersLoading extends ServiceProvidersState {
  const ServiceProvidersLoading() : super();
}

class ServiceProvidersReady extends ServiceProvidersState {
  const ServiceProvidersReady(this.providers) : super();
  final List<ServiceProvider> providers;
}

class ServiceProvidersFailure extends ServiceProvidersState {
  const ServiceProvidersFailure(this.key) : super();
  final String key;
}
