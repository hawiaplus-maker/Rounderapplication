import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders one of the Figma SVG exports used by the resident home.
///
/// The files carry their own stroke colors; [color] replaces them
/// (BlendMode.srcIn) when the design tints the glyph.
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
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
