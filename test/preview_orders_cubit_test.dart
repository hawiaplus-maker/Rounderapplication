import 'package:flutter_test/flutter_test.dart';
import 'package:rounder_application/layout/resident/presentation/cubits/preview_orders_cubit.dart';
import 'package:rounder_application/core/constants/app_locale_key.dart';

void main() {
  test('created order retains chosen service, price, provider and date', () async {
    final cubit=PreviewOrdersCubit();
    final date=DateTime(2027,1,15,14);
    final order=cubit.create(serviceKey:AppLocaleKey.cleaning,providerKey:AppLocaleKey.providerTwo,
      scheduledAt:date,amount:180,locationKey:AppLocaleKey.myUnit);
    expect(cubit.state.single.reference,order.reference);
    expect(cubit.state.single.amount,180);
    expect(cubit.state.single.providerKey,AppLocaleKey.providerTwo);
    expect(cubit.state.single.scheduledAt,date);
    cubit.cancel(order.reference);
    expect(cubit.state.single.statusKey,AppLocaleKey.requestCancelled);
    expect(cubit.state.single.amount,180);
    await cubit.close();
  });
}
