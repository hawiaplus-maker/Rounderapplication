import 'package:easy_localization/easy_localization.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/support_info_model.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/support_ticket_model.dart';
import 'package:rounder_application/layout/resident/features/account/data/repo/support_repository.dart';

part 'support_state.dart';

/// Support contact data (channels) and the ticket submission of the contact
/// page. The info is fetched once per session and reloaded on locale changes.
class SupportCubit extends LocaleAwareCubit<SupportState> {
  SupportCubit(this.repo) : super(const SupportLoading());

  final SupportRepository repo;

  /// Last fetched channels; kept outside the state so a send failure never
  /// discards them.
  SupportInfo info = const SupportInfo();

  bool _loading = false;

  /// Loads the channels the first time the contact page opens (and retries
  /// after a failed attempt); a ready state is reused.
  Future<void> ensureLoaded() async {
    if (state is SupportReady || _loading) return;
    await load();
  }

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    emit(const SupportLoading());
    try {
      info = await repo.info();
      if (isClosed) return;
      emit(SupportReady(info));
    } catch (error) {
      if (isClosed) return;
      emit(
        SupportFailure(
          apiErrorMessage(error) ?? AppLocaleKey.connectionError.tr(),
        ),
      );
    } finally {
      _loading = false;
    }
  }

  /// Creates the ticket and returns it (or `null` when the backend rejected
  /// it), so the page can show the server reference on the success screen.
  Future<SupportTicket?> sendTicket({
    required String category,
    required String subject,
    required String message,
    String? attachmentPath,
    String? attachmentName,
  }) async {
    final SupportState current = state;
    if (current is SupportReady && current.sending) return null;
    emit(SupportReady(info, sending: true));
    try {
      final SupportTicket ticket = await repo.createTicket(
        category: category,
        subject: subject,
        message: message,
        attachmentPath: attachmentPath,
        attachmentName: attachmentName,
      );
      if (isClosed) return ticket;
      emit(SupportReady(info, lastTicket: ticket));
      return ticket;
    } catch (error) {
      if (isClosed) return null;
      emit(
        SupportReady(
          info,
          error: apiErrorMessage(error) ?? AppLocaleKey.connectionError.tr(),
        ),
      );
      return null;
    }
  }

  /// The channels and the ticket messages come from the backend already
  /// localized through `Accept-Language`.
  @override
  Future<void> reloadForLocale() => load();
}
