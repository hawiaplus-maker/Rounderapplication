import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounder_application/core/constants/display_placeholder.dart';
import 'package:rounder_application/core/locale/app_locale.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/global/widgets/brand_gradient_backdrop.dart';
import 'package:rounder_application/logic/service_schedule_logic.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/bookings_cubit.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/screens/emergency_request_screen.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_additional_page.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_category_model.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_ali_assist_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_all_services_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_category_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/services_hub_page.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/homes_repo.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/cubit/services_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_detail_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_files_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_followup_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_invoice_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_payment_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/image_source_sheet.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_picker_sheet.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_providers_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_rating_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_review_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_schedule_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_tracking_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_waiting_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_warranty_page.dart';

/// Screen-only service journey. Values and actions are local prototype state
/// so the complete Figma flow can be reviewed before API integration.
class ServiceJourneyScreen extends StatefulWidget {
  const ServiceJourneyScreen({
    super.key,
    this.startOnTracking = false,
    this.startOnInvoice = false,
    this.order,
  });

  final bool startOnTracking, startOnInvoice;
  final PreviewOrder? order;

  @override
  State<ServiceJourneyScreen> createState() => _ServiceJourneyScreenState();
}

enum _Journey {
  hub,
  category,
  allServices,
  aliAssist,
  detail,
  schedule,
  providers,
  review,
  waiting,
  tracking,
  additional,
  files,
  invoice,
  payment,
  rating,
  warranty,
  followup,
}

class _ServiceJourneyScreenState extends State<ServiceJourneyScreen> {
  late _Journey page = widget.startOnInvoice
      ? _Journey.invoice
      : widget.startOnTracking
      ? _Journey.tracking
      : _Journey.hub;
  late _Journey previous = _Journey.hub;
  String service = AppLocaleKey.plumbing, issueType = AppLocaleKey.notSure;
  int? serviceId;
  ServiceItem? selectedService;
  int? selectedSubServiceId;
  int? selectedProviderId;
  String selectedProvider = AppLocaleKey.providerOne,
      location = AppLocaleKey.myUnit;  double basePrice = 0;
  List<ResidentHome> homes = const [];
  int? selectedHomeId;
  bool homesLoading = true;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? orderReference;
  final List<_Journey> _history = [];
  String get _dateLabel => selectedDate == null
      ? AppLocaleKey.pickDate.tr()
      : DateFormat.yMMMd(context.locale.toString()).format(selectedDate!);
  String get _timeLabel =>
      selectedTime?.format(context) ?? AppLocaleKey.pickTime.tr();
  String get _amountLabel =>
      (basePrice + (acceptedAdditional ? DisplayPlaceholder.number : 0))
          .toStringAsFixed(2);
  String? get _referenceLabel =>
      orderReference == null ? null : DisplayPlaceholder.text;

  int mode = 0, stage = 0, stars = 0;
  bool acceptedAdditional = false;
  final List<XFile> _photos = [];
  final _picker = ImagePicker();
  StreamSubscription<Locale>? _localeSubscription;
  final issue = TextEditingController(), notes = TextEditingController();
  // Services hub flow state: the catalog snapshot shared with the
  // all-services screen and the category currently opened.
  List<ServiceCategory> _hubCategories = const [];
  ServiceCategory? _selectedCategory;

  void go(_Journey next) {
    setState(() {
      _history.add(page);
      previous = page;
      page = next;
    });
  }

