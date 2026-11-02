part of 'homes_cubit.dart';

sealed class HomesState {
  const HomesState();
}

class HomesLoading extends HomesState {
  const HomesLoading();
}

class HomesReady extends HomesState {
  const HomesReady(this.homes);

  final List<ResidentHome> homes;

  /// The current home of the design: the flagged primary, else the first one.
  ResidentHome? get primary {
    if (homes.isEmpty) return null;
    return homes.firstWhere(
      (ResidentHome home) => home.isPrimary,
      orElse: () => homes.first,
    );
  }
}

class HomesFailure extends HomesState {
  const HomesFailure(this.message);

  final String message;
}
