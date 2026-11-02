import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/constants/display_placeholder.dart';
import 'package:rounder_application/layout/resident/features/bookings/data/model/booking_item_model.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';

/// Presentation data of one order row in the orders prototype.
class OrderData {
  const OrderData(
    this.preview,
    this.titleKey,
    this.reference,
    this.statusKey,
    this.icon,
    this.amount,
    this.scheduledAt,
    this.locationKey, {
    this.bookingId,
    this.statusName,
    this.subServiceName,
    this.providerName,
    this.mediaUrls = const <String>[],
  });

  factory OrderData.fromPreview(PreviewOrder order) => OrderData(
        order,
        order.serviceKey,
        DisplayPlaceholder.text,
        order.statusKey,
        Icons.home_repair_service_outlined,
        order.amount.toStringAsFixed(2),
        order.scheduledAt,
        order.locationKey,
      );

  /// Build presentation data from a real booking returned by
  /// `/resident/bookings`. The preview is null, so tracking/invoice flows that
  /// rely on a preview order are disabled for real bookings.
  factory OrderData.fromBooking(BookingItem booking) {
    final statusKey = _statusKey(booking.statusCode);
    return OrderData(
      null,
      booking.serviceName,
      'RD-${booking.id}',
      statusKey,
      Icons.home_repair_service_outlined,
      booking.amount.toStringAsFixed(2),
      DateTime.tryParse(booking.scheduledAt) ?? DateTime.now(),
      booking.providerName ?? '',
      bookingId: booking.id,
      statusName: booking.statusName,
      subServiceName: booking.subServiceName,
      providerName: booking.providerName,
      mediaUrls: booking.mediaUrls,
    );
  }

  static String _statusKey(String code) {
    switch (code) {
      case 'pending':
        return AppLocaleKey.orderScheduled;
      case 'confirmed':
      case 'active':
        return AppLocaleKey.orderActive;
      case 'completed':
        return AppLocaleKey.serviceComplete;
      case 'cancelled':
        return AppLocaleKey.requestCancelled;
      default:
        return AppLocaleKey.orderScheduled;
    }
  }

  final PreviewOrder? preview;
  final String titleKey;
  final String reference;
  final String statusKey;
  final IconData icon;
  final String amount;
  final DateTime scheduledAt;
  final String locationKey;
  final int? bookingId;
  final String? statusName;
  final String? subServiceName;
  final String? providerName;
  final List<String> mediaUrls;
}
