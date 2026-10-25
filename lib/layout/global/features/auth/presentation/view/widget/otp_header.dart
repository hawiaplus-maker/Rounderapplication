import 'dart:ui' as ui_direction show TextDirection;

import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Top bar of the auth verification screens: title on the reading start side
/// and a circular back affordance on the trailing side (design Header 44px).
class OtpHeader extends StatelessWidget {
  const OtpHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 23,
              height: 34 / 23,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: .15),
            ),
            alignment: Alignment.center,
            child: _DirectionalBackChevron(),
          ),
        ),
      ],
    );
  }
}

class _DirectionalBackChevron extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // design icon-chevron-right: in RTL the back arrow points toward the
    // previous (right-side) screen — mirrored with the layout direction.
    final rtl = Directionality.of(context) == ui_direction.TextDirection.rtl;
    return Icon(
      rtl ? Icons.chevron_right : Icons.chevron_left,
      size: 22,
      color: AppColors.white,
    );
  }
}