  void back() {
    setState(() {
      page = _history.isEmpty ? _Journey.hub : _history.removeLast();
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final value = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now.add(const Duration(days: 1)),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (value != null && mounted) setState(() => selectedDate = value);
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (value != null && mounted) setState(() => selectedTime = value);
  }

  void _continueSchedule() {
    if (mode == 0 && (selectedDate == null || selectedTime == null)) {
      _toast(AppLocaleKey.checkFields.tr());
      return;
    }
    final time = selectedTime ?? const TimeOfDay(hour: 0, minute: 0);
    final schedule = resolveServiceSchedule(
      selectedDate: selectedDate,
      hour: time.hour,
      minute: time.minute,
      fastestAvailable: mode == 1,
    );
    if (!isServiceScheduleInFuture(schedule)) {
      _toast(AppLocaleKey.checkFields.tr());
      return;
    }
    go(_Journey.providers);
  }

  Future<void> _submitPreview() async {
    final dashboard = context.read<ResidentDashboardCubit>().state;
    final homeId = selectedHomeId ??
        (dashboard is DashboardReady ? dashboard.data.homeId : null);
    if (homeId == null) {
      _toast(AppLocaleKey.loginRequired.tr());
      return;
    }
    if (serviceId == null) {
      _toast(AppLocaleKey.checkFields.tr());
      return;
    }
    final time = selectedTime ?? const TimeOfDay(hour: 0, minute: 0);
    final scheduledAt = resolveServiceSchedule(
      selectedDate: selectedDate,
      hour: time.hour,
      minute: time.minute,
      fastestAvailable: mode == 1,
    );
    if (!isServiceScheduleInFuture(scheduledAt)) {
      _toast(AppLocaleKey.checkFields.tr());
      return;
    }
    if (orderReference == null) {
      try {
        await sl<ServicesCubit>().book(
          homeId: homeId,
          serviceId: serviceId!,
          date: scheduledAt,
          subServiceId: selectedSubServiceId,
          serviceProviderId: selectedProviderId,
          notes: issue.text.trim().isEmpty ? null : issue.text.trim(),
          images: _photos,
        );
        // Real booking created on the backend; refresh the orders list so it
        // shows up on the orders screen.
        sl<BookingsCubit>().load();
        orderReference = 'booked';
      } catch (_) {
        _toast(AppLocaleKey.connectionError.tr());
        return;
      }
    }
    go(_Journey.waiting);
  }

  @override
  void initState() {
    super.initState();
    final order = widget.order;
    if (order != null) {
      service = order.serviceKey;
      selectedProvider = order.providerKey;
      basePrice = order.amount;
      selectedDate = order.scheduledAt;
      selectedTime = TimeOfDay.fromDateTime(order.scheduledAt);
      location = order.locationKey;
      orderReference = order.reference;
      issue.text = order.notes;
      if (order.statusKey == AppLocaleKey.serviceComplete) stage = 3;
    }
    // Unit labels are localized: refetch them when the resident switches
    // language while this tab stays alive.
    _localeSubscription = appLocaleChanges.listen((_) => _loadHomes());
    _loadHomes();
  }

  Future<void> _loadHomes() async {
    try {
      final list = await sl<HomesRepository>().list();
      if (!mounted) return;
      final sorted = [...list]..sort((a, b) {
        final ai = a.id ?? 0;
        final bi = b.id ?? 0;
        return ai.compareTo(bi);
      });
      setState(() {
        homes = sorted;
        homesLoading = false;
        if (selectedHomeId == null && sorted.isNotEmpty) {
          selectedHomeId = sorted.first.id;
        }
      });
    } catch (_) {
      if (mounted) setState(() => homesLoading = false);
    }
  }

  void _activatePreview() {
    if (orderReference != null) {
      sl<PreviewOrdersCubit>().update(
        orderReference!,
        AppLocaleKey.orderActive,
      );
    }
    go(_Journey.tracking);
  }

  void _advancePreview() {
    setState(() => stage++);
    if (stage >= 3 && orderReference != null) {
      sl<PreviewOrdersCubit>().update(
        orderReference!,
        AppLocaleKey.serviceComplete,
        amount:
            basePrice + (acceptedAdditional ? DisplayPlaceholder.number : 0),
      );
    }
  }

  void _selectService(ServiceItem item) {
    setState(() {
      service = item.name;
      serviceId = item.id;
      selectedService = item;
      orderReference = null;
      acceptedAdditional = false;
    });
    go(_Journey.detail);
  }

  void _selectProvider(int id, String nameKey, double price) {
    setState(() {
      selectedProvider = nameKey;
      selectedProviderId = id;
      basePrice = price;
    });
    go(_Journey.review);
  }

  void _cancelPreview() {
    if (orderReference != null) {
      sl<PreviewOrdersCubit>().cancel(orderReference!);
    }
    _toast(AppLocaleKey.requestCancelled.tr());
    go(_Journey.hub);
  }

  void _openEmergency() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const EmergencyRequestScreen()),
    );
  }

  @override
  void dispose() {
    _localeSubscription?.cancel();
    issue.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BrandGradientBackdrop.deep(
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: switch (page) {
        _Journey.hub => ServicesHubPage(
          onCategory: (category) {
            setState(() => _selectedCategory = category);
            go(_Journey.category);
          },
          onAllServices: (categories) {
            setState(() => _hubCategories = categories);
            go(_Journey.allServices);
          },
          onAliAssist: () => go(_Journey.aliAssist),
        ),
        _Journey.category => _selectedCategory == null
            ? const SizedBox.shrink()
            : JourneyCategoryPage(
                category: _selectedCategory!,
                onBack: back,
                onSelectService: _selectService,
              ),
        _Journey.allServices => JourneyAllServicesPage(
          categories: _hubCategories,
          onBack: back,
          onSelectService: _selectService,
        ),
        _Journey.aliAssist => JourneyAliAssistPage(
          onBack: back,
          onPrepareSummary: () => go(_Journey.allServices),
          onPrototypeAction: _comingSoon,
          issue: issue,
          issueType: issueType,
          onIssueTypeChanged: (value) => setState(() => issueType = value),
          onAddPhotos: _pickPhoto,
          photoCount: _photos.length,
        ),
        _Journey.detail => JourneyDetailPage(
          onBack: back,
          serviceKey: service,
          subServices: selectedService?.subServices ?? const [],
          selectedSubServiceId: selectedSubServiceId,
          onSubServiceChanged: (id) => setState(() => selectedSubServiceId = id),
          issue: issue,
          issueType: issueType,
          onIssueTypeChanged: (key) => setState(() => issueType = key),
          onAddPhotos: _pickPhoto,
          photos: _photos,
          onNext: () {
            if (issue.text.trim().length < 5) {
              _toast(AppLocaleKey.requiredField.tr());
              return;
            }
            go(_Journey.schedule);
          },
        ),
        _Journey.schedule => JourneySchedulePage(
          onBack: back,
          location: location,
          mode: mode,
          dateLabel: _dateLabel,
          timeLabel: _timeLabel,
          onLocationChanged: (value) => setState(() => location = value),
          onModeChanged: (value) => setState(() => mode = value),
          onEmergency: _openEmergency,
          onPickDate: _pickDate,
          onPickTime: _pickTime,
          onNext: _continueSchedule,
          homes: homes,
          selectedHomeId: selectedHomeId,
          onHomeChanged: (id) => setState(() => selectedHomeId = id),
          homesLoading: homesLoading,
        ),
        _Journey.providers => JourneyProvidersPage(
          onBack: back,
          serviceKey: service,
          serviceId: serviceId,
          onViewCompany: () =>
              showJourneyPicker(context, AppLocaleKey.companyProfile),
          onSelectProvider: _selectProvider,
        ),
        _Journey.review => JourneyReviewPage(
          onBack: back,
          serviceKey: service,
          problemText: issue.text,
          providerKey: selectedProvider,
          dateTimeLabel: '$_dateLabel • $_timeLabel',
          locationLabel: location.tr(),
          basePriceLabel:
              '${basePrice.toStringAsFixed(2)} ${AppLocaleKey.currencySar.tr()}',
          totalLabel: '$_amountLabel ${AppLocaleKey.currencySar.tr()}',
          onSummary: () =>
              showJourneyPicker(context, AppLocaleKey.serviceSummary),
          onSubmit: () => _submitPreview(),
        ),
        _Journey.waiting => JourneyWaitingPage(
          onBack: back,
          onCancel: _cancelPreview,
          onAccept: _activatePreview,
        ),
        _Journey.tracking => JourneyTrackingPage(
          onBack: back,
          stage: stage,
          reference: _referenceLabel,
          providerLabel: selectedProvider.tr(),
          onChat: () => showJourneyPicker(context, AppLocaleKey.chat),
          onCall: () => showJourneyPicker(context, AppLocaleKey.callTechnician),
          onFiles: () => go(_Journey.files),
          onAdditional: () => go(_Journey.additional),
          onAdvance: _advancePreview,
          onReport: () => go(_Journey.invoice),
        ),
        _Journey.additional => JourneyAdditionalPage(
          onBack: back,
          notes: notes,
          onApprove: () {
            setState(() => acceptedAdditional = true);
            back();
          },
          onDecline: () {
            setState(() => acceptedAdditional = false);
            back();
          },
        ),
        _Journey.files => JourneyFilesPage(
          onBack: back,
          onAddPhoto: _pickPhoto,
          onAddVideo: _comingSoon,
          onProof: () => go(_Journey.invoice),
          photos: _photos,
        ),
        _Journey.invoice => JourneyInvoicePage(
          onBack: back,
          reference: _referenceLabel,
          basePriceLabel:
              '${basePrice.toStringAsFixed(2)} ${AppLocaleKey.currencySar.tr()}',
          acceptedAdditional: acceptedAdditional,
          totalLabel: '$_amountLabel ${AppLocaleKey.currencySar.tr()}',
          onConfirmReceipt: () => go(_Journey.rating),
          onPay: () => go(_Journey.payment),
          onProof: () => go(_Journey.files),
        ),
        _Journey.payment => JourneyPaymentPage(
          onBack: back,
          totalLabel: '$_amountLabel ${AppLocaleKey.currencySar.tr()}',
          onComplete: () => setState(() => page = _Journey.rating),
          onNext: () => go(_Journey.rating),
        ),
        _Journey.rating => JourneyRatingPage(
          onBack: back,
          providerLabel: selectedProvider.tr(),
          stars: stars,
          notes: notes,
          onStar: (value) => setState(() => stars = value),
          onSend: () {
            if (stars == 0) {
              _toast(AppLocaleKey.requiredField.tr());
              return;
            }
            go(_Journey.warranty);
          },
          onLater: () => go(_Journey.warranty),
        ),
        _Journey.warranty => JourneyWarrantyPage(
          onBack: back,
          onFollowUp: () => go(_Journey.followup),
          onHome: () => setState(() => page = _Journey.hub),
        ),
        _Journey.followup => JourneyFollowupPage(
          onBack: back,
          dateLabel: _dateLabel,
          timeLabel: _timeLabel,
          onPickDate: _pickDate,
          onPickTime: _pickTime,
          onRequestSent: () => _toast(AppLocaleKey.requestSent.tr()),
        ),
      },
    ),
  );

  /// Photo entry of the journey: a source chooser (gallery / camera) sheet
  /// stays on the current step — no page is opened for the pick — and the
  /// picked image is kept for the step's thumbnails.
  Future<void> _pickPhoto() async {
    final source = await showImageSourceSheet(context);
    if (source == null || !mounted) return;
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;
      setState(() => _photos.add(picked));
    } catch (_) {
      if (mounted) _toast(AppLocaleKey.imagePickFailed.tr());
    }
  }

  void _comingSoon() => _toast(AppLocaleKey.comingSoon.tr());

  void _toast(String value) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(value)));
}
