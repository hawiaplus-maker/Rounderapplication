import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/model/welcome_gift_option.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_flow_header.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_gift_details_view.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_gift_success_view.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_gifts_view.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_intro_view.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_tasks_view.dart';

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
  late _WelcomePage _page = widget.startAtGifts
      ? _WelcomePage.gifts
      : _WelcomePage.intro;
  int _slide = 0;
  String? _gift;
  bool _profileDone = false;
  bool _addressDone = false;

  WelcomeGiftOption get _selectedGift => welcomeGiftOptions.firstWhere(
    (option) => option.titleKey == _gift,
    orElse: () => welcomeGiftOptions.first,
  );

  void _nextIntro() {
    if (_slide < 2) {
      setState(() => _slide++);
    } else {
      setState(() => _page = _WelcomePage.tasks);
    }
  }

  void _openGifts() => setState(() => _page = _WelcomePage.gifts);

  void _selectGift(WelcomeGiftOption option) {
    setState(() {
      _gift = option.titleKey;
      _page = _WelcomePage.details;
    });
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
            stops: [0, .19, .34, .57, .76, 1],
            colors: [
              AppColors.petrol,
              AppColors.petrol,
              AppColors.teal,
              AppColors.mintLight,
              AppColors.canvas,
              AppColors.sand,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (_page != _WelcomePage.intro)
                WelcomeFlowHeader(
                  onClose: () => Navigator.maybePop(context),
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: KeyedSubtree(
                    key: ValueKey(_page.name),
                    child: switch (_page) {
                      _WelcomePage.intro => WelcomeIntroView(
                        slide: _slide,
                        onSkip: () =>
                            setState(() => _page = _WelcomePage.tasks),
                        onNext: _nextIntro,
                      ),
                      _WelcomePage.tasks => WelcomeTasksView(
                        profileDone: _profileDone,
                        addressDone: _addressDone,
                        onCompleteProfile: () =>
                            setState(() => _profileDone = true),
                        onSaveResidence: () =>
                            setState(() => _addressDone = true),
                        onPickGift: _openGifts,
                        onContinueLater: _openGifts,
                      ),
                      _WelcomePage.gifts => WelcomeGiftsView(
                        selectedGiftKey: _gift,
                        onSelect: _selectGift,
                        onBack: () =>
                            setState(() => _page = _WelcomePage.tasks),
                      ),
                      _WelcomePage.details => WelcomeGiftDetailsView(
                        option: _selectedGift,
                        onSelectGift: () =>
                            setState(() => _page = _WelcomePage.success),
                        onBack: _openGifts,
                      ),
                      _WelcomePage.success => WelcomeGiftSuccessView(
                        giftTitle: _selectedGift.titleKey.tr(),
                        onClose: () => Navigator.maybePop(context),
                      ),
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
