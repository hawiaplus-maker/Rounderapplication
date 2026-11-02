/// Model of one city returned by `GET ${EndPoints.cities}`.
class City {
  const City({
    required this.id,
    required this.name,
    this.code,
    this.countryCode,
  });

  final int id;
  final String name;
  final String? code;
  final String? countryCode;

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: int.tryParse('${json['id'] ?? ''}') ?? 0,
      name: (json['name'] ?? '').toString(),
      code: json['code']?.toString(),
      countryCode: json['country_code']?.toString(),
    );
  }
}
