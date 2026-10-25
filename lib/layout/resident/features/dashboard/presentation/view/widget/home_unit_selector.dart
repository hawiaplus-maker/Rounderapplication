import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/model/home_view_models.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_glass_panel.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_svg_icon.dart';

/// Frosted unit picker: building + unit name on the start side, chevron on the
/// end side.
class HomeUnitSelector extends StatelessWidget {
  const HomeUnitSelector({super.key, required this.unit, this.onTap});

  final HomeUnit unit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeSizes.unitSelectorHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(HomeRadii.pill),
          child: HomeGlassPanel(
            radius: HomeRadii.pill,
            shadow: HomeShadows.selector,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
            child: Row(
              children: <Widget>[
                const HomeSvgIcon(
                  AppImages.homeBuilding,
                  size: 24,
                  color: AppColors.petrol,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        unit.name,
                        style: HomeTextStyles.unitTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (unit.code.isNotEmpty)
                        Text(
                          unit.code,
                          style: HomeTextStyles.unitSubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const HomeSvgIcon(
                  AppImages.homeChevronDown,
                  size: 20,
                  color: AppColors.petrol,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
