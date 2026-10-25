import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// White panel with the verification-code field and its resend prompt
/// (design Content card: white fill, radius 24, pad 20).
class OtpCodePanel extends StatelessWidget {
  const OtpCodePanel({
    super.key,
    required this.title,
    required this.prompt,
    required this.controller,
  });
  final String title;
  final String prompt;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 22,
              height: 34 / 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 25,
              height: 38 / 25,
              fontWeight: FontWeight.w700,
              letterSpacing: 6,
            ),
            decoration: const InputDecoration(
              hintText: '——————',
              hintStyle: TextStyle(
                color: AppColors.muted,
                fontSize: 22,
                height: 38 / 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 6,
              ),
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide(color: AppColors.teal, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide(color: AppColors.teal, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            prompt,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.teal,
              fontSize: 12,
              height: 22 / 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
