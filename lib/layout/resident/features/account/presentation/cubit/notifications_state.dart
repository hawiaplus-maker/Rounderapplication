part of 'notifications_cubit.dart';

/// The design's three filter chips, in their frame order.
enum NotificationFilter { all, actionRequired, unread }

sealed class NotificationsState {
  const NotificationsState();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsReady extends NotificationsState {
  const NotificationsReady(
    this.items, {
    this.filter = NotificationFilter.all,
    this.busy = false,
    this.error = '',
  });

  final List<NotificationItem> items;
  final NotificationFilter filter;

  /// A read-all request is in flight.
  final bool busy;

  /// The server's text of the last rejected acknowledgement.
  final String error;

  List<NotificationItem> get visible => switch (filter) {
    NotificationFilter.all => items,
    NotificationFilter.unread =>
      items.where((NotificationItem item) => !item.isRead).toList(),
    NotificationFilter.actionRequired =>
      items.where((NotificationItem item) => item.requiresAction).toList(),
  };

  int get unreadCount =>
      items.where((NotificationItem item) => !item.isRead).length;

  int get actionCount =>
      items.where((NotificationItem item) => item.requiresAction).length;

  NotificationsReady copyWith({
    List<NotificationItem>? items,
    NotificationFilter? filter,
    bool? busy,
    String? error,
  }) => NotificationsReady(
    items ?? this.items,
    filter: filter ?? this.filter,
    busy: busy ?? this.busy,
    error: error ?? this.error,
  );

  /// The same feed with [ids] acknowledged as read.
  NotificationsReady markedRead(Set<int> ids) => copyWith(
    items: items
        .map(
          (NotificationItem item) =>
              ids.contains(item.id) ? item.copyWith(isRead: true) : item,
        )
        .toList(),
    busy: false,
  );
}

class NotificationsFailure extends NotificationsState {
  const NotificationsFailure(this.message);

  final String message;
}
