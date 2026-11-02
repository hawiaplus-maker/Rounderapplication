import 'dart:ui' as ui_direction;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Title bar shared by all association pages.
class UnionHeader extends StatelessWidget {
  const UnionHeader({super.key, required this.titleKey, this.onBack, this.showBack = false})
    : assert(!showBack || onBack != null);

  final String titleKey;
  final VoidCallback? onBack;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      child: Row(
        children: [
          if (showBack)
            IconButton(onPressed: onBack, icon: const _BackChevron())
          else
            const SizedBox(width: 8),
          const Spacer(),
          Text(titleKey.tr(), style: AppTextStyles.extraBold21.copyWith(color: AppColors.white)),
          const SizedBox(width: 8),
          if (!showBack) const Icon(Icons.apartment, color: AppColors.white),
        ],
      ),
    );
  }
}

class _BackChevron extends StatelessWidget {
  const _BackChevron();

  @override
  Widget build(BuildContext context) {
    // In RTL the back arrow points toward the previous (right-side) screen —
    // mirrored with the layout direction.
    final rtl = Directionality.of(context) == ui_direction.TextDirection.rtl;
    return Icon(rtl ? Icons.arrow_back_ios_new : Icons.arrow_back_ios_new, color: AppColors.white);
  }
}
