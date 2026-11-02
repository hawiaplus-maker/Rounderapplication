import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/notifications_cubit.dart';

/// The design's three filters, in frame order: all, needs action, unread.
class NotificationFilters extends StatelessWidget {
  const NotificationFilters({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  final NotificationFilter filter;
  final ValueChanged<NotificationFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final NotificationFilter value in NotificationFilter.values)
          _FilterChip(
            labelKey: switch (value) {
              NotificationFilter.unread => AppLocaleKey.unread,
              NotificationFilter.actionRequired => AppLocaleKey.actionRequired,
              NotificationFilter.all => AppLocaleKey.allNotifications,
            },
            selected: value == filter,
            onTap: () => onChanged(value),
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.labelKey,
    required this.selected,
    required this.onTap,
  });

  final String labelKey;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(labelKey.tr()),
    selected: selected,
    selectedColor: AppColors.white,
    backgroundColor: AppColors.white.withValues(alpha: .7),
    onSelected: (_) => onTap(),
  );
}
