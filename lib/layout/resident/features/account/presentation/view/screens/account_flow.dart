import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_edit_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_gifts_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_help_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_notifications_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_privacy_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_profile_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_settings_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_sub_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/discard_profile_dialog.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/phone_change_panel.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/screen/resident_welcome_flow.dart';
import 'package:rounder_application/layout/resident/features/properties/presentation/view/screen/link_home_screen.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/screen/units_screen.dart';

/// Resident account screens from Figma. This prototype uses local state only
/// and deliberately does not call the API.
class AccountFlow extends StatefulWidget {
  const AccountFlow({super.key, this.residentName = '', this.homeName = ''});

  final String residentName;
  final String homeName;

  @override
  State<AccountFlow> createState() => _AccountFlowState();
}

enum _Page { profile, edit, settings, notifications, privacy, help, gifts, phone }

class _AccountFlowState extends State<AccountFlow> {
  _Page page = _Page.profile;
  String name = '';
  String phone = '+966 5X XXX XXXX';
  String email = '';
  bool orderUpdates = true, offers = false, addressUse = true, requestContact = true, read = false;
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

  bool get _dirty => nameController.text.trim() != name ||
    emailController.text.trim() != email || phoneController.text.trim() != phone;

  Future<void> goBack() async {
    if (page == _Page.phone) { open(_Page.edit); return; }
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
    onPopInvokedWithResult: (didPop, result) { if (!didPop) goBack(); },
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, .25, .52, .72, 1],
          colors: [
            Color(0xFF073B43),
            Color(0xFF0F6570),
            Color(0xFFA8D4CF),
            Color(0xFFDDF3EE),
            Color(0xFFFFF9EF),
          ],
        ),
      ),
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
            onOrderUpdatesChanged: (value) => setState(() => orderUpdates = value),
            onOffersChanged: (value) => setState(() => offers = value),
            onEditProfile: () => open(_Page.edit),
            onPrivacy: () => open(_Page.privacy),
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
            onRequestContactChanged: (value) => setState(() => requestContact = value),
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
    if (candidateEmail.isNotEmpty &&
        (candidateEmail.length > 254 ||
            !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(candidateEmail))) {
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
          child: Scaffold(appBar: AppBar(), body: const SafeArea(child: LinkHomeScreen())),
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

  void _toast(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
