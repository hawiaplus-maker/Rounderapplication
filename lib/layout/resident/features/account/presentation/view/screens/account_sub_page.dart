import 'package:flutter/material.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_header.dart';

/// Scrollable page shell used by the account sub-pages.
class AccountSubPage extends StatelessWidget {
  const AccountSubPage({
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
        AccountHeader(titleKey: titleKey, onBack: onBack, showBack: true),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );
  }
}
