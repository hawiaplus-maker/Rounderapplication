class ResidentDashboard {
  const ResidentDashboard({this.residentName='',this.homeName='',this.homeId,this.hasHome=true,this.associationBalance=0,this.propertyHealthPercent=0,this.upcomingService,this.recentActivity});
  final String residentName,homeName; final int? homeId; final bool hasHome; final double associationBalance; final int propertyHealthPercent;
  final DashboardItem? upcomingService,recentActivity;
  factory ResidentDashboard.fromJson(Map<String,dynamic> j)=>ResidentDashboard(
    residentName:j['resident_name']?.toString()??'',homeName:j['home_name']?.toString()??'',homeId:int.tryParse('${j['home_id']??''}'),hasHome:j['has_home']!=false,
    associationBalance:double.tryParse('${j['association_balance']??0}')??0,
    propertyHealthPercent:int.tryParse('${j['property_health_percent']??0}')??0,
    upcomingService:j['upcoming_service'] is Map<String,dynamic>?DashboardItem.fromJson(j['upcoming_service']):null,
    recentActivity:j['recent_activity'] is Map<String,dynamic>?DashboardItem.fromJson(j['recent_activity']):null);
}
class DashboardItem {
  const DashboardItem({required this.title,this.subtitle=''}); final String title,subtitle;
  factory DashboardItem.fromJson(Map<String,dynamic> j)=>DashboardItem(title:j['title']?.toString()??'',subtitle:j['subtitle']?.toString()??'');
}
