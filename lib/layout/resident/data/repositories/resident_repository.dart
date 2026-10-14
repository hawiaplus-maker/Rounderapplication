import 'package:dio/dio.dart';
import '../../../../core/network/api_consumer.dart';
import '../models/resident_dashboard.dart';
class ResidentRepository {
  ResidentRepository(this.api); final ApiConsumer api;
  Future<ResidentDashboard> getDashboard() async {
    final r=await api.get<Map<String,dynamic>>('/resident/dashboard');
    final body=r.data??<String,dynamic>{}, data=body['data'];
    return ResidentDashboard.fromJson(data is Map<String,dynamic>?data:body);
  }
  String errorKey(Object e)=>e is DioException&&e.response?.statusCode==401?'login_required':'dashboard_unavailable';
}
