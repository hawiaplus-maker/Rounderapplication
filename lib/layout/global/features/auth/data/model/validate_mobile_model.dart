/// Models of `POST ${EndPoints.validateMobile}` — the pre-sign-in phone check:
/// `{"status": true, "message": "…", "data": {"mobile": "0512345678",
/// "formatted_mobile": "+966512345678", "is_registered": false, "user": null}}`.
class ValidateMobileResponse {
  const ValidateMobileResponse({
    this.status = false,
    this.message = '',
    this.data,
  });
  final bool status;

  /// Backend message is already localized by the server (Accept-Language).
  final String message;
  final ValidateMobileModel? data;
  factory ValidateMobileResponse.fromJson(Map<String, dynamic> j) =>
      ValidateMobileResponse(
        status: j['status'] == true,
        message: j['message']?.toString() ?? '',
        data: j['data'] is Map<String, dynamic>
            ? ValidateMobileModel.fromJson(j['data'])
            : null,
      );
}

class ValidateMobileModel {
  const ValidateMobileModel({
    required this.mobile,
    required this.formattedMobile,
    this.isRegistered = false,
    this.user,
  });
  final String mobile;
  final String formattedMobile;
  final bool isRegistered;
  final ValidatedMobileUser? user;
  factory ValidateMobileModel.fromJson(Map<String, dynamic> j) =>
      ValidateMobileModel(
        mobile: j['mobile']?.toString() ?? '',
        formattedMobile: j['formatted_mobile']?.toString() ?? '',
        isRegistered: j['is_registered'] == true,
        user: j['user'] is Map<String, dynamic>
            ? ValidatedMobileUser.fromJson(j['user'])
            : null,
      );
}

class ValidatedMobileUser {
  const ValidatedMobileUser({this.id, this.name = '', this.phone = ''});
  final int? id;
  final String name, phone;
  factory ValidatedMobileUser.fromJson(Map<String, dynamic> j) =>
      ValidatedMobileUser(
        id: int.tryParse('${j['id']}'),
        name: j['name']?.toString() ?? '',
        phone: j['phone']?.toString() ?? '',
      );
}
