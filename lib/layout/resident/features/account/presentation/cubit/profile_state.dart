part of 'profile_cubit.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// The loaded account. [saving] disables the edit form's action, [error]
/// carries the server's text of the last rejected save.
class ProfileReady extends ProfileState {
  const ProfileReady(this.profile, {this.saving = false, this.error = ''});

  final ResidentProfile profile;
  final bool saving;
  final String error;
}

class ProfileFailure extends ProfileState {
  const ProfileFailure(this.message);

  final String message;
}
