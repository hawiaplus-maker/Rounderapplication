import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'resident_welcome_flow.dart';
import 'link_home_screen.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_locale_key.dart';
import '../../../../core/theme/app_theme.dart';

/// Resident account screens from Figma. This prototype uses local state only
/// and deliberately does not call the API.
class AccountFlow extends StatefulWidget {
  const AccountFlow({super.key});
  @override State<AccountFlow> createState() => _AccountFlowState();
}

enum _Page { profile, edit, settings, notifications, privacy, help, gifts, units, phoneInput, phoneOtp }

class _AccountFlowState extends State<AccountFlow> {
  _Page page = _Page.profile;
  String name = '';
  String phone = '+966 5X XXX XXXX';
  String email = '';
  bool orderUpdates = true, offers = false, addressUse = true, requestContact = true, read = false;
  IconData avatarIcon = Icons.person_outline_rounded;
  final newPhoneController = TextEditingController();
  final otpController = TextEditingController();
  int filter = 0;
  final nameController = TextEditingController();
  final phoneController = TextEditingController(text: '+966 5X XXX XXXX');
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    newPhoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void open(_Page value) => setState(() => page = value);
  void goBack() => open(_Page.profile);

  @override
  Widget build(BuildContext context) => Container(
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
        _Page.units => _units(),
        _Page.phoneInput => _phoneInput(),
        _Page.phoneOtp => _phoneOtp(),
      },
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
        FilledButton(onPressed: () => open(_Page.units),
          style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white),
          child: Text(AppLocaleKey.manage.tr())),
        const Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(AppLocaleKey.unitTitle.tr(), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.petrol)),
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
      TextButton.icon(onPressed: _chooseAvatar,
        icon: const Icon(Icons.photo_camera_outlined), label: Text(AppLocaleKey.changePhoto.tr())),
    ])),
    _panel([
      _input(AppLocaleKey.fullName, nameController, keyboard: TextInputType.name),
      const SizedBox(height: 14),
      _input(AppLocaleKey.phoneNumber, phoneController, keyboard: TextInputType.phone),
      Align(alignment: Alignment.centerLeft, child: TextButton.icon(
        onPressed: () { newPhoneController.text = phone; open(_Page.phoneInput); },
        icon: const Icon(Icons.verified_user_outlined), label: Text(AppLocaleKey.changePhone.tr()))),
      const SizedBox(height: 8),
      _input(AppLocaleKey.emailAddress, emailController, keyboard: TextInputType.emailAddress),
      const SizedBox(height: 4),
      Text(AppLocaleKey.optional.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
    ]),
    const SizedBox(height: 10),
    SizedBox(width: double.infinity, child: FilledButton(
      style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.all(15)),
      onPressed: () {
        if (nameController.text.trim().length < 2) { _toast(AppLocaleKey.requiredField.tr()); return; }
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
    if (filter == 0 || filter == 2) _notification(AppLocaleKey.notificationReportTitle, AppLocaleKey.notificationReportBody, Icons.fact_check_outlined),
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
      onPressed: () => _showNotificationDetails(title, body),
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
      _action(AppLocaleKey.contactUs, Icons.support_agent, _contactSupport),
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


  Widget _units() => _subPage(AppLocaleKey.units, [
    _panel([
      Row(children: [
        const Icon(Icons.apartment_outlined, color: AppColors.orange, size: 26),
        const Spacer(),
        Text(AppLocaleKey.linkedHomes.tr(), style: const TextStyle(color: AppColors.petrol, fontSize: 19, fontWeight: FontWeight.w800)),
      ]),
      const SizedBox(height: 10),
      Text(AppLocaleKey.unitTitle.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.petrol, fontSize: 17, fontWeight: FontWeight.w800)),
      Text(AppLocaleKey.currentUnit.tr() + ' • ' + AppLocaleKey.flatNumber.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted)),
      const Divider(height: 24),
      Row(children: [
        Chip(label: Text(AppLocaleKey.primaryUnit.tr()), backgroundColor: AppColors.mint, side: BorderSide.none),
        const Spacer(),
        Text(AppLocaleKey.unitTitle.tr(), style: const TextStyle(color: AppColors.petrol, fontWeight: FontWeight.w700)),
      ]),
    ]),
    _panel([
      FilledButton.icon(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const LinkHomeScreen())),
        icon: const Icon(Icons.add_home_outlined),
        label: Text(AppLocaleKey.addUnit.tr()),
        style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white),
      ),
      const SizedBox(height: 8),
      Text(AppLocaleKey.linkedHomesNote.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
    ]),
  ]);

  Widget _phoneInput() => _subPage(AppLocaleKey.changePhone, [
    _panel([
      Text(AppLocaleKey.enterNewPhone.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.petrol, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      _input(AppLocaleKey.phoneNumber, newPhoneController, keyboard: TextInputType.phone),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, child: FilledButton(
        onPressed: () {
          final value = newPhoneController.text.trim();
          if (!RegExp(r'^\\+[1-9][0-9]{7,14}
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
).hasMatch(value)) {
            _toast(AppLocaleKey.phoneFormat.tr());
            return;
          }
          open(_Page.phoneOtp);
        },
        style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white),
        child: Text(AppLocaleKey.sendCode.tr()),
      )),
    ]),
  ]);

  Widget _phoneOtp() => _subPage(AppLocaleKey.verificationCode, [
    _panel([
      Text(AppLocaleKey.phoneOtpHint.tr(namedArgs: {'phone': newPhoneController.text.trim()}),
        textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted)),
      const SizedBox(height: 14),
      _input(AppLocaleKey.verificationCode, otpController, keyboard: TextInputType.number),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, child: FilledButton(
        onPressed: () {
          if (!RegExp(r'^[0-9]{6}
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
).hasMatch(otpController.text.trim())) {
            _toast(AppLocaleKey.invalidVerificationCode.tr());
            return;
          }
          setState(() {
            phone = newPhoneController.text.trim();
            phoneController.text = phone;
            page = _Page.edit;
          });
          _toast(AppLocaleKey.phoneUpdated.tr());
        },
        style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white),
        child: Text(AppLocaleKey.verifyPhone.tr()),
      )),
      TextButton(onPressed: () => open(_Page.phoneInput), child: Text(AppLocaleKey.changePhone.tr())),
    ]),
  ]);

  Future<void> _chooseAvatar() async {
    const options = <IconData>[
      Icons.person_outline_rounded,
      Icons.face_rounded,
      Icons.support_agent_rounded,
      Icons.emoji_people_rounded,
    ];
    final selected = await showModalBottomSheet<IconData>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(spacing: 16, runSpacing: 16, children: options.map((icon) => InkWell(
          onTap: () => Navigator.pop(context, icon),
          child: CircleAvatar(radius: 30, backgroundColor: AppColors.mint, child: Icon(icon, color: AppColors.petrol, size: 30)),
        )).toList()),
      )),
    );
    if (selected != null && mounted) setState(() => avatarIcon = selected);
  }

  void _showNotificationDetails(String titleKey, String bodyKey) {
    showDialog<void>(context: context, builder: (context) => AlertDialog(
      title: Text(titleKey.tr()),
      content: Text(bodyKey.tr()),
      actions: [TextButton(onPressed: () { setState(() => read = true); Navigator.pop(context); }, child: Text(AppLocaleKey.close.tr()))],
    ));
  }

  Future<void> _contactSupport() async {
    final controller = TextEditingController();
    final sent = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocaleKey.contactUs.tr()),
        content: TextField(controller: controller, minLines: 3, maxLines: 5, decoration: InputDecoration(hintText: AppLocaleKey.messageHint.tr())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocaleKey.cancel.tr())),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim().length >= 10), child: Text(AppLocaleKey.sendMessage.tr())),
        ],
      ),
    );
    controller.dispose();
    if (sent == false && mounted) _toast(AppLocaleKey.requiredField.tr());
  }

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
