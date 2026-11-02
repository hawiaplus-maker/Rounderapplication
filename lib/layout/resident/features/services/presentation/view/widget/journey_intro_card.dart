import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/widgets/svg_icon.dart';

/// Dark glass intro card used across the service flow pages (Figma 511:814 /
/// 511:813 / 554:1006): frosted white plate, document glyph and the page's
/// guidance copy. [message] arrives pre-translated from the page.
class JourneyIntroCard extends StatelessWidget {
  const JourneyIntroCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.glassPillFill,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassPillStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SvgIcon(AppImages.homeFileText, size: 28, color: AppColors.white),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.start,
            style: AppTextStyles.bodyRegular15.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
