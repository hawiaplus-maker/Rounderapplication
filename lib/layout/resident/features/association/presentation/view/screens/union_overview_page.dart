import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/model/union_section.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_header.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_panel.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_prototype_note.dart';

/// Association overview: balance, due amount, active initiative and entries.
class UnionOverviewPage extends StatelessWidget {
  const UnionOverviewPage({super.key, required this.onOpen});

  final ValueChanged<UnionSection> onOpen;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('union-overview'),
      padding: EdgeInsets.zero,
      children: [
        const UnionHeader(titleKey: AppLocaleKey.unionTitle),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppLocaleKey.unitTitle.tr(),
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        UnionPanel(
          glass: true,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                ),
                const Spacer(),
                Text(
                  AppLocaleKey.availableBalance.tr(),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '25,000 ${AppLocaleKey.currencySar.tr()}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Divider(color: Colors.white54),
            TextButton.icon(
              onPressed: () => onOpen(UnionSection.finances),
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              label: Text(
                AppLocaleKey.financialDetails.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => onOpen(UnionSection.dues),
          child: UnionPanel(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    color: AppColors.petrol,
                  ),
                  const Spacer(),
                  Text(
                    AppLocaleKey.dueAmount.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.petrol,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  FilledButton(
                    onPressed: () => onOpen(UnionSection.dues),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(AppLocaleKey.pay.tr()),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '300 ${AppLocaleKey.currencySar.tr()}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.petrol,
                        ),
                      ),
                      Text(
                        AppLocaleKey.dueDate.tr(),
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        UnionPanel(
          children: [
            Text(
              AppLocaleKey.workTogether.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              tileColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.meeting_room_outlined,
                color: AppColors.orange,
              ),
              title: Text(
                AppLocaleKey.improveEntrance.tr(),
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                AppLocaleKey.residentsJoined.tr(),
                textAlign: TextAlign.right,
              ),
              trailing: TextButton(
                onPressed: () => onOpen(UnionSection.initiative),
                child: Text(AppLocaleKey.shareIdea.tr()),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: .7,
                minHeight: 7,
                color: AppColors.petrol,
                backgroundColor: AppColors.mint,
              ),
            ),
          ],
        ),
        UnionPanel(
          children: [
            _NavRow(
              labelKey: AppLocaleKey.associationFinance,
              icon: Icons.pie_chart_outline,
              onTap: () => onOpen(UnionSection.finances),
            ),
            _NavRow(
              labelKey: AppLocaleKey.myDues,
              icon: Icons.receipt_long_outlined,
              onTap: () => onOpen(UnionSection.dues),
            ),
            _NavRow(
              labelKey: AppLocaleKey.facilitiesReports,
              icon: Icons.handyman_outlined,
              onTap: () => onOpen(UnionSection.facilities),
            ),
            _NavRow(
              labelKey: AppLocaleKey.unionVisits,
              icon: Icons.calendar_month_outlined,
              onTap: () => onOpen(UnionSection.visits),
            ),
            _NavRow(
              labelKey: AppLocaleKey.unionNews,
              icon: Icons.article_outlined,
              onTap: () => onOpen(UnionSection.news),
            ),
            _NavRow(
              labelKey: AppLocaleKey.associationCommunity,
              icon: Icons.groups_outlined,
              onTap: () => onOpen(UnionSection.community),
            ),
            _NavRow(
              labelKey: AppLocaleKey.initiatives,
              icon: Icons.lightbulb_outline,
              onTap: () => onOpen(UnionSection.initiative),
            ),
          ],
        ),
        const UnionPrototypeNote(
          padding: EdgeInsets.fromLTRB(22, 4, 22, 14),
        ),
      ],
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.labelKey,
    required this.icon,
    required this.onTap,
  });

  final String labelKey;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    tileColor: Colors.white,
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      backgroundColor: AppColors.mint,
      child: Icon(icon, color: AppColors.petrol),
    ),
    title: Text(
      labelKey.tr(),
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.petrol,
      ),
    ),
    trailing: const Icon(Icons.chevron_left),
    onTap: onTap,
  );
}
