import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/legal_document_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_sub_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';
import 'package:rounder_application/layout/global/widgets/brand_gradient_backdrop.dart';

/// In-app viewer for a backend-served legal document (privacy / terms).
class LegalDocumentPage extends StatefulWidget {
  const LegalDocumentPage({super.key, required this.slug});

  /// 'privacy' or 'terms'.
  final String slug;

  @override
  State<LegalDocumentPage> createState() => _LegalDocumentPageState();
}

class _LegalDocumentPageState extends State<LegalDocumentPage> {
  @override
  void initState() {
    super.initState();
    context.read<LegalDocumentCubit>().load(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LegalDocumentCubit, LegalDocumentState>(
      builder: (context, state) {
        final String title = switch (state) {
          LegalDocumentReady(:final document) => document.title,
          _ => widget.slug == 'terms'
              ? AppLocaleKey.termsConditions.tr()
              : AppLocaleKey.privacyPolicy.tr(),
        };
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: BrandGradientBackdrop.deep(
            child: SafeArea(
              child: AccountSubPage(
                titleKey: widget.slug == 'terms'
                    ? AppLocaleKey.termsConditions
                    : AppLocaleKey.privacyPolicy,
                onBack: () => Navigator.of(context).pop(),
                children: [
                  AccountPanel(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.start,
                        style: AppTextStyles.extraBold20.copyWith(
                          color: AppColors.petrol,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: AppColors.stroke),
                      const SizedBox(height: 14),
                      switch (state) {
                        LegalDocumentLoading() => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        LegalDocumentFailure(:final message) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              message,
                              textAlign: TextAlign.start,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: () => context
                                  .read<LegalDocumentCubit>()
                                  .load(widget.slug),
                              child: Text(AppLocaleKey.retry.tr()),
                            ),
                          ],
                        ),
                        LegalDocumentReady(:final document) => SelectableText(
                          document.content,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodyRegular15.copyWith(
                            color: AppColors.ink,
                            height: 1.8,
                          ),
                        ),
                      },
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
