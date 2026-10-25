import 'package:flutter/material.dart';

import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/model/home_view_models.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_last_visit_card.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_next_service_card.dart';

/// The two visit cards side by side, matching the frame's order (last visit on
/// the end side, upcoming service on the start side).
class HomeVisitCards extends StatelessWidget {
  const HomeVisitCards({
    super.key,
    required this.lastVisit,
    required this.nextService,
    this.onDetails,
  });

  final HomeVisit lastVisit;
  final HomeNextService nextService;
  final VoidCallback? onDetails;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeSizes.visitCardHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: HomeNextServiceCard(service: nextService)),
          const SizedBox(width: HomeSpacing.cardGap),
          Expanded(
            child: HomeLastVisitCard(visit: lastVisit, onDetails: onDetails),
          ),
        ],
      ),
    );
  }
}
