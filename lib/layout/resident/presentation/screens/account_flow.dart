import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/layout/resident/presentation/screens/resident_welcome_flow.dart';
import 'package:rounder_application/layout/resident/presentation/screens/link_home_screen.dart';
import 'package:rounder_application/layout/resident/presentation/widgets/phone_change_panel.dart';
import 'package:rounder_application/layout/resident/presentation/widgets/discard_profile_dialog.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Resident account screens from Figma. This prototype uses local state only
/// and deliberately does not call the API.
class AccountFlow extends StatefulWidget {
  const AccountFlow({super.key, this.residentName = '', this.homeName = ''});
  final String residentName;
  final String homeName;
  @override State<AccountFlow> createState() => _AccountFlowState();
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
    onPopInvokedWithResult: (didPop, result) { if(!didPop)goBack(); },
    child: Container(
    decoration: const BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      stops: [0, .25, .52, .72, 1],
      colors: [Color(0xFF073B43), Color(0xFF0F6570), Color(0xFFA8D4CF), Color(0xFFDDF3EE), Color(0xFFFFF9EF)],
    )),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: switch (page) {
        _Page.profile => _profile(),
        _Page.edit => _edit(),
        _Page.settings => _settings(),
        _Page.notifications => _notifications(),
        _Page.privacy => _privacy(),
        _Page.help => _help(),
        _Page.gifts => _gifts(),
        _Page.phone => _subPage(AppLocaleKey.changePhone, [PhoneChangePanel(onVerified: (value) {
          phoneController.text = value;
          open(_Page.edit);
        })]),
      },
    ),
    ),
  );

  Widget _header(String titleKey, {bool showBack = false}) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
    child: Row(children: [
      if (showBack)
        TextButton.icon(onPressed: goBack, icon: const Icon(Icons.chevron_left, color: Colors.white),
          label: Text(AppLocaleKey.back.tr(), style: const TextStyle(color: Colors.white)))
      else
        Text(titleKey.tr(), style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
      const Spacer(),
      Image.asset(AppImages.rounderLogo, height: 28, fit: BoxFit.contain),
    ]),
  );

  Widget _profile() => ListView(key: const ValueKey('account-profile'), padding: EdgeInsets.zero, children: [
    _header(AppLocaleKey.profile),
    Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
      child: Row(children: [
        CircleAvatar(radius: 42, backgroundColor: Colors.white24, child: Text(
          name.isEmpty ? AppLocaleKey.resident.tr().substring(0, 1) : name.substring(0, 1),
          style: const TextStyle(color: Colors.white, fontSize: 29, fontWeight: FontWeight.w700))),
        const SizedBox(width: 18),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(name.isEmpty ? AppLocaleKey.resident.tr() : name,
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
          Text(AppLocaleKey.profileSubtitle.tr(), style: const TextStyle(color: Colors.white70)),
          TextButton.icon(
            onPressed: () { nameController.text=name; phoneController.text=phone; emailController.text=email; open(_Page.edit); },
            icon: const Icon(Icons.edit_outlined, size: 17, color: Colors.white),
            label: Text(AppLocaleKey.editProfile.tr(), style: const TextStyle(color: Colors.white))),
        ])),
      ]),
    ),
    _panel([
      Row(children: [const Icon(Icons.apartment_rounded, color: AppColors.orange, size: 25), const Spacer(),
        Text(AppLocaleKey.units.tr(), style: const TextStyle(color: AppColors.petrol, fontSize: 19, fontWeight: FontWeight.w800))]),
      const SizedBox(height: 12),
      Text(AppLocaleKey.unitCount.tr(), style: const TextStyle(color: AppColors.petrol, fontSize: 27, fontWeight: FontWeight.w800)),
      Text(AppLocaleKey.linkedHomes.tr(), style: const TextStyle(color: AppColors.muted)),
      const Divider(height: 24),
      Row(children: [
        FilledButton(onPressed: () {
          final dashboard=context.read<ResidentDashboardCubit>();
          Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => BlocProvider.value(
            value:dashboard,child:Scaffold(appBar:AppBar(),body:const SafeArea(child:LinkHomeScreen())))));
        },
          style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white),
          child: Text(AppLocaleKey.manage.tr())),
        const Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(widget.homeName.isEmpty ? AppLocaleKey.unitTitle.tr() : widget.homeName, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.petrol)),
          Text(AppLocaleKey.currentUnit.tr() + ' • '+AppLocaleKey.flatNumber.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        ]),
      ]),
      const SizedBox(height: 6),
      Text(AppLocaleKey.linkedHomesNote.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 11)),
    ]),
    Padding(padding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
      child: InkWell(onTap: () => open(_Page.gifts), borderRadius: BorderRadius.circular(18),
        child: Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white24, border: Border.all(color: Colors.white70), borderRadius: BorderRadius.circular(18)),
          child: Row(children: [
            const Icon(Icons.chevron_left, color: AppColors.petrol),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(AppLocaleKey.gifts.tr(), style: const TextStyle(color: AppColors.petrol, fontWeight: FontWeight.w800)),
              Text(AppLocaleKey.discoverGifts.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            ])),
            const SizedBox(width: 10), const Icon(Icons.card_giftcard_outlined, color: AppColors.petrol, size: 27),
          ]),
        ),
      ),
    ),
    Padding(padding: const EdgeInsets.fromLTRB(22, 12, 22, 5),
      child: Text(AppLocaleKey.accountDetails.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted, fontSize: 13))),
    Padding(padding: const EdgeInsets.fromLTRB(22, 0, 22, 24), child: _panel([
      Row(children: [
        Expanded(child: _menu(AppLocaleKey.settings, Icons.tune, _Page.settings)),
        const SizedBox(width: 8),
        Expanded(child: _menu(AppLocaleKey.notifications, Icons.notifications_none, _Page.notifications)),
      ]),
      const Divider(height: 20),
      Row(children: [
        Expanded(child: _menu(AppLocaleKey.privacy, Icons.verified_user_outlined, _Page.privacy)),
        const SizedBox(width: 8),
        Expanded(child: _menu(AppLocaleKey.help, Icons.headset_mic_outlined, _Page.help)),
      ]),
    ])),
  ]);

  Widget _menu(String key, IconData icon, _Page target) => InkWell(onTap: () => open(target),
    borderRadius: BorderRadius.circular(14),
    child: Padding(padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
      child: Row(children: [
        Icon(icon, color: AppColors.petrol, size: 21), const SizedBox(width: 7),
        Expanded(child: Text(key.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.petrol, fontSize: 13, fontWeight: FontWeight.w600))),
        const Icon(Icons.chevron_left, color: AppColors.muted, size: 17),
      ])));

  Widget _edit() => _subPage(AppLocaleKey.editProfile, [
    const SizedBox(height: 12),
    Center(child: Column(children: [
      const CircleAvatar(radius: 39, backgroundColor: AppColors.mint, child: Icon(Icons.person_outline, color: AppColors.petrol, size: 36)),
      TextButton.icon(onPressed: () => _toast(AppLocaleKey.comingSoon.tr()),
        icon: const Icon(Icons.photo_camera_outlined), label: Text(AppLocaleKey.changePhoto.tr())),
    ])),
    _panel([
      _input(AppLocaleKey.fullName, nameController, keyboard: TextInputType.name),
      const SizedBox(height: 14),
      ListTile(contentPadding: EdgeInsets.zero,
        title: Text(AppLocaleKey.phoneNumber.tr()),
        subtitle: Text(phoneController.text, textDirection: TextDirection.ltr),
        trailing: TextButton(onPressed: () => open(_Page.phone), child: Text(AppLocaleKey.changePhone.tr()))),
      const SizedBox(height: 14),
      _input(AppLocaleKey.emailAddress, emailController, keyboard: TextInputType.emailAddress),
      const SizedBox(height: 4),
      Text(AppLocaleKey.optional.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
    ]),
    const SizedBox(height: 10),
    SizedBox(width: double.infinity, child: FilledButton(
      style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.all(15)),
      onPressed: () {
        if (nameController.text.trim().length < 2) { _toast(AppLocaleKey.requiredField.tr()); return; }
        final candidateEmail = emailController.text.trim();
        if (candidateEmail.isNotEmpty &&
            (candidateEmail.length > 254 || !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(candidateEmail))) {
          _toast(AppLocaleKey.emailInvalid.tr()); return;
        }
        setState(() { name=nameController.text.trim(); phone=phoneController.text.trim(); email=emailController.text.trim(); page=_Page.profile; });
        _toast(AppLocaleKey.profileSaved.tr());
      },
      child: Text(AppLocaleKey.saveChanges.tr()))),
    const SizedBox(height: 16),
    Center(child: Text(AppLocaleKey.contactUse.tr(), style: const TextStyle(color: AppColors.petrol, fontSize: 12))),
  ]);

  Widget _settings() => _subPage(AppLocaleKey.settingsTitle, [
    _panel([
      Text(AppLocaleKey.aliHelps.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.petrol, fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      Text(AppLocaleKey.changeAnytime.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted)),
      SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(AppLocaleKey.requestUpdates.tr()),
        subtitle: Text(orderUpdates ? AppLocaleKey.on.tr() : AppLocaleKey.off.tr()), value: orderUpdates,
        activeThumbColor: AppColors.orange, onChanged: (v) => setState(() => orderUpdates=v)),
      SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(AppLocaleKey.offersAndGifts.tr()),
        subtitle: Text(offers ? AppLocaleKey.on.tr() : AppLocaleKey.off.tr()), value: offers,
        activeThumbColor: AppColors.orange, onChanged: (v) => setState(() => offers=v)),
    ]),
    _panel([
      _action(AppLocaleKey.editProfile, Icons.edit_outlined, () => open(_Page.edit)),
      const SizedBox(height: 9),
      _action(AppLocaleKey.privacy, Icons.shield_outlined, () => open(_Page.privacy)),
    ]),
  ]);

  Widget _notifications() => _subPage(AppLocaleKey.notifications, [
    Row(children: [
      TextButton(onPressed: () => setState(() => read=true), child: Text(AppLocaleKey.readAll.tr())),
      const Spacer(), Text(AppLocaleKey.actionRequired.tr() + ': 2', style: const TextStyle(color: Colors.white, fontSize: 12)),
    ]),
    Wrap(spacing: 8, children: [
      _filter(0, AppLocaleKey.allNotifications), _filter(1, AppLocaleKey.actionRequired), _filter(2, AppLocaleKey.unread),
    ]),
    const SizedBox(height: 10),
    if (filter == 0 || filter == 1) _notification(AppLocaleKey.notificationOfferTitle, AppLocaleKey.notificationOfferBody, Icons.request_quote_outlined),
    if (filter == 0 || (filter == 2 && !read)) _notification(AppLocaleKey.notificationReportTitle, AppLocaleKey.notificationReportBody, Icons.fact_check_outlined),
    if (filter == 2 && read) _panel([Text(AppLocaleKey.emptyNotifications.tr(), textAlign: TextAlign.center)]),
  ]);

  Widget _filter(int value, String label) => ChoiceChip(
    label: Text(label.tr()), selected: filter == value, selectedColor: Colors.white,
    backgroundColor: Colors.white70, onSelected: (_) => setState(() => filter=value));

  Widget _notification(String title, String body, IconData icon) => _panel([
    Row(children: [Icon(icon, color: AppColors.orange), const Spacer(),
      Text(read ? AppLocaleKey.notifications.tr() : AppLocaleKey.unread.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 11))]),
    const SizedBox(height: 8),
    Text(title.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.petrol, fontSize: 17, fontWeight: FontWeight.w800)),
    const SizedBox(height: 8), Text(body.tr(), textAlign: TextAlign.right, style: const TextStyle(height: 1.6)),
    Align(alignment: Alignment.centerLeft, child: TextButton(
      onPressed: () => _toast(AppLocaleKey.comingSoon.tr()),
      child: Text(AppLocaleKey.reviewNow.tr(), style: const TextStyle(color: AppColors.orange)))),
  ]);

  Widget _privacy() => _subPage(AppLocaleKey.privacy, [
    _panel([
      Text(AppLocaleKey.privacyData.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.petrol, fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(AppLocaleKey.serviceAddress.tr()),
        subtitle: Text(AppLocaleKey.privacyAddressBody.tr()), value: addressUse, activeThumbColor: AppColors.orange,
        onChanged: (v) => setState(() => addressUse=v)),
      SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(AppLocaleKey.requestContact.tr()),
        subtitle: Text(AppLocaleKey.privacyContactBody.tr()), value: requestContact, activeThumbColor: AppColors.orange,
        onChanged: (v) => setState(() => requestContact=v)),
      Text(AppLocaleKey.optionalOffers.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
    ]),
    _panel([
      _action(AppLocaleKey.communicationPrefs, Icons.tune, () => open(_Page.settings)),
      const SizedBox(height: 9),
      _action(AppLocaleKey.reviewData, Icons.person_outline, () => open(_Page.edit)),
    ]),
  ]);

  Widget _help() => _subPage(AppLocaleKey.help, [
    _panel([
      Text(AppLocaleKey.faqTitle.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.petrol, fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      _action(AppLocaleKey.contactUs, Icons.support_agent, () => _toast(AppLocaleKey.comingSoon.tr())),
    ]),
    _panel([
      _faq(AppLocaleKey.faqHome, AppLocaleKey.faqHomeAnswer),
      _faq(AppLocaleKey.faqPayment, AppLocaleKey.faqPaymentAnswer),
      _faq(AppLocaleKey.faqGift, AppLocaleKey.faqGiftAnswer),
      Text(AppLocaleKey.faqHint.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
    ]),
  ]);

  Widget _faq(String question, String answer) => ExpansionTile(
    tilePadding: EdgeInsets.zero,
    title: Text(question.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.petrol, fontWeight: FontWeight.w700)),
    children: [Padding(padding: const EdgeInsets.only(bottom: 12),
      child: Text(answer.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted, height: 1.5)))],
  );

  Widget _gifts() => _subPage(AppLocaleKey.gifts, [
    _panel([
      const Icon(Icons.card_giftcard_rounded, size: 44, color: AppColors.orange),
      const SizedBox(height: 12),
      Text(AppLocaleKey.chooseWelcomeGiftTitle.tr(), textAlign: TextAlign.right,
        style: const TextStyle(color: AppColors.petrol, fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      Text(AppLocaleKey.chooseWelcomeGiftBody.tr(), textAlign: TextAlign.right,
        style: const TextStyle(color: AppColors.muted, height: 1.6)),
      const SizedBox(height: 14),
      FilledButton.icon(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => const ResidentWelcomeFlow(startAtGifts: true))),
        icon: const Icon(Icons.redeem_outlined),
        label: Text(AppLocaleKey.discoverGifts.tr()),
        style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white),
      ),
    ]),
    ...[
      (AppLocaleKey.giftHomeCare, AppLocaleKey.giftHomeCareDesc, Icons.home_repair_service_outlined),
      (AppLocaleKey.giftServiceCredit, AppLocaleKey.giftCreditDesc, Icons.account_balance_wallet_outlined),
      (AppLocaleKey.giftCleaning, AppLocaleKey.giftCleaningDesc, Icons.cleaning_services_outlined),
    ].map((gift) => _panel([
      Row(children: [Icon(gift.$3, color: AppColors.orange), const SizedBox(width: 10),
        Expanded(child: Text(gift.$1.tr(), textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.petrol, fontWeight: FontWeight.w800)))]),
      const SizedBox(height: 6),
      Text(gift.$2.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted)),
    ])),
  ]);

  Widget _subPage(String key, List<Widget> children) => ListView(
    key: ValueKey(key), padding: EdgeInsets.zero,
    children: [
      _header(key, showBack: true),
      Padding(padding: const EdgeInsets.fromLTRB(20, 6, 20, 22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)),
    ],
  );

  Widget _panel(List<Widget> children) => Container(
    margin: const EdgeInsets.fromLTRB(20, 8, 20, 8), padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .93), borderRadius: BorderRadius.circular(22)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
  );

  Widget _action(String key, IconData icon, VoidCallback callback) => FilledButton.tonalIcon(
    onPressed: callback, icon: Icon(icon, size: 19), label: Text(key.tr()),
    style: FilledButton.styleFrom(backgroundColor: AppColors.mint, foregroundColor: AppColors.petrol,
      alignment: Alignment.centerRight, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
  );

  Widget _input(String key, TextEditingController controller, {TextInputType? keyboard}) => TextField(
    controller: controller, keyboardType: keyboard, textAlign: TextAlign.right,
    decoration: InputDecoration(labelText: key.tr(), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      filled: true, fillColor: AppColors.mint.withValues(alpha: .45)),
  );

  void _toast(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
