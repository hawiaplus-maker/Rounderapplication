import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_glass_panel.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_svg_icon.dart';

/// Floating glass navigation dock of the resident shell.
///
/// The active entry keeps the coral glyph on a mint plate, the other entries
/// are drawn in petrol, exactly like the home frame.
class ResidentDock extends StatelessWidget {
  const ResidentDock({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const List<_DockEntry> _entries = <_DockEntry>[
    _DockEntry(icon: AppImages.homeNavHome, labelKey: AppLocaleKey.home),
    _DockEntry(icon: AppImages.homeNavServices, labelKey: AppLocaleKey.services),
    _DockEntry(icon: AppImages.homeNavOrders, labelKey: AppLocaleKey.orders),
    _DockEntry(icon: AppImages.homeNavUnion, labelKey: AppLocaleKey.unionTab),
    _DockEntry(icon: AppImages.homeNavUser, labelKey: AppLocaleKey.account),
  ];

  @override
  Widget build(BuildContext context) {
    return HomeGlassPanel(
      height: HomeSizes.dockHeight,
      radius: HomeRadii.dock,
      fill: AppColors.glassDockFill,
      stroke: AppColors.glassDockStroke,
      shadow: HomeShadows.dock,
      blurSigma: 20,
      padding: const EdgeInsets.all(7),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < _entries.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 2),
            Expanded(
              child: _DockItem(
                entry: _entries[i],
                isActive: selectedIndex == i,
                onTap: () => onSelected(i),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DockEntry {
  const _DockEntry({required this.icon, required this.labelKey});

  final String icon;
  final String labelKey;
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.entry,
    required this.isActive,
    required this.onTap,
  });

  final _DockEntry entry;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? AppColors.mintLight : Colors.transparent,
      borderRadius: BorderRadius.circular(HomeRadii.dockItem),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HomeSvgIcon(
              entry.icon,
              size: HomeSizes.dockIconSize,
              color: isActive ? AppColors.coral : AppColors.petrol,
            ),
            const SizedBox(height: HomeSpacing.dockIconGap),
            Text(
              entry.labelKey.tr(),
              style: isActive
                  ? HomeTextStyles.dockLabelActive
                  : HomeTextStyles.dockLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
