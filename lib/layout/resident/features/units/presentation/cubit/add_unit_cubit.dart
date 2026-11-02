import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/city_model.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/homes_repo.dart';

part 'add_unit_state.dart';

/// Cubit backing the "add residence unit" screen (design 03.3a): loads the
/// city list for the picker and submits the new unit to the backend.
class AddUnitCubit extends Cubit<AddUnitState> {
  AddUnitCubit(this.repo) : super(const AddUnitLoadingCities());

  final HomesRepository repo;

  Future<void> loadCities() async {
    emit(const AddUnitLoadingCities());
    try {
      final cities = await repo.cities();
      emit(AddUnitReady(cities: cities));
    } catch (error) {
      emit(
        AddUnitFailure(
          apiErrorMessage(error) ?? AppLocaleKey.unitsLoadFailed.tr(),
        ),
      );
    }
  }

  Future<void> submit({
    required String name,
    required String address,
    required String district,
    required int cityId,
    required String residenceType,
    required String unitNumber,
    String? floorNumber,
    double? areaSqm,
    String ownershipType = 'owner',
    bool isPrimary = true,
  }) async {
    final current = state;
    final cities = current is AddUnitReady ? current.cities : const <City>[];
    emit(AddUnitSubmitting(cities: cities));
    try {
      await repo.addUnit(
        name: name,
        address: address,
        district: district,
        cityId: cityId,
        residenceType: residenceType,
        unitNumber: unitNumber,
        floorNumber: floorNumber,
        areaSqm: areaSqm,
        ownershipType: ownershipType,
        isPrimary: isPrimary,
      );
      emit(AddUnitSuccess(cities: cities));
    } catch (error) {
      emit(
        AddUnitFailure(
          apiErrorMessage(error) ?? AppLocaleKey.homeLinkFailed.tr(),
          cities: cities,
        ),
      );
    }
  }
}
