import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_svg_icon.dart';

/// 44 px rounded card action: label followed by the chevron pointing out of
/// the card (left in RTL, right in LTR).
class HomeCardActionButton extends StatelessWidget {
  const HomeCardActionButton({
    super.key,
    required this.label,
    required this.fill,
    required this.labelColor,
    required this.iconColor,
    this.onTap,
  });

  final String label;
  final Color fill;
  final Color labelColor;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      height: HomeSizes.cardButtonHeight,
      width: double.infinity,
      child: Material(
        color: fill,
        borderRadius: BorderRadius.circular(HomeRadii.button),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  label,
                  style: HomeTextStyles.cardButton.copyWith(color: labelColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              HomeSvgIcon(
                isRtl ? AppImages.homeChevronLeft : AppImages.homeChevronRight,
                size: 15,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
