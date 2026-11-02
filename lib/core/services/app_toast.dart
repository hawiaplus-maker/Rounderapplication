import 'package:flutter/material.dart';

/// Root messenger key so non-widget layers (network, repositories) can show
/// the backend's message without a [BuildContext].
final GlobalKey<ScaffoldMessengerState> appMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Shows a successful API response's message as the app-wide toast/snackbar.
/// Empty messages and the window before the app is mounted are ignored.
void showApiToast(String? message) {
  final String text = message?.trim() ?? '';
  if (text.isEmpty) return;

  final ScaffoldMessengerState? messenger = appMessengerKey.currentState;
  if (messenger == null) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}
