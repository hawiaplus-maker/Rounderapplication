/// Model of one service provider returned by
/// `GET /resident/service-providers?service_id=...`.
class ServiceProvider {
  const ServiceProvider({
    required this.id,
    required this.name,
    this.rating,
    this.price,
    this.priceId,
    this.imageUrl,
    this.meta,
  });

  final int id;
  final String name;
  final String? rating;
  final double? price;
  final int? priceId;
  final String? imageUrl;
  final String? meta;

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'] ?? json['rating_text'] ?? json['meta'];
    return ServiceProvider(
      id: int.tryParse('${json['id'] ?? json['provider_id'] ?? ''}') ?? 0,
      name: (json['name'] ??
              json['provider_name'] ??
              json['company_name'] ??
              '')
          .toString(),
      rating: rating?.toString(),
      price: double.tryParse('${json['price'] ?? json['base_price'] ?? ''}'),
      priceId: int.tryParse('${json['price_id'] ?? ''}'),
      imageUrl: json['image_url']?.toString() ?? json['logo']?.toString(),
      meta: json['meta']?.toString() ??
          json['description']?.toString(),
    );
  }
}
