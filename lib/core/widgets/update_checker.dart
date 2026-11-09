import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

/// In-app update checker (store-driven, no backend).
///
/// Wraps [child] with an [UpgradeAlert] that compares the installed version
/// with the latest published on Google Play / the App Store and prompts the
/// user to update. Dismissible (Ignore / Later / Update); re-prompts after
/// [durationUntilAlertAgain].
class UpdateChecker extends StatelessWidget {
  const UpdateChecker({
    super.key,
    required this.child,
    this.upgrader,
  });

  final Widget child;

  /// Optional shared [Upgrader] instance. When null a default one is created.
  final Upgrader? upgrader;

  static final Upgrader _defaultUpgrader = Upgrader(
    debugLogging: false,
    durationUntilAlertAgain: const Duration(days: 3),
  );

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: upgrader ?? _defaultUpgrader,
      barrierDismissible: false,
      showIgnore: true,
      showLater: true,
      showReleaseNotes: true,
      child: child,
    );
  }
}
