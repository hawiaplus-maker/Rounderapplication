import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Loading / failure card shared by the resident features (rounder-shared-
/// widgets): a spinner while the request runs, then the message with a retry
/// action. Pages inside their own padded list pass [margin] zero.
class StatePanel extends StatelessWidget {
  const StatePanel({
    super.key,
    required this.message,
    this.loading = false,
    this.onRetry,
    this.margin = const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
  });

  final String message;
  final bool loading;
  final VoidCallback? onRetry;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
        color: AppColors.white.withValues(alpha: .93),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: loading
                ? const Center(
                    child: SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: AppColors.petrol,
                      ),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.petrol),
                      ),
                      if (onRetry != null) ...[
                        const SizedBox(height: 6),
                        TextButton(
                          onPressed: onRetry,
                          child: Text(
                            AppLocaleKey.retry.tr(),
                            style: AppTextStyles.labelAction.copyWith(color: AppColors.orange),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
