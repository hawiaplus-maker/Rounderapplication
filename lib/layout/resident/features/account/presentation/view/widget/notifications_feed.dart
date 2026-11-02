import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/notification_item_model.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/notifications_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/notification_card.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/notification_filters.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/notifications_summary.dart';

/// The loaded feed: summary, filters, the visible cards and the preferences
/// entry. Opening a card (or its action) acknowledges it as read.
class NotificationsFeed extends StatelessWidget {
  const NotificationsFeed({
    super.key,
    required this.state,
    required this.onPreferences,
  });

  final NotificationsReady state;
  final VoidCallback onPreferences;

  @override
  Widget build(BuildContext context) {
    final NotificationsCubit cubit = context.read<NotificationsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NotificationsSummary(
          actionCount: state.actionCount,
          unreadCount: state.unreadCount,
          busy: state.busy,
          onReadAll: cubit.markAllRead,
        ),
        NotificationFilters(filter: state.filter, onChanged: cubit.filterBy),
        const SizedBox(height: 12),
        if (state.visible.isEmpty)
          AccountPanel(
            children: [
              Text(
                AppLocaleKey.emptyNotifications.tr(),
                textAlign: TextAlign.center,
              ),
            ],
          )
        else
          for (final NotificationItem item in state.visible)
            NotificationCard(
              item: item,
              onOpen: () => cubit.markRead(item),
              onAction: () => cubit.markRead(item),
            ),
        if (state.error.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            state.error,
            textAlign: TextAlign.center,
            style: AppTextStyles.captionRegular.copyWith(color: AppColors.emergency),
          ),
        ],
        const SizedBox(height: 8),
        TextButton(
          onPressed: onPreferences,
          child: Text(AppLocaleKey.communicationPrefs.tr()),
        ),
      ],
    );
  }
}
