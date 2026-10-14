import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_locale_key.dart';
import '../../../../core/theme/app_theme.dart';

/// Local, screen-only welcome journey from Resident App: onboarding, setup
/// checklist, welcome-gift selection, gift details, and completion.
class ResidentWelcomeFlow extends StatefulWidget {
  const ResidentWelcomeFlow({super.key, this.startAtGifts = false});
  final bool startAtGifts;

  @override
  State<ResidentWelcomeFlow> createState() => _ResidentWelcomeFlowState();
}

enum _WelcomePage { intro, tasks, gifts, details, success }

class _ResidentWelcomeFlowState extends State<ResidentWelcomeFlow> {
  late _WelcomePage _page = widget.startAtGifts ? _WelcomePage.gifts : _WelcomePage.intro;
  int _slide = 0;
  String? _gift;
  bool _profileDone = false;
  bool _addressDone = false;

  static const _introIcons = [
    Icons.home_work_outlined,
    Icons.support_agent_outlined,
    Icons.verified_outlined,
  ];
  static const _introTitles = [
    AppLocaleKey.introTitleServices,
    AppLocaleKey.introTitleAli,
    AppLocaleKey.introTitleQuality,
  ];
  static const _introBodies = [
    AppLocaleKey.introBodyServices,
    AppLocaleKey.introBodyAli,
    AppLocaleKey.introBodyQuality,
  ];
  static const _giftKeys = [
    AppLocaleKey.giftHomeCare,
    AppLocaleKey.giftServiceCredit,
    AppLocaleKey.giftCleaning,
  ];
  static const _giftDescriptions = [
    AppLocaleKey.giftHomeCareDesc,
    AppLocaleKey.giftCreditDesc,
    AppLocaleKey.giftCleaningDesc,
  ];
  static const _giftIcons = [
    Icons.home_repair_service_outlined,
    Icons.card_giftcard_outlined,
    Icons.cleaning_services_outlined,
  ];

