/// Model of `GET ${EndPoints.me}` — the boot-time session check. The
/// response has no status wrapper at all:
/// `{"data": {"id": 10, "name": "mohamed", "email": "mohamed@gmail.com",
/// "phone": "0565656565", "locale": "ar", "mobile": "0565656565"}}`.
class MeModel {
  const MeModel({
    this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.locale = '',
    this.mobile = '',
  });
  final int? id;
  final String name, email, phone, locale, mobile;
  factory MeModel.fromJson(Map<String, dynamic> j) => MeModel(
    id: int.tryParse('${j['id']}'),
    name: j['name']?.toString() ?? '',
    email: j['email']?.toString() ?? '',
    phone: j['phone']?.toString() ?? '',
    locale: j['locale']?.toString() ?? '',
    mobile: j['mobile']?.toString() ?? '',
  );
}
