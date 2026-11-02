import 'package:easy_localization/easy_localization.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/locale/locale_aware_cubit.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/notification_item_model.dart';
import 'package:rounder_application/layout/resident/features/account/data/repo/notifications_repo.dart';

part 'notifications_state.dart';

/// The resident notifications feed: one load, the three design filters, and
/// the read acknowledgements the backend exposes per item.
class NotificationsCubit extends LocaleAwareCubit<NotificationsState> {
  NotificationsCubit(this.repo) : super(const NotificationsLoading());

  final NotificationsRepository repo;

  Future<void> load() async {
    emit(const NotificationsLoading());
    try {
      emit(NotificationsReady(await repo.list()));
    } catch (error) {
      emit(
        NotificationsFailure(
          apiErrorMessage(error) ?? AppLocaleKey.notificationsLoadFailed.tr(),
        ),
      );
    }
  }

  void filterBy(NotificationFilter filter) {
    final NotificationsState current = state;
    if (current is NotificationsReady) {
      emit(current.copyWith(filter: filter));
    }
  }

  /// Marks one row read. The row keeps its unread state when the server
  /// rejects the acknowledgement, so the feed never lies about it.
  Future<void> markRead(NotificationItem item) async {
    final NotificationsState current = state;
    if (current is! NotificationsReady || item.isRead) return;
    final int? id = item.id;
    if (id == null) return;
    try {
      await repo.markRead(id);
      if (isClosed) return;
      final NotificationsState latest = state;
      if (latest is NotificationsReady) {
        emit(latest.markedRead(<int>{id}));
      }
    } catch (_) {
      // The next load re-reads the server's truth.
    }
  }

  /// "Mark all read" of the design: one request per unread item.
  Future<void> markAllRead() async {
    final NotificationsState current = state;
    if (current is! NotificationsReady || current.busy) return;
    final Set<int> unread = current.items
        .where((NotificationItem item) => !item.isRead && item.id != null)
        .map((NotificationItem item) => item.id!)
        .toSet();
    if (unread.isEmpty) return;
    emit(current.copyWith(busy: true));
    try {
      await repo.markAllRead(unread);
      if (isClosed) return;
      final NotificationsState latest = state;
      if (latest is NotificationsReady) {
        emit(latest.markedRead(unread));
      }
    } catch (error) {
      if (isClosed) return;
      final NotificationsState latest = state;
      if (latest is NotificationsReady) {
        emit(
          latest.copyWith(
            busy: false,
            error: apiErrorMessage(error) ?? AppLocaleKey.connectionError.tr(),
          ),
        );
      }
    }
  }

  /// Notification titles and bodies are written in the selected language.
  @override
  Future<void> reloadForLocale() => load();
}
