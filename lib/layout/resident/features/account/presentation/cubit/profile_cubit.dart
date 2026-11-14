import 'package:easy_localization/easy_localization.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/resident_profile_model.dart';
import 'package:rounder_application/layout/resident/features/account/data/repo/profile_repo.dart';

part 'profile_state.dart';

/// The signed-in resident's account: loaded once when the account tab opens,
/// written by the edit page. The server's own message is surfaced by the
/// network layer; this cubit only carries the page states.
class ProfileCubit extends LocaleAwareCubit<ProfileState> {
  ProfileCubit(this.repo) : super(const ProfileLoading());

  final ProfileRepository repo;

  Future<void> load() async {
    emit(const ProfileLoading());
    try {
      final ResidentProfile profile = await repo.get();
      if (isClosed) return;
      emit(ProfileReady(profile));
    } catch (error) {
      if (isClosed) return;
      emit(
        ProfileFailure(
          apiErrorMessage(error) ?? AppLocaleKey.profileLoadFailed.tr(),
        ),
      );
    }
  }

  /// Saves name and email. Returns whether the server accepted them; a
  /// failure keeps the edit page open with the server's message.
  Future<bool> save({
    required String name,
    required String email,
    String? locale,
  }) async {
    final ProfileState current = state;
    if (current is! ProfileReady || current.saving) return false;
    emit(ProfileReady(current.profile, saving: true));
    try {
      await repo.update(name: name, email: email, locale: locale);
      if (isClosed) return true;
      emit(
        ProfileReady(
          current.profile.copyWith(name: name, email: email, locale: locale),
        ),
      );
      return true;
    } catch (error) {
      if (isClosed) return false;
      emit(
        ProfileReady(
          current.profile,
          error: apiErrorMessage(error) ?? AppLocaleKey.connectionError.tr(),
        ),
      );
      return false;
    }
  }

  /// Permanently deletes the account. Returns the failure message for the
  /// settings snackbar, or null when the server accepted the deletion (the
  /// caller then clears the session).
  Future<String?> deleteAccount() async {
    try {
      await repo.deleteAccount();
      return null;
    } catch (error) {
      return apiErrorMessage(error) ?? AppLocaleKey.deleteAccountFailed.tr();
    }
  }

  /// The profile (and its stored locale) is refetched after a language switch.
  @override
  Future<void> reloadForLocale() => load();
}
