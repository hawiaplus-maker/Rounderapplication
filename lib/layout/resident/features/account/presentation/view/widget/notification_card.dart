import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/notification_item_model.dart';
import 'package:rounder_application/logic/number_text_logic.dart';
import 'package:rounder_application/logic/relative_time_logic.dart';

/// One notification of the feed (design 683:1352): the meta line (new / needs
/// action / relative time), the title, the residence context, the body and the
/// server-provided action label.
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.item,
    required this.onOpen,
    required this.onAction,
  });

  final NotificationItem item;
  final VoidCallback onOpen, onAction;

  @override
  Widget build(BuildContext context) {
    final List<String> meta = [
      if (!item.isRead) AppLocaleKey.notificationNew.tr(),
      if (item.requiresAction) AppLocaleKey.actionRequired.tr(),
      if (item.createdAt != null) _relativeTime(context, item.createdAt!),
    ];
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
      child: Material(
        color: AppColors.white.withValues(alpha: .92),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.white.withValues(alpha: .9)),
        ),
        child: InkWell(
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (meta.isNotEmpty)
                  Text(
                    meta.join(' • '),
                    textAlign: TextAlign.start,
                    style: AppTextStyles.captionRegular.copyWith(color: AppColors.teal),
                  ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.headingH4.copyWith(color: AppColors.petrol, height: 26 / 16),
                ),
                if (item.context.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.context,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.captionRegular13.copyWith(color: AppColors.muted, height: 22 / 13),
                  ),
                ],
                if (item.body.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.body,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.petrol, height: 24 / 14),
                  ),
                ],
                if (item.actionLabel.isNotEmpty)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: onAction,
                      child: Text(
                        item.actionLabel,
                        style: AppTextStyles.labelAction.copyWith(color: AppColors.orange),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// `قبل ٥ دقائق` — the logic returns the bucket and its count, the page
  /// words it with the locale's plural form.
  String _relativeTime(BuildContext context, DateTime createdAt) {
    final RelativeTime relative = relativeTime(createdAt);
    final String language = Localizations.localeOf(context).languageCode;
    final String count = localizedNumber(relative.value, language);
    final Map<String, String> namedArgs = {'count': count};
    return switch (relative.unit) {
      RelativeTimeUnit.now => AppLocaleKey.timeNow.tr(),
      RelativeTimeUnit.minute => AppLocaleKey.timeMinutesAgo.plural(
        relative.value,
        namedArgs: namedArgs,
      ),
      RelativeTimeUnit.hour => AppLocaleKey.timeHoursAgo.plural(
        relative.value,
        namedArgs: namedArgs,
      ),
      RelativeTimeUnit.day => AppLocaleKey.timeDaysAgo.plural(
        relative.value,
        namedArgs: namedArgs,
      ),
    };
  }
}
