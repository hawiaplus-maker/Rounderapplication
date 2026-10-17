import 'package:rounder_application/core/network/api_consumer.dart';
import 'package:rounder_application/layout/resident/data/models/service_option.dart';
class ServicesRepository {
 ServicesRepository(this.api); final ApiConsumer api;
 Future<List<ServiceOption>> list() async {
  final r=await api.get<Map<String,dynamic>>('/resident/services'); final data=r.data?['data'];
  if(data is! List) return []; return data.whereType<Map<String,dynamic>>().map(ServiceOption.fromJson).toList();
 }
 Future<void> book({required int homeId,required int serviceId,required DateTime date}) async {
  await api.post('/resident/bookings',data:{'home_id':homeId,'service_id':serviceId,'scheduled_at':date.toIso8601String()});
 }
 String get errorKey=>'connection_error';
}
