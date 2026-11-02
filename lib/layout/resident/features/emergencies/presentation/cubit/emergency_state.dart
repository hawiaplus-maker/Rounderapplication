part of 'emergency_cubit.dart';

sealed class EmergencyState {
  const EmergencyState();
}

class EmergencyLoading extends EmergencyState {
  const EmergencyLoading();
}

class EmergencyReady extends EmergencyState {
  const EmergencyReady(this.types);
  final List<EmergencyType> types;
}

class EmergencyFailure extends EmergencyState {
  EmergencyFailure(this.message);
  final String? message;
}

class EmergencySubmitting extends EmergencyState {
  const EmergencySubmitting();
}

class EmergencySubmitted extends EmergencyState {
  const EmergencySubmitted(this.body);
  final Map<String, dynamic> body;
}
