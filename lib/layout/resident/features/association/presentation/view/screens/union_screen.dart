import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/global/widgets/brand_gradient_backdrop.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/model/union_section.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_community_page.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_dues_page.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_facilities_page.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_finances_page.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_initiative_page.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_news_page.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_overview_page.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_visits_page.dart';

/// Association and resident-community prototype. Uses local UI sample values;
/// API integration is intentionally deferred.
class UnionScreen extends StatefulWidget {
  const UnionScreen({super.key});

  @override
  State<UnionScreen> createState() => _UnionScreenState();
}

class _UnionScreenState extends State<UnionScreen> {
  UnionSection section = UnionSection.overview;
  final message = TextEditingController();
  int likes = 14;

  void open(UnionSection value) => setState(() => section = value);

  void back() => open(UnionSection.overview);

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BrandGradientBackdrop.deep(
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: switch (section) {
        UnionSection.overview => UnionOverviewPage(onOpen: open),
        UnionSection.finances => UnionFinancesPage(
          onBack: back,
          onComingSoon: _comingSoon,
        ),
        UnionSection.dues => UnionDuesPage(
          onBack: back,
          onComingSoon: _comingSoon,
        ),
        UnionSection.facilities => UnionFacilitiesPage(
          onBack: back,
          onComingSoon: _comingSoon,
        ),
        UnionSection.visits => UnionVisitsPage(
          onBack: back,
          onComingSoon: _comingSoon,
        ),
        UnionSection.news => UnionNewsPage(
          onBack: back,
          onComingSoon: _comingSoon,
        ),
        UnionSection.community => UnionCommunityPage(
          onBack: back,
          message: message,
          likes: likes,
          onLike: () => setState(() => likes++),
          onSend: _sendMessage,
        ),
        UnionSection.initiative => UnionInitiativePage(
          onBack: back,
          likes: likes,
          onLike: () => setState(() => likes++),
          onComingSoon: _comingSoon,
        ),
      },
    ),
  );

  void _sendMessage() {
    if (message.text.trim().isEmpty) return;
    setState(() => message.clear());
    _comingSoon();
  }

  void _comingSoon() => _toast(AppLocaleKey.comingSoon.tr());

  void _toast(String value) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(value)));
}
