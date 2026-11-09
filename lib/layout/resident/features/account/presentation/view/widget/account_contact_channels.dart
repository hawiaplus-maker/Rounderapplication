import 'dart:ui' as ui_direction;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';

/// Support channels card of the contact page: chat, phone and email.
class AccountContactChannels extends StatelessWidget {
  const AccountContactChannels({
    super.key,
    required this.phone,
    required this.email,
    required this.hours,
    required this.onChat,
    required this.onCall,
    required this.onEmail,
  });

  final String phone;
  final String email;
  final String hours;
  final VoidCallback onChat;
  final VoidCallback onCall;
  final VoidCallback onEmail;

  @override
  Widget build(BuildContext context) {
    return AccountPanel(
      children: [
        Text(
          AppLocaleKey.contactChannelsTitle.tr(),
          textAlign: TextAlign.start,
          style: AppTextStyles.extraBold20.copyWith(color: AppColors.petrol),
        ),
        const SizedBox(height: 12),
        _ChannelRow(
          icon: Icons.support_agent,
          titleKey: AppLocaleKey.contactChat,
          caption: hours,
          onTap: onChat,
        ),
        const SizedBox(height: 8),
        _ChannelRow(
          icon: Icons.phone_outlined,
          titleKey: AppLocaleKey.contactCall,
          caption: phone,
          captionLtr: true,
          onTap: onCall,
        ),
        const SizedBox(height: 8),
        _ChannelRow(
          icon: Icons.mail_outline,
          titleKey: AppLocaleKey.contactEmail,
          caption: email,
          captionLtr: true,
          onTap: onEmail,
        ),
      ],
    );
  }
}

class _ChannelRow extends StatelessWidget {
  const _ChannelRow({
    required this.icon,
    required this.titleKey,
    required this.caption,
    required this.onTap,
    this.captionLtr = false,
  });

  final IconData icon;
  final String titleKey;
  final String caption;
  final VoidCallback onTap;

  /// Phone numbers and e-mail addresses keep their LTR order while the row
  /// itself mirrors with the app language.
  final bool captionLtr;

  @override
  Widget build(BuildContext context) {
    final bool rtl =
        Directionality.of(context) == ui_direction.TextDirection.rtl;
    return Material(
      color: AppColors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.mint),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.mint,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: AppColors.teal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleKey.tr(),
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyBold15.copyWith(
                        color: AppColors.petrol,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      caption,
                      textAlign: TextAlign.start,
                      textDirection: captionLtr
                          ? ui_direction.TextDirection.ltr
                          : null,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.captionRegular13.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                rtl ? Icons.chevron_left : Icons.chevron_right,
                size: 18,
                color: AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
