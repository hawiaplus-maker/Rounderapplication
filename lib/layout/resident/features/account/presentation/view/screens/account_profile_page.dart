import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/global/widgets/state_panel.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/profile_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_header.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_logout_button.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/profile_entry_card.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/profile_identity_section.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/profile_menu_section.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/profile_units_section.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/cubit/homes_cubit.dart';

/// Account profile page: identity, linked units, gifts and account entries.
/// The identity comes from the profile endpoint; the units card reads the
/// linked homes with the shell's dashboard residence as its fallback.
class AccountProfilePage extends StatelessWidget {
  const AccountProfilePage({
    super.key,
    required this.homeName,
    required this.unitLabel,
    required this.onEdit,
    required this.onGifts,
    required this.onUnits,
    required this.onSettings,
    required this.onNotifications,
    required this.onPrivacy,
    required this.onHelp,
    required this.onLogout,
  });

  final String homeName, unitLabel;
  final VoidCallback onEdit;
  final VoidCallback onGifts;
  final VoidCallback onUnits;
  final VoidCallback onSettings;
  final VoidCallback onNotifications;
  final VoidCallback onPrivacy;
  final VoidCallback onHelp;

  /// Ends the session: the flow confirms, calls the logout API and clears the
  /// stored token; the boot gate then reveals the login screen.
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('account-profile'),
      padding: EdgeInsets.zero,
      children: [
        const AccountHeader(titleKey: AppLocaleKey.profile),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) => switch (state) {
            ProfileLoading() => const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: StatePanel(message: '', loading: true),
            ),
            ProfileFailure(:final String message) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: StatePanel(
                message: message,
                onRetry: () => context.read<ProfileCubit>().load(),
              ),
            ),
            ProfileReady(:final profile) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileIdentitySection(profile: profile, onEdit: onEdit),
                BlocBuilder<HomesCubit, HomesState>(
                  builder: (context, homesState) {
                    final HomesReady? ready = homesState is HomesReady ? homesState : null;
                    final ResidentHome? primary = ready?.primary;
                    return ProfileUnitsSection(
                      count: ready != null && ready.homes.isNotEmpty
                          ? ready.homes.length
                          : (homeName.trim().isEmpty ? 0 : 1),
                      homeName: primary?.name ?? homeName,
                      unitLabel: primary?.unitLabel ?? unitLabel,
                      onManage: onUnits,
                    );
                  },
                ),
                ProfileEntryCard(
                  titleKey: AppLocaleKey.gifts,
                  subtitleKey: AppLocaleKey.discoverGifts,
                  icon: Icons.card_giftcard_outlined,
                  onTap: onGifts,
                ),
                ProfileMenuSection(
                  onSettings: onSettings,
                  onNotifications: onNotifications,
                  onPrivacy: onPrivacy,
                  onHelp: onHelp,
                ),
              ],
            ),
          },
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(22, 0, 22, 28),
          child: AccountLogoutButton(onPressed: onLogout),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}
