import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/global/widgets/brand_gradient_backdrop.dart';
import 'package:rounder_application/logic/email_logic.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_edit_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_gifts_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_help_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_notifications_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_privacy_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_profile_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_settings_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_sub_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/discard_profile_dialog.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/phone_change_panel.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/sign_out_dialog.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/screens/resident_welcome_flow.dart';
import 'package:rounder_application/layout/resident/features/properties/presentation/view/screens/link_home_screen.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/screens/units_screen.dart';

/// Resident account screens from Figma. This prototype uses local state only
/// and deliberately does not call the API.
class AccountFlow extends StatefulWidget {
  const AccountFlow({super.key, this.residentName = '', this.homeName = ''});

  final String residentName;
  final String homeName;

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
  gifts,
  phone,
}

class _AccountFlowState extends State<AccountFlow> {
  _Page page = _Page.profile;
  String name = '';
  String phone = '+966 5X XXX XXXX';
  String email = '';
  bool orderUpdates = true,
      offers = false,
      addressUse = true,
      requestContact = true,
      read = false;
  bool _signingOut = false;
  int filter = 0;
  final nameController = TextEditingController();
  final phoneController = TextEditingController(text: '+966 5X XXX XXXX');
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = widget.residentName;
    nameController.text = name;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void open(_Page value) => setState(() => page = value);

  bool get _dirty =>
      nameController.text.trim() != name ||
      emailController.text.trim() != email ||
      phoneController.text.trim() != phone;

  Future<void> goBack() async {
    if (page == _Page.phone) {
      open(_Page.edit);
      return;
    }
    if (page == _Page.edit && _dirty) {
      if (!await confirmDiscardProfile(context) || !mounted) return;
      nameController.text = name;
      emailController.text = email;
      phoneController.text = phone;
    }
    if (mounted) open(_Page.profile);
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: page == _Page.profile,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) goBack();
    },
    child: BrandGradientBackdrop.deep(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: switch (page) {
          _Page.profile => AccountProfilePage(
            name: name,
            homeName: widget.homeName,
            onEdit: _editProfile,
            onGifts: () => open(_Page.gifts),
            onUnits: _openUnits,
            onManageHomes: _openLinkHome,
            onSettings: () => open(_Page.settings),
            onNotifications: () => open(_Page.notifications),
            onPrivacy: () => open(_Page.privacy),
            onHelp: () => open(_Page.help),
            onLogout: _signOut,
          ),
          _Page.edit => AccountEditPage(
            onBack: goBack,
            nameController: nameController,
            phoneController: phoneController,
            emailController: emailController,
            onChangePhoto: _comingSoon,
            onChangePhone: () => open(_Page.phone),
            onSave: _saveProfile,
          ),
          _Page.settings => AccountSettingsPage(
            onBack: goBack,
            orderUpdates: orderUpdates,
            offers: offers,
            onOrderUpdatesChanged: (value) =>
                setState(() => orderUpdates = value),
            onOffersChanged: (value) => setState(() => offers = value),
            onEditProfile: () => open(_Page.edit),
            onPrivacy: () => open(_Page.privacy),
            onLogout: _signOut,
          ),
          _Page.notifications => AccountNotificationsPage(
            onBack: goBack,
            filter: filter,
            onFilterChanged: (value) => setState(() => filter = value),
            read: read,
            onReadAll: () => setState(() => read = true),
            onReviewNow: _comingSoon,
          ),
          _Page.privacy => AccountPrivacyPage(
            onBack: goBack,
            addressUse: addressUse,
            requestContact: requestContact,
            onAddressUseChanged: (value) => setState(() => addressUse = value),
            onRequestContactChanged: (value) =>
                setState(() => requestContact = value),
            onCommunicationPrefs: () => open(_Page.settings),
            onReviewData: () => open(_Page.edit),
          ),
          _Page.help => AccountHelpPage(
            onBack: goBack,
            onContactUs: _comingSoon,
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
  );

  void _editProfile() {
    nameController.text = name;
    phoneController.text = phone;
    emailController.text = email;
    open(_Page.edit);
  }

  void _saveProfile() {
    if (nameController.text.trim().length < 2) {
      _toast(AppLocaleKey.requiredField.tr());
      return;
    }
    final candidateEmail = emailController.text.trim();
    if (candidateEmail.isNotEmpty && !isEmail(candidateEmail)) {
      _toast(AppLocaleKey.emailInvalid.tr());
      return;
    }
    setState(() {
      name = nameController.text.trim();
      phone = phoneController.text.trim();
      email = emailController.text.trim();
      page = _Page.profile;
    });
    _toast(AppLocaleKey.profileSaved.tr());
  }

  void _openUnits() {
    final dashboard = context.read<ResidentDashboardCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UnitsScreen(
          hasUnits: widget.homeName.isNotEmpty,
          dashboard: dashboard,
        ),
      ),
    );
  }

  void _openLinkHome() {
    final dashboard = context.read<ResidentDashboardCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: dashboard,
          child: Scaffold(
            appBar: AppBar(),
            body: const SafeArea(child: LinkHomeScreen()),
          ),
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

  /// Sign out is the only account action that talks to the API: confirm,
  /// POST `/auth/logout` and clear the cached token (the repository already
  /// falls back to the local clear when offline), then let the boot gate
  /// swap to the login screen. Popping to the root covers the preview home
  /// opened on top of the gate.
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
