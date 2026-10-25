import 'package:flutter/material.dart';

import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_svg_icon.dart';

/// Card header shared by the dashboard cards: title on the start side, icon on
/// the end side (as drawn in the frame).
class HomeCardHeader extends StatelessWidget {
  const HomeCardHeader({
    super.key,
    required this.title,
    required this.icon,
    this.titleStyle,
    this.iconColor = AppColors.petrol,
    this.iconSize = 20,
  });

  final String title;
  final String icon;
  final TextStyle? titleStyle;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: titleStyle,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          HomeSvgIcon(icon, size: iconSize, color: iconColor),
        ],
      ),
    );
  }
}
