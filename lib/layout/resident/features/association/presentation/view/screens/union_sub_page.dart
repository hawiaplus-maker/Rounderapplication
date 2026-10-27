import 'package:flutter/material.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_header.dart';

/// Scrollable page shell used by the association sub-pages.
class UnionSubPage extends StatelessWidget {
  const UnionSubPage({
    super.key,
    required this.titleKey,
    required this.onBack,
    required this.children,
  });

  final String titleKey;
  final VoidCallback onBack;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: ValueKey(titleKey),
      padding: EdgeInsets.zero,
      children: [
        UnionHeader(titleKey: titleKey, onBack: onBack, showBack: true),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );
  }
}
