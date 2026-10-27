import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Filled action row of the auth screens (design `Authentication / Action`):
/// full-width pill, petrol label — fill color carries the hierarchy
/// (coral = primary, mintLight = secondary). OTP uses 48/16; the approved
/// login uses the same component at 54/12 with a larger label. When
/// [inProgress] the action shows a petrol spinner and stays disabled.
class OtpAction extends StatelessWidget {
  const OtpAction({
    super.key,
    required this.label,
    required this.fill,
    this.onPressed,
    this.height = 48,
    this.radius = 16,
    this.labelSize = 14,
    this.labelLineHeight = 22,
    this.inProgress = false,
  });
  final String label;
  final Color fill;
  final VoidCallback? onPressed;
  final double height;
  final double radius;
  final double labelSize;
  final double labelLineHeight;
  final bool inProgress;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: inProgress ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: fill,
        foregroundColor: AppColors.petrol,
        minimumSize: Size.fromHeight(height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: inProgress
          ? SizedBox(
              width: labelSize + 6,
              height: labelSize + 6,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.petrol,
              ),
            )
          : Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.petrol,
                fontSize: labelSize,
                height: labelLineHeight / labelSize,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
