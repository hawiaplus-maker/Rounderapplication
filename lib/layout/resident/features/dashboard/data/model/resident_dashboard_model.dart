class ResidentDashboard {
  const ResidentDashboard({this.residentName='',this.homeName='',this.homeId,this.hasHome=true,this.associationBalance,this.propertyHealthPercent,this.unitLabel='',this.periodStartBalance,this.upcomingService,this.recentActivity});
  final String residentName,homeName,unitLabel; final int? homeId; final bool hasHome; final double? associationBalance; final int? propertyHealthPercent;
  final double? periodStartBalance;
  final DashboardItem? upcomingService,recentActivity;
  factory ResidentDashboard.fromJson(Map<String,dynamic> j)=>ResidentDashboard(
    residentName:j['resident_name']?.toString()??'',homeName:j['home_name']?.toString()??'',homeId:int.tryParse('${j['home_id']??''}'),hasHome:j['has_home']!=false,
    associationBalance:j['association_balance']==null?null:double.tryParse('${j['association_balance']}'),
    propertyHealthPercent:j['property_health_percent']==null?null:int.tryParse('${j['property_health_percent']}'),
    unitLabel:j['unit_label']?.toString()??j['unit_number']?.toString()??_unitFromName(j['home_name']),
    periodStartBalance:j['period_start_balance']==null?null:double.tryParse('${j['period_start_balance']}'),
    upcomingService:j['upcoming_service'] is Map<String,dynamic>?DashboardItem.fromJson(j['upcoming_service']):null,
    recentActivity:j['recent_activity'] is Map<String,dynamic>?DashboardItem.fromJson(j['recent_activity']):null);

  /// The dashboard composes `property · unit` into `home_name` and omits the
  /// unit keys; with them absent, the name's `·`-tail is the unit label.
  static String _unitFromName(Object? value) {
    final String name = value?.toString() ?? '';
    if (!name.contains('·')) return '';
    return name.split('·').last.trim();
  }
}
class DashboardItem {
  const DashboardItem({required this.title,this.subtitle=''}); final String title,subtitle;
  factory DashboardItem.fromJson(Map<String,dynamic> j)=>DashboardItem(title:j['title']?.toString()??'',subtitle:j['subtitle']?.toString()??'');
}
