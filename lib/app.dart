import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/screen/login_screen.dart';
import 'package:rounder_application/layout/global/features/splash/presentation/view/screen/splash_screen.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/screen/resident_home_screen.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/screen/onboarding_intro_screen.dart';
import 'package:rounder_application/layout/resident/features/onboarding/data/repo/onboarding_repository.dart';

class RounderApp extends StatelessWidget {
  const RounderApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Rounder',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    locale: context.locale,
    supportedLocales: context.supportedLocales,
    localizationsDelegates: context.localizationDelegates,
    home: const _BootGate(),
  );
}

/// Boot skeleton: shows the brand splash while the stored session is restored
/// and keeps it for the design's minimum display window (1200ms), then routes
/// to the resident home or the login screen.
class _BootGate extends StatefulWidget {
  const _BootGate();

  @override
  State<_BootGate> createState() => _BootGateState();
}

class _BootGateState extends State<_BootGate> {
  bool _minElapsed = false;
  Future<bool>? _onboardingSeen;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _onboardingSeen = sl<OnboardingRepository>().hasSeenIntro();
    _timer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _minElapsed = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (!_minElapsed || state is AuthChecking) return const SplashScreen();
        return FutureBuilder<bool>(
          future: _onboardingSeen,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) return const SplashScreen();
            if (snapshot.data == false) {
              return OnboardingIntroScreen(
                onDone: () async {
                  await sl<OnboardingRepository>().markIntroSeen();
                  if (mounted) {
                    setState(() {
                      _onboardingSeen = Future.value(true);
                    });
                  }
                },
              );
            }
            if (state is Authenticated) {
              return BlocProvider(
                create: (_) => sl<ResidentDashboardCubit>()..load(),
                child: const ResidentHomeScreen(),
              );
            }
            return const LoginScreen();
          },
        );
      },
    );
  }
}
