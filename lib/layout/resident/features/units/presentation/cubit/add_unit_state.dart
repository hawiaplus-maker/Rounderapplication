part of 'add_unit_cubit.dart';

sealed class AddUnitState {
  const AddUnitState();
}

class AddUnitLoadingCities extends AddUnitState {
  const AddUnitLoadingCities();
}

class AddUnitReady extends AddUnitState {
  const AddUnitReady({this.cities = const <City>[]});

  final List<City> cities;
}

class AddUnitSubmitting extends AddUnitState {
  const AddUnitSubmitting({this.cities = const <City>[]});

  final List<City> cities;
}

class AddUnitSuccess extends AddUnitState {
  const AddUnitSuccess({this.cities = const <City>[]});

  final List<City> cities;
}

class AddUnitFailure extends AddUnitState {
  const AddUnitFailure(this.message, {this.cities = const <City>[]});

  final String message;
  final List<City> cities;
}
