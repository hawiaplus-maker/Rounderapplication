import 'dart:ui' as ui_direction show TextDirection;

import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/validation/auth_validators.dart';

/// Frosted entry of the phone register screen (approved login's field style):
/// label + petroled field. `ltr` keeps data-shaped values (email, phone)
/// readable in the Arabic layout; `obscure` password fields carry a
/// visibility toggle. The box hugs its input and lets validator messages
/// grow below it instead of clipping them.
class RegisterFieldEntry extends StatefulWidget {
  const RegisterFieldEntry({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.keyboard,
    this.ltr = false,
    this.validator,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
  });
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboard;
  final bool ltr;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction textInputAction;

  @override
  State<RegisterFieldEntry> createState() => _RegisterFieldEntryState();
}

class _RegisterFieldEntryState extends State<RegisterFieldEntry> {
  /// Password pairs arrive hidden; plain entries always show.
  late bool _shown = !widget.obscure;

  void _toggleVisibility() => setState(() => _shown = !_shown);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: AppColors.petrol,
            fontSize: 16,
            height: 24 / 16,
          ),
        ),
        SizedBox(height: 5),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          constraints: const BoxConstraints(minHeight: 56),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: .45),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.stroke),
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboard,
            obscureText: widget.obscure && !_shown,
            autofillHints: widget.obscure
                ? const [AutofillHints.password]
                : null,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.obscure
                ? TextCapitalization.none
                : TextCapitalization.sentences,
            onFieldSubmitted: widget.onSubmitted,
            validator: widget.validator ?? AuthValidators.requiredField,
            // Data-shaped values stay LTR even in the Arabic layout.
            textDirection: widget.ltr ? ui_direction.TextDirection.ltr : null,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 16,
              height: 26 / 16,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsetsDirectional.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              suffixIcon: widget.obscure
                  ? IconButton(
                      // The entry icons family is outlined; muted keeps the
                      // toggle secondary to the petroled input text.
                      onPressed: _toggleVisibility,
                      icon: Icon(
                        _shown
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 22,
                        color: AppColors.muted,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 42,
                        minHeight: 42,
                      ),
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      visualDensity: VisualDensity.compact,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
