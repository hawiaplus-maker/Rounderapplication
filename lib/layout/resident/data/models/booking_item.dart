class BookingItem {
 const BookingItem({required this.id,required this.serviceName,required this.statusName,required this.statusCode,required this.scheduledAt,required this.amount});
 final int id; final String serviceName,statusName,statusCode,scheduledAt; final double amount;
 bool get canCancel=>statusCode=='pending'||statusCode=='confirmed';
 factory BookingItem.fromJson(Map<String,dynamic> j){
  final service=j['service'] is Map?j['service'] as Map:{};
  final status=j['status'] is Map?j['status'] as Map:{};
  final translations=status['translations'] is List?status['translations'] as List:[];
  final serviceTranslations=service['translations'] is List?service['translations'] as List:[];
  final locale=const String.fromEnvironment('APP_LOCALE',defaultValue:'ar');
  final st=translations.whereType<Map>().firstWhere((e)=>e['locale']==locale,orElse:()=>{});
  final sv=serviceTranslations.whereType<Map>().firstWhere((e)=>e['locale']==locale,orElse:()=>{});
  return BookingItem(id:int.tryParse('${j['id']}')??0,serviceName:sv['name']?.toString()??service['code']?.toString()??'',statusName:st['name']?.toString()??status['code']?.toString()??'',statusCode:status['code']?.toString()??'',scheduledAt:j['scheduled_at']?.toString()??'',amount:double.tryParse('${j['total_amount']??0}')??0);
 }
}
