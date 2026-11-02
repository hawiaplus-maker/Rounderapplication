import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders one of the Figma SVG exports used by the resident app.
///
/// The files carry their own stroke colors; [color] replaces them
/// (BlendMode.srcIn) when the design tints the glyph.
///
/// Promoted here (rounder-shared-widgets) when the services hub became the
/// second feature consuming the renderer; the dashboard's `HomeSvgIcon`
/// delegates to this class so every consumer stays on one home.
class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.asset, {
    super.key,
    required this.size,
    this.color,
    this.semanticLabel,
  });

  final String asset;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
    );
  }
}
