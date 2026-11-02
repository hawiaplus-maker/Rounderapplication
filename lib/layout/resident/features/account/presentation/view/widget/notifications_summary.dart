import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/logic/number_text_logic.dart';

/// Summary line of the notifications page (design 683:1352): the counts on
/// the reading edge and the "mark all read" action on the other.
class NotificationsSummary extends StatelessWidget {
  const NotificationsSummary({
    super.key,
    required this.actionCount,
    required this.unreadCount,
    required this.busy,
    required this.onReadAll,
  });

  final int actionCount, unreadCount;
  final bool busy;
  final VoidCallback onReadAll;

  @override
  Widget build(BuildContext context) {
    final String language = Localizations.localeOf(context).languageCode;
    return Row(
      children: [
        Expanded(
          child: Text(
            AppLocaleKey.notificationsSummary.tr(
              namedArgs: {
                'action': localizedNumber(actionCount, language),
                'unread': localizedNumber(unreadCount, language),
              },
            ),
            textAlign: TextAlign.start,
            style: AppTextStyles.captionRegular.copyWith(color: AppColors.white),
          ),
        ),
        if (busy)
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.white,
            ),
          )
        else
          TextButton(
            onPressed: unreadCount == 0 ? null : onReadAll,
            child: Text(AppLocaleKey.readAll.tr()),
          ),
      ],
    );
  }
}
