import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Filled text field of the account forms.
class AccountInput extends StatelessWidget {
  const AccountInput({
    super.key,
    required this.labelKey,
    required this.controller,
    this.keyboard,
  });

  final String labelKey;
  final TextEditingController controller;
  final TextInputType? keyboard;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: labelKey.tr(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: AppColors.mint.withValues(alpha: .45),
      ),
    );
  }
}
