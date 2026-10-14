import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/api_consumer.dart';
class AuthRepository {
 AuthRepository(this.api,this.storage); final ApiConsumer api; final FlutterSecureStorage storage;
 Future<void> signIn(String email,String password) async=>_save(await api.post<Map<String,dynamic>>('/auth/login',data:{'email':email,'password':password}));
 Future<void> register({required String name,required String email,required String password,required String phone,required String locale}) async=>_save(await api.post<Map<String,dynamic>>('/auth/register',data:{'name':name,'email':email,'password':password,'password_confirmation':password,'phone':phone.isEmpty?null:phone,'locale':locale}));
 Future<void> _save(Response<Map<String,dynamic>> response) async {
  final token=response.data?['data']?['token']; if(token is! String||token.isEmpty) throw const FormatException('Missing access token');
  await storage.write(key:'rounder_access_token',value:token);
 }
 Future<bool> hasSession() async=>(await storage.read(key:'rounder_access_token'))?.isNotEmpty??false;
 Future<void> signOut() async {try{await api.post('/auth/logout');}on DioException{/* clear local credentials even if offline */} await storage.delete(key:'rounder_access_token');}
}
