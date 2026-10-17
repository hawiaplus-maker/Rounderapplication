import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Figma 642:1021: explicit discard, with keep-editing as the primary action.
Future<bool> confirmDiscardProfile(BuildContext context) async =>
  await showDialog<bool>(context: context, builder: (context) => Dialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 350),
      child: Padding(padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(AppLocaleKey.discardChangesTitle.tr(), style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: AppColors.petrol)),
          const SizedBox(height: 12),
          Text(AppLocaleKey.unsavedChanges.tr(), style: const TextStyle(fontSize: 14, color: const Color(0xFF0F6570))),
          const SizedBox(height: 28),
          FilledButton(onPressed: () => Navigator.pop(context, false),
            style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: AppColors.petrol,
              minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            child: Text(AppLocaleKey.keepEditing.tr())),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.mint, foregroundColor: AppColors.petrol,
              minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            child: Text(AppLocaleKey.discardChanges.tr())),
        ])),
    ),
  )) ?? false;
