import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_svg_icon.dart';

/// Brand wordmark on the start side and the weather / location context on the
/// end side.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeSizes.topBarHeight,
      child: Row(
        children: <Widget>[
          Image.asset(
            AppImages.rounderWordmark,
            width: 118,
            height: 26,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerEnd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _ContextItem(
                    label: AppLocaleKey.dammamCity.tr(),
                    icon: AppImages.homePin,
                    iconSize: 15,
                    gap: 4,
                    style: HomeTextStyles.city,
                  ),
                  const SizedBox(width: 8),
                  _ContextItem(
                    label: AppLocaleKey.homeWeather.tr(),
                    icon: AppImages.homeSun,
                    iconSize: 16,
                    gap: 5,
                    style: HomeTextStyles.weather,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon-trailing label pair; the icon sits on the outer (left) edge in RTL as
/// in the frame.
class _ContextItem extends StatelessWidget {
  const _ContextItem({
    required this.label,
    required this.icon,
    required this.iconSize,
    required this.gap,
    required this.style,
  });

  final String label;
  final String icon;
  final double iconSize;
  final double gap;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
        SizedBox(width: gap),
        HomeSvgIcon(icon, size: iconSize, color: AppColors.white),
      ],
    );
  }
}
