import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/splash/presentation/view/widget/splash_brand_lockup.dart';
import 'package:rounder_application/layout/global/features/splash/presentation/view/widget/splash_loader_dots.dart';

/// Brand splash (design `00 — سبلاش • Splash`): brand gradient, orbit lockup
/// and a pulsing loader. It stays on screen while the stored session is
/// restored (and for the short minimum display window wired in `app.dart`).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<double> _scale = Tween<double>(
    begin: .94,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// The frame top is brand petrol, so the system status icons must be light.
  static const _overlayStyle = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, .25, .42, .6, .78, 1],
              colors: [
                AppColors.petrol,
                AppColors.petrol,
                AppColors.teal,
                AppColors.mintLight,
                AppColors.canvas,
                AppColors.sand,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: const Alignment(0, -.17),
                  child: FadeTransition(
                    opacity: _fade,
                    child: ScaleTransition(scale: _scale, child: const SplashBrandLockup()),
                  ),
                ),
                const Align(alignment: Alignment(0, .47), child: SplashLoaderDots()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
