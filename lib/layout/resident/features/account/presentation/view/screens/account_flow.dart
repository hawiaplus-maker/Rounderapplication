import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rounder_application/layout/global/widgets/brand_gradient_backdrop.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/resident_profile_model.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/support_ticket_model.dart';
import 'package:rounder_application/layout/resident/features/account/data/repo/profile_repo.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/notifications_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/profile_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/support_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_contact_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_contact_success_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_edit_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_gifts_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_help_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_notifications_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_privacy_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_profile_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_settings_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/legal_document_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/legal_document_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_sub_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/discard_profile_dialog.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/phone_change_panel.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/sign_out_dialog.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/screens/resident_welcome_flow.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/cubit/homes_cubit.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/screens/units_screen.dart';
import 'package:rounder_application/logic/contact_ticket_logic.dart';
import 'package:rounder_application/logic/email_logic.dart';

/// Resident account screens. The identity comes from the profile endpoint and
/// the notifications from their feed; the remaining preference toggles stay
/// local because the backend exposes no endpoint for them yet.
class AccountFlow extends StatefulWidget {
  const AccountFlow({
    super.key,
    this.homeName = '',
    this.unitLabel = '',
    this.active = true,
    required this.onRootBack,
  });

  final String homeName, unitLabel;

  /// Whether this tab owns the back gesture. The home shell keeps every tab
  /// alive in an [IndexedStack], so a hidden account flow must not claim the
  /// back press of the visible tab.
  final bool active;

  /// Called when back is pressed on the account profile: the shell switches to
  /// the home tab instead of closing the app.
  final VoidCallback onRootBack;

  @override
  State<AccountFlow> createState() => _AccountFlowState();
}

enum _Page {
  profile,
  edit,
  settings,
  notifications,
  privacy,
  help,
  contact,
  contactSuccess,
  gifts,
  phone,
}

class _AccountFlowState extends State<AccountFlow> {
  _Page page = _Page.profile;
  bool orderUpdates = true, offers = false, addressUse = true;
  bool requestContact = true;
  bool _signingOut = false;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  /// The contact form is validated locally and submitted to the support
  /// endpoint; the success page shows the reference the backend assigns.
  String _contactReference = '';
  DateTime? _contactSubmittedAt;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  final ProfileCubit _profileCubit = sl<ProfileCubit>()..load();

  /// Shared instance loaded once: calling `load()` from `build` would refetch
  /// on every rebuild (including each locale change).
  final NotificationsCubit _notificationsCubit = sl<NotificationsCubit>()
    ..load();

  /// Loaded lazily by the contact page, reused on every visit.
  final SupportCubit _supportCubit = sl<SupportCubit>();

  void open(_Page value) => setState(() => page = value);

  ResidentProfile _profile() {
    final ProfileState state = _profileCubit.state;
    return state is ProfileReady ? state.profile : const ResidentProfile();
  }

  bool _dirty() {
    final ResidentProfile profile = _profile();
    return nameController.text.trim() != profile.name ||
        emailController.text.trim() != profile.email;
  }

  void _fillControllers(ResidentProfile profile) {
    nameController.text = profile.name;
    phoneController.text = profile.phone;
    emailController.text = profile.email;
  }

