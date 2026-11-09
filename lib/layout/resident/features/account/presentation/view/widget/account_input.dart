import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Filled text field of the account forms.
///
/// It is also the single form field of the account pages that validate their
/// input (the contact message), so it exposes the standard [TextFormField]
/// hooks while keeping the account look.
class AccountInput extends StatelessWidget {
  const AccountInput({
    super.key,
    required this.labelKey,
    required this.controller,
    this.keyboard,
    this.validator,
    this.hintKey,
    this.maxLines = 1,
    this.textInputAction,
  });

  final String labelKey;
  final TextEditingController controller;
  final TextInputType? keyboard;

  /// Optional field rule; the field must sit inside a [Form] for it to run.
  final String? Function(String?)? validator;

  /// Optional placeholder under the label.
  final String? hintKey;

  /// More than one line turns the field into the multiline description box.
  final int maxLines;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      textInputAction: textInputAction,
      maxLines: maxLines,
      textAlign: TextAlign.start,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelKey.tr(),
        hintText: hintKey?.tr(),
        alignLabelWithHint: maxLines > 1,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: AppColors.mint.withValues(alpha: .45),
      ),
    );
  }
}
