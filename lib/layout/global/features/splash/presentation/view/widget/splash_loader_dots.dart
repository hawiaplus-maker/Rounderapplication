import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Three pulsing loader dots of the splash frame (design: 8px dots, 7px apart,
/// white at 35% / 60% / 100%). They breathe in sequence while the session is
/// restored.
class SplashLoaderDots extends StatefulWidget {
  const SplashLoaderDots({super.key});

  @override
  State<SplashLoaderDots> createState() => _SplashLoaderDotsState();
}

class _SplashLoaderDotsState extends State<SplashLoaderDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          final phase = (_controller.value + index * .2) % 1;
          final opacity = .35 + .55 * (1 - (2 * phase - 1).abs());
          return Padding(
            padding: EdgeInsetsDirectional.only(start: index == 0 ? 0 : 7),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(alpha: opacity),
              ),
            ),
          );
        }),
      ),
    );
  }
}
