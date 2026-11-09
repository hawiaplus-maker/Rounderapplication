import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounder_application/core/locale/app_locale.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/global/widgets/brand_gradient_backdrop.dart';
import 'package:rounder_application/logic/service_schedule_logic.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/bookings_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/data/repo/bookings_repo.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/screens/emergency_request_screen.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_additional_page.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_category_model.dart';
import 'package:rounder_application/layout/resident/features/services/data/repo/services_repo.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_ali_assist_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_all_services_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_category_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/services_hub_page.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/homes_repo.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/selected_home_store.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/cubit/services_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_detail_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_files_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_followup_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_invoice_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_payment_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/image_source_sheet.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_add_home_dialog.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_picker_sheet.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/screens/add_unit_screen.dart';
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
    this.isGuest = false,
    this.startOnTracking = false,
    this.startOnInvoice = false,
    this.startOnRating = false,
    this.order,
    this.bookingId,
  });

  /// Guest mode can browse the catalog but has no linked homes, so the
  /// signed-in home fetch is skipped and booking asks for sign-in.
  final bool isGuest;

  final bool startOnTracking, startOnInvoice, startOnRating;
  final PreviewOrder? order;

  /// Backend booking id the rating step targets when it opens from the order
  /// details of a completed real booking (`null` keeps prototype mode).
  final int? bookingId;

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
      : widget.startOnRating
      ? _Journey.rating
      : _Journey.hub;
  late _Journey previous = _Journey.hub;
  String service = AppLocaleKey.plumbing, issueType = AppLocaleKey.notSure;
  int? serviceId;
  ServiceItem? selectedService;
  int? selectedSubServiceId;
  int? selectedProviderId;
  int? selectedPriceId;
  String selectedProvider = AppLocaleKey.providerOne,
      location = AppLocaleKey.myUnit;
  double? basePrice;
  List<ResidentHome> homes = const [];
  int? selectedHomeId;
  bool homesLoading = true;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? orderReference;

  /// Backend id of the booking this journey just created (`data.id` of the
  /// book call) — the rating step targets it; null keeps the prototype mode.
  int? bookedBookingId;

  /// Quick-feedback tag keys of the rating step, in the design's order;
  /// resolved to their displayed text at send time.
  static const List<String> _ratingTagKeys = [
    AppLocaleKey.ratingTagQuality,
    AppLocaleKey.ratingTagPunctuality,
    AppLocaleKey.ratingTagTreatment,
  ];

  final List<_Journey> _history = [];
  String get _dateLabel => selectedDate == null
      ? AppLocaleKey.pickDate.tr()
      : DateFormat.yMMMd(context.locale.toString()).format(selectedDate!);
  String get _timeLabel =>
      selectedTime?.format(context) ?? AppLocaleKey.pickTime.tr();
  /// The review/invoice amount; null (hidden) while no provider price exists.
  String? get _basePriceLabel => basePrice == null
      ? null
      : '${basePrice!.toStringAsFixed(2)} ${AppLocaleKey.currencySar.tr()}';

  /// Hidden while no reference exists — placeholders are never painted.
  String? get _referenceLabel {
    final String reference = orderReference?.trim() ?? '';
    return reference.isEmpty ? null : reference;
  }

  int mode = 0, stage = 0, stars = 0;

  /// Picked quick-feedback keys of the rating step.
  List<String> selectedRatingTags = [];
  /// Inline schedule-rule flag (rounder-validation): shown under the
  /// schedule step's date/time pills instead of a toast.
  bool scheduleError = false;
  final List<XFile> _photos = [];
  final _picker = ImagePicker();
  StreamSubscription<Locale>? _localeSubscription;
  final issue = TextEditingController(), notes = TextEditingController();
  // Services hub flow state: the catalog snapshot shared with the
  // all-services screen and the category currently opened.
  List<ServiceCategory> _hubCategories = const [];
  ServiceCategory? _selectedCategory;
  // Sub-services of the selected service come in pages: the inline snapshot
  // (truncated by subServicesLimit in the categories call) seeds the first
  // pages, the details step loads the rest on demand.
  List<ServiceSubItem> _subServices = const [];
  int _subServicesPage = 0;
  bool _subServicesHasMore = false;
  bool _subServicesLoading = false;

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

  void _returnToServices() {
    setState(() {
      _history.clear();
      page = _Journey.hub;
      previous = _Journey.hub;
    });
  }

  /// Empties every text input of the flow (the problem description and the
  /// post-work notes). Closing an order's completed block calls it, so no
  /// text of a finished order stays behind and leaks into the next one —
  /// the review step reads `issue.text`, and the rating/additional steps
  /// share the `notes` controller.
  void _clearJourneyTextFields() {
    setState(() {
      issue.clear();
      notes.clear();
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
    if (value != null && mounted) {
      setState(() {
        selectedDate = value;
        // A fresh pick invalidates the inline schedule error.
        scheduleError = false;
      });
    }
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (value != null && mounted) {
      setState(() {
        selectedTime = value;
        // A fresh pick invalidates the inline schedule error.
        scheduleError = false;
      });
    }
  }

  /// Confirms a valid in-future schedule and moves to the provider step. A
  /// booking is always assigned to a home, so with no home linked yet the
  /// resident is routed to the add-unit screen first. A failing schedule is
  /// flagged inline under the date/time pills — no snackbar.
  void _continueSchedule() {
    final bool valid = mode != 0 ||
        (selectedDate != null && selectedTime != null);
    if (!valid) {
      setState(() => scheduleError = true);
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
      setState(() => scheduleError = true);
      return;
    }
    if (widget.isGuest) {
      _toast(AppLocaleKey.loginRequired.tr());
      return;
    }
    if (!homesLoading && selectedHomeId == null) {
      _promptAddHome();
      return;
    }
    setState(() => scheduleError = false);
    go(_Journey.providers);
  }

  /// Explains the missing home, opens the add-unit screen, and refetches the
  /// homes the resident returns to this journey — a freshly added unit is
  /// then auto-selected by [_loadHomes] and "continue" re-opens providers.
  Future<void> _promptAddHome() async {
    final open = await showJourneyAddHomeDialog(context);
    if (!open || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AddUnitScreen()),
    );
    if (mounted) _loadHomes(force: true);
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
        // book() returns the created booking's id — kept for the rating
        // step once the service is finished.
        bookedBookingId = await sl<ServicesCubit>().book(
          homeId: homeId,
          serviceId: serviceId!,
          date: scheduledAt,
          subServiceId: selectedSubServiceId,
          serviceProviderId: selectedProviderId,
          priceId: selectedPriceId,
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
    // A rating opened from a completed real booking's details targets that
    // booking on send (`/resident/bookings/{id}/rating`); previews keep the
    // prototype mode.
    bookedBookingId ??= widget.bookingId;
    // Unit labels are localized: refetch them when the resident switches
    // language while this tab stays alive.
    if (widget.isGuest) {
      homesLoading = false;
    } else {
      _localeSubscription = appLocaleChanges.listen((_) => _loadHomes());
      _loadHomes();
    }
  }

  Future<void> _loadHomes({bool force = false}) async {
    try {
      final list = await sl<HomesRepository>().list(force: force);
      if (!mounted) return;
      final sorted = [...list]..sort((a, b) {
        final ai = a.id ?? 0;
        final bi = b.id ?? 0;
        return ai.compareTo(bi);
      });
      setState(() {
        homes = sorted;
        homesLoading = false;
        // The unit picked on the dashboard's unit selector leads the order;
        // without a pick (or when it no longer exists) the first home wins.
        if (selectedHomeId == null && sorted.isNotEmpty) {
          final int? stored = sl<SelectedHomeStore>().readId();
          final bool storedExists = stored != null &&
              sorted.any((ResidentHome h) => h.id == stored);
          selectedHomeId = storedExists ? stored : sorted.first.id;
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
        amount: basePrice,
      );
    }
  }

  void _selectService(ServiceItem item) {
    final List<ServiceSubItem> subs = item.subServices;
    setState(() {
      service = item.name;
      serviceId = item.id;
      selectedService = item;
      selectedPriceId = null;
      orderReference = null;
      // A fresh order has nothing to rate yet: the previous booking's id and
      // its quick-feedback picks do not carry over.
      bookedBookingId = null;
      selectedRatingTags = [];
      // The inline snapshot is the first slice of the service's sub-services:
      // the catalog's own `has_more` decides whether more exist, and the
      // fetch continues at page 1 — the id dedupe keeps the inline overlap
      // out, so the endpoint's first page is not skipped.
      _subServices = List.of(subs);
      _subServicesPage = 0;
      _subServicesHasMore =
          item.hasMore ?? subs.length >= ServicesRepository.subServicesLimit;
    });
    go(_Journey.detail);
  }

  /// The details step's load-more: appends the next page of the service's
  /// sub-services (deduped by id in case the shapes overlap) and keeps the
  /// button only while the endpoint still reports more pages.
  Future<void> _loadMoreSubServices() async {
    if (serviceId == null || _subServicesLoading || !_subServicesHasMore) return;
    setState(() => _subServicesLoading = true);
    try {
      final ServiceSubItemPage page = await sl<ServicesRepository>()
          .subServices(serviceId: serviceId!, page: _subServicesPage + 1);
      if (!mounted) return;
      setState(() {
        final known = <int>{for (final s in _subServices) s.id};
        _subServices = [
          ..._subServices,
          ...page.items.where((s) => !known.contains(s.id)),
        ];
        _subServicesPage++;
        _subServicesHasMore = page.hasMore;
      });
    } catch (_) {
      if (mounted) _toast(AppLocaleKey.connectionError.tr());
    } finally {
      if (mounted) setState(() => _subServicesLoading = false);
    }
  }

  void _selectProvider(int id, String nameKey, double? price, int? priceId) {
    setState(() {
      selectedProvider = nameKey;
      selectedProviderId = id;
      selectedPriceId = priceId;
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

  /// Sends the rating of the finished service for the booking this journey
  /// created: `{rating, comment, tags}` on `/resident/bookings/{id}/rating`.
  /// A session preview order carries no booking id — the rating stays in its
  /// prototype mode and the flow moves on without the API call. On failure
  /// the step stays so the resident can retry.
  Future<void> _submitRating() async {
    final int? bookingId = bookedBookingId;
    if (bookingId == null) {
      go(_Journey.warranty);
      return;
    }
    try {
      await sl<BookingsRepository>().rate(
        id: bookingId,
        rating: stars,
        comment: notes.text.trim(),
        tags: [for (final String key in selectedRatingTags) key.tr()],
      );
      if (!mounted) return;
      go(_Journey.warranty);
    } catch (_) {
      if (mounted) _toast(AppLocaleKey.connectionError.tr());
    }
  }

  /// Toggles one quick-feedback key of the rating step.
  void _toggleRatingTag(String key) {
    setState(() {
      if (selectedRatingTags.contains(key)) {
        selectedRatingTags.remove(key);
      } else {
        selectedRatingTags.add(key);
      }
    });
  }

  void _openEmergency() {
    final dashboardState = context.read<ResidentDashboardCubit>().state;
    // The unit picked in this journey (or on the dashboard) leads the request.
    final homeId =
        selectedHomeId ??
        sl<SelectedHomeStore>().readId() ??
        (dashboardState is DashboardReady ? dashboardState.data.homeId : null);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EmergencyRequestScreen(residentHomeId: homeId),
      ),
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
          subServices: _subServices,
          subServicesHasMore: _subServicesHasMore,
          subServicesLoading: _subServicesLoading,
          onLoadMoreSubServices: _loadMoreSubServices,
          selectedSubServiceId: selectedSubServiceId,
          onSubServiceChanged: (id) => setState(() => selectedSubServiceId = id),
          issue: issue,
          issueType: issueType,
          onIssueTypeChanged: (key) => setState(() => issueType = key),
          onAddPhotos: _pickPhoto,
          photos: _photos,
          // The description rule is validated inline inside the page.
          onNext: () => go(_Journey.schedule),
        ),
        _Journey.schedule => JourneySchedulePage(
          onBack: back,
          location: location,
          mode: mode,
          dateLabel: _dateLabel,
          timeLabel: _timeLabel,
          onLocationChanged: (value) => setState(() => location = value),
          onModeChanged: (value) {
            setState(() {
              mode = value;
              // Switching the visit mode clears the inline schedule error.
              scheduleError = false;
            });
          },
          onEmergency: _openEmergency,
          onPickDate: _pickDate,
          onPickTime: _pickTime,
          onNext: _continueSchedule,
          homes: homes,
          selectedHomeId: selectedHomeId,
          onHomeChanged: (id) {
            setState(() => selectedHomeId = id);
            // Manual pick also becomes the local default for the next order.
            sl<SelectedHomeStore>().writeId(id);
          },
          homesLoading: homesLoading,
          scheduleError: scheduleError,
        ),
        _Journey.providers => JourneyProvidersPage(
          onBack: back,
          serviceKey: service,
          serviceId: serviceId,
          subServiceId: selectedSubServiceId,
          homeId: selectedHomeId,
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
          basePriceLabel: _basePriceLabel,
          totalLabel: _basePriceLabel,
          onSummary: () =>
              showJourneyPicker(context, AppLocaleKey.serviceSummary),
          onSubmit: () => _submitPreview(),
        ),
        _Journey.waiting => JourneyWaitingPage(
          onBack: back,
          onCancel: _cancelPreview,
          onAccept: _activatePreview,
          onServices: _returnToServices,
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
          onApprove: back,
          onDecline: back,
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
          basePriceLabel: _basePriceLabel,
          totalLabel: _basePriceLabel,
          onConfirmReceipt: () => go(_Journey.rating),
          onPay: () => go(_Journey.payment),
          onProof: () => go(_Journey.files),
        ),
        _Journey.payment => JourneyPaymentPage(
          onBack: back,
          totalLabel: _basePriceLabel,
          onComplete: () => setState(() => page = _Journey.rating),
          onNext: () => go(_Journey.rating),
        ),
        _Journey.rating => JourneyRatingPage(
          onBack: back,
          providerLabel: selectedProvider.tr(),
          stars: stars,
          notes: notes,
          tags: _ratingTagKeys,
          selectedTags: selectedRatingTags,
          onStar: (value) => setState(() => stars = value),
          onTagToggle: _toggleRatingTag,
          // The star rule is validated inline inside the rating page.
          onSend: _submitRating,
          onLater: () => go(_Journey.warranty),
        ),
        _Journey.warranty => JourneyWarrantyPage(
          onBack: back,
          onFollowUp: () => go(_Journey.followup),
          // Order complete and block closed: pick the next service from a
          // clean flow — no problem text or notes of a finished order remain.
          onHome: () {
            _returnToServices();
            _clearJourneyTextFields();
            // Reached through a completed booking's details: the flow is
            // done — land back on the orders list the details were opened
            // from, refetching bookings so the list shows the rated state.
            if (widget.startOnRating) {
              sl<BookingsCubit>().load();
              Navigator.of(context)
                ..pop()
                ..pop();
            }
          },
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
