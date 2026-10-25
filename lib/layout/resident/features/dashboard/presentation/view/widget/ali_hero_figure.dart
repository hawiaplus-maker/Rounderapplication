import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_svg_icon.dart';

/// Ali plus the orbit artwork and the three floating service chips.
///
/// The composition is anchored to the hero's end (left in RTL): the figure
/// sits on the left, the orbit circles are concentric around it and the chips
/// ride on the rings.
class AliHeroFigure extends StatelessWidget {
  const AliHeroFigure({super.key});

  static const double _figureWidth = 145;
  static const double _figureHeight = 173;

  // Orbit centre measured from the hero's left edge / top edge.
  static const double _orbitCenterX = 87;
  static const double _orbitCenterY = 93;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _figureWidth,
      height: _figureHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // Outer orbit (204) and inner orbit (174).
          PositionedDirectional(
            end: _orbitCenterX - 102,
            top: _orbitCenterY - 102,
            width: 204,
            height: 204,
            child: const _OrbitCircle(),
          ),
          PositionedDirectional(
            end: _orbitCenterX - 87,
            top: _orbitCenterY - 87,
            width: 174,
            height: 174,
            child: const _OrbitCircle(),
          ),
          PositionedDirectional(
            end: 0,
            bottom: 0,
            width: _figureWidth,
            height: _figureHeight,
            child: Image.asset(AppImages.aliHomePresenting, fit: BoxFit.contain),
          ),
          // Service chips floating on the rings.
          PositionedDirectional(
            end: 3,
            top: 11,
            child: _ServiceChip(icon: AppImages.homeCarOrbit),
          ),
          PositionedDirectional(
            end: 143,
            top: 5,
            child: _ServiceChip(icon: AppImages.homeCalendar),
          ),
          PositionedDirectional(
            end: -2,
            top: 106,
            child: _ServiceChip(icon: AppImages.homeHouseOrbit),
          ),
        ],
      ),
    );
  }
}

class _OrbitCircle extends StatelessWidget {
  const _OrbitCircle();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.glassOrbitStroke),
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.glassChipFill,
        border: Border.all(color: AppColors.glassChipStroke),
      ),
      alignment: AlignmentDirectional.center,
      child: HomeSvgIcon(icon, size: 14, color: AppColors.white),
    );
  }
}
