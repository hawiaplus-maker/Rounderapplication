import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/post_service/presentation/view/widget/aftercare_header.dart';
import 'package:rounder_application/layout/resident/features/post_service/presentation/view/widget/claim_page_body.dart';
import 'package:rounder_application/layout/resident/features/post_service/presentation/view/widget/followup_page_body.dart';
import 'package:rounder_application/layout/resident/features/post_service/presentation/view/widget/warranty_page_body.dart';

/// After-service journey (ما بعد الخدمة — design 882:5138/5202/5266): three
/// local pages — the warranty summary, the Ali-assisted warranty inquiry, and
/// the remedy follow-up steps. No endpoint is called from this prototype.
class AftercareFlowScreen extends StatefulWidget {
  const AftercareFlowScreen({super.key});

  @override
  State<AftercareFlowScreen> createState() => _AftercareFlowScreenState();
}

enum _Page { warranty, claim, followup }

class _AftercareFlowScreenState extends State<AftercareFlowScreen> {
  late _Page _page = _Page.warranty;

  @override
  Widget build(BuildContext context) {
    final titleKey = switch (_page) {
      _Page.warranty => AppLocaleKey.warrantyTitle,
      _Page.claim => AppLocaleKey.aftercareTitle,
      _Page.followup => AppLocaleKey.followupTitle,
    };
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, .25, .42, .6, .78, 1],
            colors: [
              AppColors.petrol,
              AppColors.petrol,
              AppColors.teal,
              AppColors.mintLight,
              AppColors.canvas,
              AppColors.sand,
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: KeyedSubtree(
              key: ValueKey(_page.name),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                children: [
                  AftercareHeader(
                    titleKey: titleKey,
                    onBack: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(height: 18),
                  switch (_page) {
                    _Page.warranty => WarrantyPageBody(
                      onBackToOrder: () => Navigator.maybePop(context),
                      onWarrantyInquiry: () => setState(() => _page = _Page.claim),
                    ),
                    _Page.claim => ClaimPageBody(
                      onViewOriginalDoc: () => setState(() => _page = _Page.warranty),
                      onSubmitForReview: () => setState(() => _page = _Page.followup),
                    ),
                    _Page.followup => FollowupPageBody(
                      onBackToOrder: () => setState(() => _page = _Page.warranty),
                    ),
                  },
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
