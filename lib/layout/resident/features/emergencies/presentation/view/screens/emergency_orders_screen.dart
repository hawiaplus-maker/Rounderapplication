import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_emergency_bar.dart';
import 'package:rounder_application/layout/resident/features/emergencies/data/model/emergency_request_model.dart';
import 'package:rounder_application/layout/resident/features/emergencies/data/repo/emergency_repository.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/screens/emergency_request_screen.dart';

/// Displays the resident's submitted emergency requests.
class EmergencyOrdersScreen extends StatefulWidget {
  const EmergencyOrdersScreen({super.key, required this.residentHomeId});

  /// Resolved at the push site (where the dashboard cubit is available), so
  /// this pushed route never reads a provider it cannot see.
  final int? residentHomeId;

  @override
  State<EmergencyOrdersScreen> createState() => _EmergencyOrdersScreenState();
}

class _EmergencyOrdersScreenState extends State<EmergencyOrdersScreen> {
  late Future<List<EmergencyRequestItem>> _requests;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _requests = sl<EmergencyRepository>().listRequests();
  }

  Future<void> _refresh() async {
    setState(_load);
    try {
      await _requests;
    } catch (_) {
      // The FutureBuilder displays the request error in the page body.
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.sand,
    appBar: AppBar(backgroundColor: AppColors.sand, title: Text(AppLocaleKey.emergencyOrders.tr())),
    body: FutureBuilder<List<EmergencyRequestItem>>(
      future: _requests,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocaleKey.connectionError.tr(), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => setState(_load),
                    icon: const Icon(Icons.refresh),
                    label: Text(AppLocaleKey.retry.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        final requests = snapshot.data ?? const <EmergencyRequestItem>[];
        return RefreshIndicator(
          onRefresh: _refresh,
          child: requests.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height * .3),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.receipt_long_outlined, size: 54, color: AppColors.petrol),
                        const SizedBox(height: 14),
                      ],
                    ),

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Text(
                          AppLocaleKey.noEmergencyOrders.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.extraBold18.copyWith(color: AppColors.petrol),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: HomeEmergencyBar(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => EmergencyRequestScreen(
                              residentHomeId: widget.residentHomeId,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: requests.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _EmergencyRequestCard(request: requests[index]),
                ),
        );
      },
    ),
  );
}

class _EmergencyRequestCard extends StatelessWidget {
  const _EmergencyRequestCard({required this.request});

  final EmergencyRequestItem request;

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.tryParse(request.createdAt);
    final dateLabel = createdAt == null
        ? null
        : DateFormat.yMMMd(context.locale.toString()).add_jm().format(createdAt.toLocal());

    return Card(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.emergencyWash,
                  child: Icon(Icons.emergency_outlined, color: AppColors.emergency),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.typeName.isEmpty
                            ? AppLocaleKey.emergencyTitle.tr()
                            : request.typeName,
                        style: AppTextStyles.extraBold17.copyWith(color: AppColors.petrol),
                      ),
                      Text(
                        '${AppLocaleKey.emergencyReference.tr()}: ${request.reference}',
                        style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
                if (request.statusName.isNotEmpty)
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.emergencyWash,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        request.statusName,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.captionRegular.copyWith(color: AppColors.emergency),
                      ),
                    ),
                  ),
              ],
            ),
            if (dateLabel != null) ...[
              const SizedBox(height: 12),
              _RequestDetail(icon: Icons.schedule_outlined, text: dateLabel),
            ],
            if (request.location.isNotEmpty) ...[
              const SizedBox(height: 8),
              _RequestDetail(icon: Icons.location_on_outlined, text: request.location),
            ],
            if (request.contactPhone.isNotEmpty) ...[
              const SizedBox(height: 8),
              _RequestDetail(icon: Icons.phone_outlined, text: request.contactPhone),
            ],
            if (request.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                request.description,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.ink),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RequestDetail extends StatelessWidget {
  const _RequestDetail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: AppColors.muted),
      const SizedBox(width: 6),
      Expanded(
        child: Text(text, style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted)),
      ),
    ],
  );
}