  Future<void> goBack() async {
    if (page == _Page.phone) {
      open(_Page.edit);
      return;
    }
    if (page == _Page.contact || page == _Page.contactSuccess) {
      open(_Page.help);
      return;
    }
    if (page == _Page.edit && _dirty()) {
      if (!await confirmDiscardProfile(context) || !mounted) return;
      _fillControllers(_profile());
    }
    if (mounted) open(_Page.profile);
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<ProfileCubit>.value(value: _profileCubit),
      BlocProvider<NotificationsCubit>.value(value: _notificationsCubit),
      BlocProvider<SupportCubit>.value(value: _supportCubit),
      BlocProvider(create: (_) => sl<HomesCubit>()..load()),
    ],
    child: PopScope(
      canPop: !widget.active,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || !widget.active) return;
        if (page == _Page.profile) {
          widget.onRootBack();
          return;
        }
        goBack();
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 80,
        ),
        child: BrandGradientBackdrop.deep(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: switch (page) {
              _Page.profile => AccountProfilePage(
                homeName: widget.homeName,
                unitLabel: widget.unitLabel,
                onEdit: _editProfile,
                onGifts: () => open(_Page.gifts),
                onUnits: _openUnits,
                onSettings: () => open(_Page.settings),
                onNotifications: () => open(_Page.notifications),
                onPrivacy: () => _openLegal('privacy'),
                onHelp: () => open(_Page.help),
                onLogout: _signOut,
              ),
              _Page.edit => BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) => AccountEditPage(
                  onBack: goBack,
                  nameController: nameController,
                  phoneController: phoneController,
                  emailController: emailController,
                  saving: state is ProfileReady && state.saving,
                  error: state is ProfileReady ? state.error : '',
                  onChangePhoto: _comingSoon,
                  onChangePhone: () => open(_Page.phone),
                  onSave: _saveProfile,
                ),
              ),
              _Page.settings => AccountSettingsPage(
                onBack: goBack,
                orderUpdates: orderUpdates,
                offers: offers,
                onOrderUpdatesChanged: (value) =>
                    setState(() => orderUpdates = value),
                onOffersChanged: (value) => setState(() => offers = value),
                onEditProfile: () => open(_Page.edit),
                onPrivacy: () => _openLegal('privacy'),
                onTerms: () => _openLegal('terms'),
                onLogout: _signOut,
                onLanguage: _changeLanguage,
              ),
              _Page.notifications => AccountNotificationsPage(
                onBack: goBack,
                onPreferences: () => open(_Page.settings),
              ),
              _Page.privacy => AccountPrivacyPage(
                onBack: goBack,
                addressUse: addressUse,
                requestContact: requestContact,
                onAddressUseChanged: (value) =>
                    setState(() => addressUse = value),
                onRequestContactChanged: (value) =>
                    setState(() => requestContact = value),
                onCommunicationPrefs: () => open(_Page.settings),
                onReviewData: () => open(_Page.edit),
              ),
              _Page.help => AccountHelpPage(
                onBack: goBack,
                onContactUs: () => open(_Page.contact),
              ),
              _Page.contact => AccountContactPage(
                onBack: goBack,
                onSubmitted: _submitContact,
              ),
              _Page.contactSuccess => AccountContactSuccessPage(
                onBack: goBack,
                reference: _contactReference,
                submittedAt: _contactSubmittedAt ?? DateTime.now(),
                onBackToHelp: () => open(_Page.help),
                onSendAnother: () => open(_Page.contact),
              ),
              _Page.gifts => AccountGiftsPage(
                onBack: goBack,
                onDiscoverGifts: _openWelcomeFlow,
              ),
              _Page.phone => AccountSubPage(
                titleKey: AppLocaleKey.changePhone,
                onBack: goBack,
                children: [
                  PhoneChangePanel(
                    onVerified: (value) {
                      phoneController.text = value;
                      open(_Page.edit);
                    },
                  ),
                ],
              ),
            },
          ),
        ),
      ),
    ),
  );

  void _editProfile() {
    _fillControllers(_profile());
    open(_Page.edit);
  }

  /// The support endpoint accepted the ticket: the success page shows its
  /// reference and reception time (the local reference is only a fallback for
  /// a response without a reference).
  void _submitContact(SupportTicket ticket) {
    final DateTime submittedAt = ticket.createdAt ?? DateTime.now();
    setState(() {
      _contactSubmittedAt = submittedAt;
      _contactReference = ticket.reference.isNotEmpty
          ? ticket.reference
          : contactTicketReference(submittedAt);
      page = _Page.contactSuccess;
    });
  }

  /// Saves through the profile endpoint; the server's message is surfaced by
  /// the network layer, and a rejected save keeps this page open with its text.
  Future<void> _saveProfile() async {
    final String name = nameController.text.trim();
    if (name.length < 2) {
      _toast(AppLocaleKey.requiredField.tr());
      return;
    }
    final String email = emailController.text.trim();
    if (email.isNotEmpty && !isEmail(email)) {
      _toast(AppLocaleKey.emailInvalid.tr());
      return;
    }
    final bool saved = await _profileCubit.save(
      name: name,
      email: email,
      locale: context.locale.languageCode,
    );
    if (!mounted || !saved) return;
    open(_Page.profile);
  }

  Future<void> _openUnits() async {
    final dashboard = context.read<ResidentDashboardCubit>();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UnitsScreen(
          dashboard: dashboard,
          homeName: widget.homeName,
          unitLabel: widget.unitLabel,
        ),
      ),
    );
  }

  void _openLegal(String slug) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => sl<LegalDocumentCubit>(),
          child: LegalDocumentPage(slug: slug),
        ),
      ),
    );
  }

  void _openWelcomeFlow() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ResidentWelcomeFlow(startAtGifts: true),
      ),
    );
  }

  void _comingSoon() => _toast(AppLocaleKey.comingSoon.tr());

  /// Sign out is the only other account action that talks to the API: confirm,
  /// POST `/auth/logout` and clear the cached token (the repository already
  /// falls back to the local clear when offline), then let the boot gate
  /// swap to the login screen. Popping to the root covers the preview home
  /// opened on top of the gate.
  Future<void> _changeLanguage() async {
    final selected = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(AppLocaleKey.arabic.tr()),
              onTap: () => Navigator.pop(sheetContext, const Locale('ar')),
            ),
            ListTile(
              title: Text(AppLocaleKey.english.tr()),
              onTap: () => Navigator.pop(sheetContext, const Locale('en')),
            ),
            ListTile(
              title: Text(AppLocaleKey.urdu.tr()),
              onTap: () => Navigator.pop(sheetContext, const Locale('ur')),
            ),
          ],
        ),
      ),
    );
    if (selected != null && mounted) {
      await context.setLocale(selected);
      if (!mounted) return;
      // Tell the backend the new language first: other endpoints (services,
      // bookings, ...) answer in the user's stored locale, so the profile must
      // be updated before the data is refetched.
      try {
        await sl<ProfileRepository>().setLocale(selected.languageCode);
      } catch (_) {}
      if (!mounted) return;
      // Then apply it to `Intl` and refetch every locale-aware cubit so no
      // screen keeps data in the old language.
      notifyLocaleChanged(selected);
    }
  }

  Future<void> _signOut() async {
    if (_signingOut) return;
    if (!await confirmSignOut(context) || !mounted) return;
    setState(() => _signingOut = true);
    await context.read<AuthCubit>().signOut();
    if (!mounted) return;
    setState(() => _signingOut = false);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
