import 'package:flutter/material.dart';

import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/ali_hero_figure.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/hero_greeting.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/talk_to_ali_button.dart';

/// Hero block: 186 px canvas with Ali on the end side, the greeting on the
/// start side and the voice pill pinned to the bottom start corner.
class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({
    super.key,
    required this.residentName,
    this.onTalk,
  });

  final String residentName;
  final VoidCallback? onTalk;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeSizes.heroHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          const PositionedDirectional(
            end: 0,
            bottom: 0,
            child: AliHeroFigure(),
          ),
          PositionedDirectional(
            start: 0,
            top: 10,
            width: 166,
            child: HeroGreeting(residentName: residentName),
          ),
          PositionedDirectional(
            start: 0,
            bottom: 17,
            child: TalkToAliButton(onTap: onTalk),
          ),
        ],
      ),
    );
  }
}
