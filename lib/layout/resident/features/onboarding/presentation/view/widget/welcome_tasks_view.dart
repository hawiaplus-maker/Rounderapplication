import 'dart:ui' as ui_direction show TextDirection;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Setup checklist shown after the onboarding intro.
class WelcomeTasksView extends StatelessWidget {
  const WelcomeTasksView({
    super.key,
    required this.profileDone,
    required this.addressDone,
    required this.onCompleteProfile,
    required this.onSaveResidence,
    required this.onPickGift,
    required this.onContinueLater,
  });

  final bool profileDone;
  final bool addressDone;
  final VoidCallback onCompleteProfile;
  final VoidCallback onSaveResidence;
  final VoidCallback onPickGift;
  final VoidCallback onContinueLater;

  @override
  Widget build(BuildContext context) {
    final allDone = profileDone && addressDone;
    return ListView(
      key: const ValueKey('welcome-tasks'),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      children: [
        Text(
          AppLocaleKey.welcomeSteps.tr(),
          style: TextStyle(color: AppColors.white.withValues(alpha: .7)),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocaleKey.welcomeGiftTitle.tr(),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 30,
            height: 1.2,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        _TaskCard(
          titleKey: AppLocaleKey.completeProfile,
          icon: Icons.person_outline,
          complete: profileDone,
          onTap: onCompleteProfile,
        ),
        _TaskCard(
          titleKey: AppLocaleKey.saveResidence,
          icon: Icons.location_on_outlined,
          complete: addressDone,
          onTap: onSaveResidence,
        ),
        _TaskCard(
          titleKey: AppLocaleKey.pickWelcomeGift,
          icon: Icons.card_giftcard_outlined,
          complete: allDone,
          onTap: onPickGift,
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: allDone ? onPickGift : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.coral,
            foregroundColor: AppColors.petrol,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(AppLocaleKey.pickWelcomeGift.tr()),
        ),
        TextButton(
          onPressed: onContinueLater,
          child: Text(
            AppLocaleKey.continueLater.tr(),
            style: const TextStyle(color: AppColors.petrol),
          ),
        ),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.titleKey,
    required this.icon,
    required this.complete,
    required this.onTap,
  });

  final String titleKey;
  final IconData icon;
  final bool complete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    color: AppColors.white.withValues(alpha: .95),
    margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: ListTile(
      tileColor: AppColors.white,
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColors.mint,
        child: Icon(complete ? Icons.check : icon, color: AppColors.petrol),
      ),
      title: Text(
        titleKey.tr(),
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.petrol,
        ),
      ),
      subtitle: Text(
        complete ? AppLocaleKey.taskComplete.tr() : AppLocaleKey.taskAction.tr(),
      ),
      trailing: Icon(
        complete
            ? Icons.check_circle
            : (Directionality.of(context) == ui_direction.TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right),
        color: complete ? AppColors.teal : AppColors.coral,
      ),
    ),
  );
}
