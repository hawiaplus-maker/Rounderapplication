import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/screen/emergency_request_screen.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_additional_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_catalog_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_detail_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_files_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_followup_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_invoice_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_payment_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_picker_sheet.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_providers_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_rating_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_review_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_schedule_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_tracking_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_waiting_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_warranty_page.dart';

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
  catalog,
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
      : _Journey.catalog;
  late _Journey previous = _Journey.catalog;
  String service = AppLocaleKey.plumbing, issueType = AppLocaleKey.notSure;
  String selectedProvider = AppLocaleKey.providerOne,
      location = AppLocaleKey.myUnit;
  double basePrice = 150;
  DateTime? selectedDate;
  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String? orderReference;
  final List<_Journey> _history = [];
  String get _dateLabel => selectedDate == null
      ? AppLocaleKey.preferredDate.tr()
      : DateFormat.yMMMd(context.locale.toString()).format(selectedDate!);
  String get _timeLabel => selectedTime.format(context);
  String get _amountLabel =>
      (basePrice + (acceptedAdditional ? 50 : 0)).toStringAsFixed(2);

  int mode = 0, stage = 0, stars = 0;
  bool acceptedAdditional = false;
  final query = TextEditingController(),
      issue = TextEditingController(),
      notes = TextEditingController();

  void go(_Journey next) {
    setState(() {
      _history.add(page);
      previous = page;
      page = next;
    });
  }

  void back() {
    setState(() {
      page = _history.isEmpty ? _Journey.catalog : _history.removeLast();
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
      initialTime: selectedTime,
    );
    if (value != null && mounted) setState(() => selectedTime = value);
  }

  void _continueSchedule() {
    if (mode == 0 && selectedDate == null) {
      _toast(AppLocaleKey.checkFields.tr());
      return;
    }
    final date = selectedDate ?? DateTime.now();
    final schedule = mode == 1
        ? DateTime.now().add(const Duration(hours: 3))
        : DateTime(
            date.year,
            date.month,
            date.day,
            selectedTime.hour,
            selectedTime.minute,
          );
    if (!schedule.isAfter(DateTime.now())) {
      _toast(AppLocaleKey.checkFields.tr());
      return;
    }
    go(_Journey.providers);
  }

  void _submitPreview() {
    if (orderReference == null) {
      final date = selectedDate ?? DateTime.now();
      final scheduledAt = mode == 1
          ? DateTime.now().add(const Duration(hours: 3))
          : DateTime(
              date.year,
              date.month,
              date.day,
              selectedTime.hour,
              selectedTime.minute,
            );
      final order = sl<PreviewOrdersCubit>().create(
        serviceKey: service,
        providerKey: selectedProvider,
        scheduledAt: scheduledAt,
        amount: basePrice,
        locationKey: location,
        notes: issue.text.trim(),
      );
      orderReference = order.reference;
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
        amount: basePrice + (acceptedAdditional ? 50 : 0),
      );
    }
  }

  void _selectService(String key) {
    setState(() {
      service = key;
      orderReference = null;
      acceptedAdditional = false;
    });
    go(_Journey.detail);
  }

  void _selectProvider(String nameKey, double price) {
    setState(() {
      selectedProvider = nameKey;
      basePrice = price;
    });
    go(_Journey.review);
  }

  void _cancelPreview() {
    if (orderReference != null) {
      sl<PreviewOrdersCubit>().cancel(orderReference!);
    }
    _toast(AppLocaleKey.requestCancelled.tr());
    go(_Journey.catalog);
  }

  void _openEmergency() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const EmergencyRequestScreen()),
    );
  }

  @override
  void dispose() {
    query.dispose();
    issue.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
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
        _Journey.catalog => JourneyCatalogPage(
          query: query,
          onQueryChanged: () => setState(() {}),
          onSelectService: _selectService,
        ),
        _Journey.detail => JourneyDetailPage(
          onBack: back,
          serviceKey: service,
          issue: issue,
          issueType: issueType,
          onIssueTypeChanged: (key) => setState(() => issueType = key),
          onAddPhotos: () => go(_Journey.files),
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
        ),
        _Journey.providers => JourneyProvidersPage(
          onBack: back,
          serviceKey: service,
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
          onSubmit: _submitPreview,
        ),
        _Journey.waiting => JourneyWaitingPage(
          onBack: back,
          onCancel: _cancelPreview,
          onAccept: _activatePreview,
        ),
        _Journey.tracking => JourneyTrackingPage(
          onBack: back,
          stage: stage,
          reference: orderReference,
          providerLabel: selectedProvider.tr(),
          onChat: () => showJourneyPicker(context, AppLocaleKey.chat),
          onCall: () =>
              showJourneyPicker(context, AppLocaleKey.callTechnician),
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
          onAddPhoto: _comingSoon,
          onAddVideo: _comingSoon,
          onProof: () => go(_Journey.invoice),
        ),
        _Journey.invoice => JourneyInvoicePage(
          onBack: back,
          reference: orderReference,
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
          onHome: () => setState(() => page = _Journey.catalog),
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

  void _comingSoon() => _toast(AppLocaleKey.comingSoon.tr());

  void _toast(String value) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(value)));
}
