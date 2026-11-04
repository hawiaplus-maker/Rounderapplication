import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Loading placeholder of the orders screen: skeleton cards shaped like
/// [OrderCard] (icon box, title/sub lines, date + status pill, amount +
/// reference rows) swept by a repeating highlight shimmer while
/// `/resident/bookings` is in flight.
class OrdersShimmerList extends StatelessWidget {
  const OrdersShimmerList({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) => _Shimmer(
    child: ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 118),
      itemCount: itemCount,
      itemBuilder: (context, index) => const _SkeletonOrderCard(),
    ),
  );
}

/// One skeleton card mirroring OrderCard's layout so the content appears to
/// slot into the same slots when loading finishes.
class _SkeletonOrderCard extends StatelessWidget {
  const _SkeletonOrderCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white.withValues(alpha: .95),
      margin: const EdgeInsets.only(bottom: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SkeletonBar(height: 14, widthFactor: .6),
                      SizedBox(height: 8),
                      _SkeletonBar(height: 10, widthFactor: .4),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 22),
            const Row(
              children: [
                Expanded(
                  child: _SkeletonBar(height: 10, widthFactor: .4),
                ),
                SizedBox(width: 12),
                _SkeletonPill(),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Expanded(
                  child: _SkeletonBar(height: 14, widthFactor: .35),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: _SkeletonBar(
                    height: 10,
                    widthFactor: .3,
                    alignment: AlignmentDirectional.centerEnd,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Decorative rectangle of the skeletons; [widthFactor] sizes it relative to
/// its parent so the skeletons adapt like the real text slots.
class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({
    this.height = 12,
    this.widthFactor,
    this.alignment = AlignmentDirectional.centerStart,
  });

  final double height;
  final double? widthFactor;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final bar = Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(height),
      ),
    );
    final factor = widthFactor;
    if (factor == null) return bar;
    return FractionallySizedBox(widthFactor: factor, alignment: alignment, child: bar);
  }
}

class _SkeletonPill extends StatelessWidget {
  const _SkeletonPill();

  @override
  Widget build(BuildContext context) => Container(
    width: 84,
    height: 26,
    decoration: BoxDecoration(
      color: AppColors.mint,
      borderRadius: BorderRadius.circular(999),
    ),
  );
}

/// Sweeps a white highlight band across its child — the skeleton bars take
/// the shine (srcAtop keeps the destination alpha), the background stays
/// clear.
class _Shimmer extends StatefulWidget {
  const _Shimmer({required this.child});

  final Widget child;

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sweep,
      child: widget.child,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [AppColors.mint, AppColors.white, AppColors.mint],
          stops: const [.25, .5, .75],
          transform: _SlidingGradientTransform(slidePercent: _sweep.value),
        ).createShader(bounds),
        child: child,
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * (slidePercent * 2 - 1), 0, 0);
}
