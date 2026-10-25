import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_line.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_panel.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_sub_page.dart';

/// Association community page: neighbour messages, likes and the message box.
class UnionCommunityPage extends StatelessWidget {
  const UnionCommunityPage({
    super.key,
    required this.onBack,
    required this.message,
    required this.likes,
    required this.onLike,
    required this.onSend,
  });

  final VoidCallback onBack;
  final TextEditingController message;
  final int likes;
  final VoidCallback onLike;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return UnionSubPage(
      titleKey: AppLocaleKey.associationCommunity,
      onBack: onBack,
      children: [
        UnionPanel(
          children: [
            Text(
              AppLocaleKey.unitTitle.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.petrol,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              AppLocaleKey.residentsJoined.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted),
            ),
          ],
        ),
        UnionPanel(
          children: [
            UnionLine(
              titleKey: AppLocaleKey.resident,
              value: AppLocaleKey.neighborMessageOne.tr(),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onLike,
                icon: const Icon(Icons.favorite_border),
                label: Text(likes.toString()),
              ),
            ),
            UnionLine(
              titleKey: AppLocaleKey.resident,
              value: AppLocaleKey.neighborMessageTwo.tr(),
            ),
            UnionLine(
              titleKey: AppLocaleKey.unitTitle,
              value: AppLocaleKey.associationReply.tr(),
            ),
          ],
        ),
        UnionPanel(
          children: [
            TextField(
              controller: message,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: AppLocaleKey.messageHint.tr(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                onPressed: onSend,
                child: Text(AppLocaleKey.sendMessage.tr()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
