import 'dart:ui' as ui_text_direction;

import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/widgets/svg_icon.dart';

/// Category tile of the services hub (Figma 298:251): white glass card, orange
/// accent line on top, centered heading over a hairline separator, service
/// subtitle, and the "open" chevron circle at the directional end edge.
class ServicesCategoryCard extends StatelessWidget {
  const ServicesCategoryCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.onTap,
  });

  final String name;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool rtl =
        Directionality.of(context) == ui_text_direction.TextDirection.rtl;
    return Material(
      color: AppColors.glassCardFill,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.glassCardStroke),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            const SizedBox(height: 1),
            // Orange accent line pinned to the card's top edge.
            Container(
              height: 3,
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.coral,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headingBold26.copyWith(color: AppColors.petrol),
              ),
            ),
            const SizedBox(height: 24),
            // Hairline separator between heading and subtitle.
            Container(
              width: 52,
              height: 1,
              decoration: BoxDecoration(
                color: AppColors.petrol.withValues(alpha: .16),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.petrol),
                ),
              ),
            ),
            _OpenCircle(rtl: rtl),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// The 36×36 frosted "open" circle; the chevron points along the reading
/// direction (left in ar, right in en) like the approved frame.
class _OpenCircle extends StatelessWidget {
  const _OpenCircle({required this.rtl});

  final bool rtl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.petrol.withValues(alpha: .09)),
          ),
          child: Center(
            child: SvgIcon(
              rtl ? AppImages.homeChevronLeft : AppImages.homeChevronRight,
              size: 22,
              color: AppColors.petrol,
            ),
          ),
        ),
      ),
    );
  }
}