  void _nextIntro() {
    if (_slide < 2) {
      setState(() => _slide++);
    } else {
      setState(() => _page = _WelcomePage.tasks);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.petrol,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, .38, .72, 1],
            colors: [Color(0xFF073B43), Color(0xFF0F6570), Color(0xFFA8D4CF), Color(0xFFFFF9EF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                child: Row(
                  children: [
                    Text(AppLocaleKey.welcome.tr(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      tooltip: AppLocaleKey.close.tr(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: switch (_page) {
                    _WelcomePage.intro => _introView(),
                    _WelcomePage.tasks => _tasksView(),
                    _WelcomePage.gifts => _giftsView(),
                    _WelcomePage.details => _detailView(),
                    _WelcomePage.success => _successView(),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _introView() => ListView(
    key: ValueKey('intro-$_slide'),
    padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
    children: [
      const SizedBox(height: 24),
      CircleAvatar(
        radius: 82,
        backgroundColor: Colors.white.withValues(alpha: .15),
        child: CircleAvatar(
          radius: 66,
          backgroundColor: Colors.white.withValues(alpha: .1),
          child: Icon(_introIcons[_slide], color: Colors.white, size: 70),
        ),
      ),
      const SizedBox(height: 32),
      Text(AppLocaleKey.welcomeSteps.tr(), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 8),
      Text(_introTitles[_slide].tr(), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 30, height: 1.25, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      Text(_introBodies[_slide].tr(), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.7)),
      const SizedBox(height: 28),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == _slide ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(color: index == _slide ? AppColors.orange : Colors.white54, borderRadius: BorderRadius.circular(8)),
        )),
      ),
      const SizedBox(height: 22),
      FilledButton(
        onPressed: _nextIntro,
        style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.petrol, minimumSize: const Size.fromHeight(54)),
        child: Text((_slide == 2 ? AppLocaleKey.startUsingRounder : AppLocaleKey.next).tr()),
      ),
      TextButton(onPressed: () => setState(() => _page = _WelcomePage.tasks), child: Text(AppLocaleKey.skip.tr(), style: const TextStyle(color: Colors.white))),
    ],
  );

  Widget _tasksView() => ListView(
    key: const ValueKey('welcome-tasks'),
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
    children: [
      Text(AppLocaleKey.welcomeSteps.tr(), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 8),
      Text(AppLocaleKey.welcomeGiftTitle.tr(), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 30, height: 1.2, fontWeight: FontWeight.w900)),
      const SizedBox(height: 18),
      _taskCard(AppLocaleKey.completeProfile, Icons.person_outline, _profileDone, () => setState(() => _profileDone = true)),
      _taskCard(AppLocaleKey.saveResidence, Icons.location_on_outlined, _addressDone, () => setState(() => _addressDone = true)),
      _taskCard(AppLocaleKey.pickWelcomeGift, Icons.card_giftcard_outlined, _profileDone && _addressDone, () => setState(() => _page = _WelcomePage.gifts)),
      const SizedBox(height: 18),
      FilledButton(
        onPressed: _profileDone && _addressDone ? () => setState(() => _page = _WelcomePage.gifts) : null,
        style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: AppColors.petrol, minimumSize: const Size.fromHeight(54)),
        child: Text(AppLocaleKey.pickWelcomeGift.tr()),
      ),
      TextButton(onPressed: () => setState(() => _page = _WelcomePage.gifts), child: Text(AppLocaleKey.continueLater.tr(), style: const TextStyle(color: AppColors.petrol))),
    ],
  );

  Widget _taskCard(String title, IconData icon, bool complete, VoidCallback onTap) => Card(
    color: Colors.white.withValues(alpha: .95),
    margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: ListTile(
      onTap: onTap,
      leading: CircleAvatar(backgroundColor: AppColors.mint, child: Icon(complete ? Icons.check : icon, color: AppColors.petrol)),
      title: Text(title.tr(), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.petrol)),
      subtitle: Text(complete ? AppLocaleKey.taskComplete.tr() : AppLocaleKey.taskAction.tr(), textAlign: TextAlign.right),
      trailing: Icon(complete ? Icons.check_circle : Icons.chevron_left, color: complete ? Colors.green : AppColors.orange),
    ),
  );

  Widget _giftsView() => ListView(
    key: const ValueKey('welcome-gifts'),
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
    children: [
      Text(AppLocaleKey.chooseWelcomeGiftTitle.tr(), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      Text(AppLocaleKey.chooseWelcomeGiftBody.tr(), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, height: 1.5)),
      const SizedBox(height: 20),
      ...List.generate(_giftKeys.length, (index) {
        final selected = _gift == _giftKeys[index];
        return Card(
          color: selected ? AppColors.mint : Colors.white.withValues(alpha: .96),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: selected ? AppColors.orange : Colors.transparent, width: 2)),
          child: ListTile(
            onTap: () => setState(() { _gift = _giftKeys[index]; _page = _WelcomePage.details; }),
            contentPadding: const EdgeInsets.all(14),
            leading: CircleAvatar(backgroundColor: AppColors.mint, child: Icon(_giftIcons[index], color: AppColors.petrol)),
            title: Text(_giftKeys[index].tr(), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.petrol)),
            subtitle: Text(_giftDescriptions[index].tr(), textAlign: TextAlign.right, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_left, color: AppColors.petrol),
          ),
        );
      }),
      TextButton.icon(onPressed: () => setState(() => _page = _WelcomePage.tasks), icon: const Icon(Icons.arrow_forward), label: Text(AppLocaleKey.back.tr())),
    ],
  );

  Widget _detailView() {
    final index = _giftKeys.indexOf(_gift ?? _giftKeys.first);
    return ListView(
      key: const ValueKey('welcome-gift-detail'),
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 30),
      children: [
        CircleAvatar(radius: 46, backgroundColor: AppColors.mint, child: Icon(_giftIcons[index], color: AppColors.petrol, size: 42)),
        const SizedBox(height: 24),
        Text(AppLocaleKey.giftDetails.tr(), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        Card(
          color: Colors.white.withValues(alpha: .96),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(_giftKeys[index].tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.petrol, fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Text(_giftDescriptions[index].tr(), textAlign: TextAlign.right, style: const TextStyle(height: 1.7)),
              const SizedBox(height: 20),
              Text(AppLocaleKey.giftTerms.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted)),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => setState(() => _page = _WelcomePage.success),
          style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: AppColors.petrol, minimumSize: const Size.fromHeight(54)),
          child: Text(AppLocaleKey.selectGift.tr()),
        ),
        TextButton(onPressed: () => setState(() => _page = _WelcomePage.gifts), child: Text(AppLocaleKey.back.tr(), style: const TextStyle(color: AppColors.petrol))),
      ],
    );
  }

  Widget _successView() => Center(
    key: const ValueKey('welcome-gift-success'),
    child: Padding(
      padding: const EdgeInsets.all(26),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const CircleAvatar(radius: 48, backgroundColor: AppColors.mint, child: Icon(Icons.card_giftcard, color: AppColors.petrol, size: 42)),
        const SizedBox(height: 18),
        Text(AppLocaleKey.giftSaved.tr(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text((_gift ?? AppLocaleKey.giftHomeCare).tr(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 22),
        FilledButton(onPressed: () => Navigator.maybePop(context), child: Text(AppLocaleKey.close.tr())),
      ]),
    ),
  );
}
