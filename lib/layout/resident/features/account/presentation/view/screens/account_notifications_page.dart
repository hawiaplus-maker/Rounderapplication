import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_sub_page.dart';

/// Notifications page with its filters and read-all action.
class AccountNotificationsPage extends StatelessWidget {
  const AccountNotificationsPage({
    super.key,
    required this.onBack,
    required this.filter,
    required this.onFilterChanged,
    required this.read,
    required this.onReadAll,
    required this.onReviewNow,
  });

  final VoidCallback onBack;
  final int filter;
  final ValueChanged<int> onFilterChanged;
  final bool read;
  final VoidCallback onReadAll;
  final VoidCallback onReviewNow;

  @override
  Widget build(BuildContext context) {
    return AccountSubPage(
      titleKey: AppLocaleKey.notifications,
      onBack: onBack,
      children: [
        Row(
          children: [
            TextButton(
              onPressed: onReadAll,
              child: Text(AppLocaleKey.readAll.tr()),
            ),
            const Spacer(),
            Text(
              '${AppLocaleKey.actionRequired.tr()}: 2',
              style: const TextStyle(color: AppColors.white, fontSize: 12),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            _FilterChip(
              labelKey: AppLocaleKey.allNotifications,
              selected: filter == 0,
              onTap: () => onFilterChanged(0),
            ),
            _FilterChip(
              labelKey: AppLocaleKey.actionRequired,
              selected: filter == 1,
              onTap: () => onFilterChanged(1),
            ),
            _FilterChip(
              labelKey: AppLocaleKey.unread,
              selected: filter == 2,
              onTap: () => onFilterChanged(2),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (filter == 0 || filter == 1)
          _NotificationCard(
            titleKey: AppLocaleKey.notificationOfferTitle,
            bodyKey: AppLocaleKey.notificationOfferBody,
            icon: Icons.request_quote_outlined,
            read: read,
            onReviewNow: onReviewNow,
          ),
        if (filter == 0 || (filter == 2 && !read))
          _NotificationCard(
            titleKey: AppLocaleKey.notificationReportTitle,
            bodyKey: AppLocaleKey.notificationReportBody,
            icon: Icons.fact_check_outlined,
            read: read,
            onReviewNow: onReviewNow,
          ),
        if (filter == 2 && read)
          AccountPanel(
            children: [
              Text(
                AppLocaleKey.emptyNotifications.tr(),
                textAlign: TextAlign.center,
              ),
            ],
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
    selectedColor: Colors.white,
    backgroundColor: Colors.white70,
    onSelected: (_) => onTap(),
  );
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.titleKey,
    required this.bodyKey,
    required this.icon,
    required this.read,
    required this.onReviewNow,
  });

  final String titleKey;
  final String bodyKey;
  final IconData icon;
  final bool read;
  final VoidCallback onReviewNow;

  @override
  Widget build(BuildContext context) {
    return AccountPanel(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.orange),
            const Spacer(),
            Text(
              read ? AppLocaleKey.notifications.tr() : AppLocaleKey.unread.tr(),
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          titleKey.tr(),
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: AppColors.petrol,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          bodyKey.tr(),
          textAlign: TextAlign.right,
          style: const TextStyle(height: 1.6),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onReviewNow,
            child: Text(
              AppLocaleKey.reviewNow.tr(),
              style: const TextStyle(color: AppColors.orange),
            ),
          ),
        ),
      ],
    );
  }
}
