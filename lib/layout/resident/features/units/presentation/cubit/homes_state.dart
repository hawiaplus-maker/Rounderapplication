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

/// The list's rows while one unit is being deleted: the page stays
/// populated and the row's delete pill spins instead of flashing a full
/// loading panel for a single action.
class HomesDeleting extends HomesState {
  const HomesDeleting(this.homes, this.deletingId);

  final List<ResidentHome> homes;
  final int deletingId;
}
