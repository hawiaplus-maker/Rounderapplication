import 'package:flutter/material.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_header.dart';

/// Scrollable page shell used by the service journey sub-pages.
class JourneySubPage extends StatelessWidget {
  const JourneySubPage({
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
        JourneyHeader(titleKey: titleKey, onBack: onBack),
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
