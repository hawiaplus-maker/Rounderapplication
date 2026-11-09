import 'dart:ui' as ui_direction;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';

/// Confirmation card of the contact success page: thanks copy, the ticket
/// reference returned by the backend, the reception time and the reply note.
class AccountContactSuccessCard extends StatelessWidget {
  const AccountContactSuccessCard({
    super.key,
    required this.reference,
    required this.submittedAt,
  });

  final String reference;
  final DateTime submittedAt;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final String time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(submittedAt),
    );
    final bool rtl =
        Directionality.of(context) == ui_direction.TextDirection.rtl;
    final String received =
        '${AppLocaleKey.contactReceivedToday.tr()}${rtl ? '،' : ','} $time';

    return AccountPanel(
      children: [
        Center(
          child: Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.petrol,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppLocaleKey.contactThanksTitle.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.extraBold20.copyWith(color: AppColors.petrol),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocaleKey.contactThanksBody.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyRegular15.copyWith(
            color: AppColors.muted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.mint.withValues(alpha: .38),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocaleKey.contactTicketReference.tr(),
                      textAlign: TextAlign.start,
                      style: AppTextStyles.captionRegular.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reference,
                      textDirection: ui_direction.TextDirection.ltr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyBold15.copyWith(
                        color: AppColors.petrol,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocaleKey.contactReceivedAt.tr(),
                      textAlign: TextAlign.start,
                      style: AppTextStyles.captionRegular.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      received,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyBold15.copyWith(
                        color: AppColors.petrol,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.mint.withValues(alpha: .38),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                size: 20,
                color: AppColors.teal,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocaleKey.contactNotificationNote.tr(),
                  textAlign: TextAlign.start,
                  style: AppTextStyles.captionMedium13.copyWith(
                    color: AppColors.petrol,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
