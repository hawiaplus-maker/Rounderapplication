import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/resident/features/emergencies/data/model/emergency_type_model.dart';
import 'package:rounder_application/layout/resident/features/emergencies/data/repo/emergency_repository.dart';
part 'emergency_state.dart';

/// Emergency types (loaded once) and the emergency-request submission.
class EmergencyCubit extends LocaleAwareCubit<EmergencyState> {
  EmergencyCubit(this.repo) : super(const EmergencyLoading());

  final EmergencyRepository repo;

  /// Last fetched types; read directly by the screen between rebuilds.
  List<EmergencyType> types = const [];

  Future<void> load() async {
    emit(const EmergencyLoading());
    try {
      types = await repo.list();
      emit(EmergencyReady(types));
    } catch (_) {
      emit(EmergencyFailure(null));
    }
  }

  /// Submits the emergency request and returns the backend response body
  /// (or `null` when it failed), so the screen can surface the reference.
  Future<Map<String, dynamic>?> submit({
    required int residentHomeId,
    required int emergencyTypeId,
    required String contactPhone,
    required String locationDetails,
    required String description,
    required bool confirmEmergency,
  }) async {
    emit(const EmergencySubmitting());
    try {
      final body = await repo.submit(
        residentHomeId: residentHomeId,
        emergencyTypeId: emergencyTypeId,
        contactPhone: contactPhone,
        locationDetails: locationDetails,
        description: description,
        confirmEmergency: confirmEmergency,
      );
      if (body == null) throw const EmergencySubmitFailure('no_response');
      emit(EmergencySubmitted(body));
      return body;
    } catch (error) {
      emit(EmergencyFailure(apiErrorMessage(error)));
      return null;
    }
  }

  /// Type names are localized by the backend.
  @override
  Future<void> reloadForLocale() => load();
}

/// Thrown internally when the backend returns no usable body.
class EmergencySubmitFailure implements Exception {
  const EmergencySubmitFailure(this.reason);
  final String reason;
}
