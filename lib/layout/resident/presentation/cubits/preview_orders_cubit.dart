import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_locale_key.dart';

class PreviewOrder {
  const PreviewOrder({required this.reference, required this.serviceKey,
    required this.providerKey, required this.scheduledAt, required this.amount,
    required this.locationKey, this.statusKey = AppLocaleKey.orderScheduled, this.notes = ''});
  final String reference, serviceKey, providerKey, locationKey, statusKey, notes;
  final DateTime scheduledAt;
  final double amount;
  PreviewOrder cancelled() => PreviewOrder(reference: reference, serviceKey: serviceKey,
    providerKey: providerKey, scheduledAt: scheduledAt, amount: amount,
    locationKey: locationKey, statusKey: AppLocaleKey.requestCancelled, notes: notes);
}

/// Session-local repository for reviewing the journey without calling the API.
/// It is registered in GetIt, so all tabs observe the same order collection.
class PreviewOrdersCubit extends Cubit<List<PreviewOrder>> {
  PreviewOrdersCubit() : super(const []);
  int _sequence = 0;

  PreviewOrder create({required String serviceKey, required String providerKey,
    required DateTime scheduledAt, required double amount, required String locationKey,
    String notes = ''}) {
    final order = PreviewOrder(reference: 'PREVIEW-${++_sequence}',
      serviceKey: serviceKey, providerKey: providerKey, scheduledAt: scheduledAt,
      amount: amount, locationKey: locationKey, notes: notes);
    emit(List.unmodifiable([order, ...state]));
    return order;
  }

  void cancel(String reference) {
    emit(List.unmodifiable(state.map((o) => o.reference == reference ? o.cancelled() : o)));
  }
}
