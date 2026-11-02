import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/notifications_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_sub_page.dart';
import 'package:rounder_application/layout/global/widgets/state_panel.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/notifications_feed.dart';

/// Notifications page: the API feed with its filters, counts and read actions.
class AccountNotificationsPage extends StatelessWidget {
  const AccountNotificationsPage({
    super.key,
    required this.onBack,
    required this.onPreferences,
  });

  final VoidCallback onBack, onPreferences;

  @override
  Widget build(BuildContext context) {
    return AccountSubPage(
      titleKey: AppLocaleKey.notifications,
      onBack: onBack,
      children: [
        BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) => switch (state) {
            NotificationsLoading() => const StatePanel(
              message: '',
              loading: true,
            ),
            NotificationsFailure(:final String message) => StatePanel(
              message: message,
              onRetry: () => context.read<NotificationsCubit>().load(),
            ),
            NotificationsReady() => NotificationsFeed(
              state: state,
              onPreferences: onPreferences,
            ),
          },
        ),
      ],
    );
  }
}
