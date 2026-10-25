import 'package:flutter/material.dart';
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
    this.locationKey,
  );

  factory OrderData.fromPreview(PreviewOrder order) => OrderData(
    order,
    order.serviceKey,
    order.reference,
    order.statusKey,
    Icons.home_repair_service_outlined,
    order.amount.toStringAsFixed(2),
    order.scheduledAt,
    order.locationKey,
  );

  final PreviewOrder preview;
  final String titleKey;
  final String reference;
  final String statusKey;
  final IconData icon;
  final String amount;
  final DateTime scheduledAt;
  final String locationKey;
}
