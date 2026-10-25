import 'package:flutter/widgets.dart';

import 'package:rounder_application/core/theme/app_theme.dart';

/// Layout constants of the resident home (Figma frame 108:44).
abstract final class HomeSpacing {
  static const double page = 20;
  static const double block = 12;
  static const double cardGap = 12;
  static const double cardPadding = 14;

  /// Gap between the dock icon and its label.
  static const double dockIconGap = 3;
}

abstract final class HomeRadii {
  static const double pill = 24;
  static const double card = 24;
  static const double dock = 28;
  static const double dockItem = 18;
  static const double button = 17;
  static const double chip = 12;
  static const double iconTile = 10;
}

abstract final class HomeSizes {
  /// The frame is 390 wide; wider screens keep the column centered.
  static const double maxContentWidth = 430;

  static const double topBarHeight = 32;
  static const double heroHeight = 186;
  static const double emergencyHeight = 48;
  static const double sectionHeadingHeight = 28;
  static const double unitSelectorHeight = 52;
  static const double summaryCardHeight = 232;
  static const double visitsHeadingHeight = 24;
  static const double visitCardHeight = 244;
  static const double cardButtonHeight = 44;
  static const double dockHeight = 70;
  static const double dockBottomInset = 20;
  static const double dockIconSize = 22;

  /// Bottom spacer of the scrolling home; the system inset is added on top so
  /// the last card always clears the floating dock.
  static const double pageBottomClearance = 104;
}

abstract final class HomeShadows {
  static const List<BoxShadow> selector = <BoxShadow>[
    BoxShadow(color: AppColors.shadowSoft, blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> dock = <BoxShadow>[
    BoxShadow(color: AppColors.shadowDock, blurRadius: 18, offset: Offset(0, 6)),
  ];
}
