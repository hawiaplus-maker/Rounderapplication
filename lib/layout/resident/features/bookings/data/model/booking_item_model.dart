class BookingItem {
 const BookingItem({required this.id,required this.serviceName,required this.statusName,required this.statusCode,required this.scheduledAt,required this.amount});
 final int id; final String serviceName,statusName,statusCode,scheduledAt; final double amount;
 bool get canCancel=>statusCode=='pending'||statusCode=='confirmed';
 factory BookingItem.fromJson(Map<String,dynamic> j)=>BookingItem(
  id:int.tryParse('${j['id']}')??0,serviceName:j['service_name']?.toString()??'',
  statusName:j['status_name']?.toString()??'',statusCode:j['status_code']?.toString()??'',
  scheduledAt:j['scheduled_at']?.toString()??'',amount:double.tryParse('${j['total_amount']??0}')??0);
}
