import '../../../../core/network/api_consumer.dart';
import '../models/booking_item.dart';
class BookingsRepository {
 BookingsRepository(this.api);final ApiConsumer api;
 Future<List<BookingItem>> list()async{final r=await api.get<Map<String,dynamic>>('/resident/bookings');final values=r.data?['data'];if(values is! List)return [];return values.whereType<Map<String,dynamic>>().map(BookingItem.fromJson).toList();}
 Future<void> cancel(int id,String reason)async{await api.post('/resident/bookings/$id/cancel',data:{'reason':reason});}
}
