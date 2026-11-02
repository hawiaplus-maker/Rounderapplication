import 'package:flutter/material.dart';

import 'package:rounder_application/layout/global/widgets/svg_icon.dart';

/// Dashboard alias of the promoted global [SvgIcon] renderer; every home
/// widget keeps using this name while the implementation stays in one place.
@Deprecated('Use the global SvgIcon from layout/global/widgets/svg_icon.dart')
class HomeSvgIcon extends StatelessWidget {
  const HomeSvgIcon(
    this.asset, {
    super.key,
    required this.size,
    this.color,
  });

  final String asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgIcon(asset, size: size, color: color);
  }
}
