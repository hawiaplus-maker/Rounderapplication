/// One emergency category returned by `GET ${EndPoints.emergencyTypes}`.
class EmergencyType {
  const EmergencyType({required this.id, required this.code, required this.name});

  final int id;
  final String code, name;

  factory EmergencyType.fromJson(Map<String, dynamic> j) => EmergencyType(
    id: int.tryParse('${j['id']}') ?? 0,
    code: (j['code'] ?? '').toString(),
    name: (j['name'] ?? '').toString(),
  );
}
