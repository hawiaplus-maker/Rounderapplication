/// Models for the `/resident/service-categories` endpoint: a category groups
/// a list of services, each service carrying its own id used for booking.
class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    this.imageUrl,
    this.services = const <ServiceItem>[],
  });

  final int id;
  final String name;
  final String? imageUrl;
  final List<ServiceItem> services;

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    final services = (json['services'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map(ServiceItem.fromJson)
            .toList() ??
        const <ServiceItem>[];
    return ServiceCategory(
      id: int.tryParse('${json['id']}') ?? 0,
      name: (json['name'] ?? '').toString(),
      imageUrl: json['image_url']?.toString(),
      services: services,
    );
  }
}

class ServiceItem {
  const ServiceItem({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.price,
    this.priceBeforeDiscount,
    this.discountType,
    this.discountValue,
    this.imageUrl,
    this.subServices = const <ServiceSubItem>[],
  });

  final int id;
  final String code;
  final String name;
  final String? description;
  final double? price;
  final String? priceBeforeDiscount;
  final String? discountType;
  final String? discountValue;
  final String? imageUrl;
  final List<ServiceSubItem> subServices;

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    final subs = (json['sub_services'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map(ServiceSubItem.fromJson)
            .toList() ??
        const <ServiceSubItem>[];
    return ServiceItem(
      id: int.tryParse('${json['id']}') ?? 0,
      code: (json['code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: json['description']?.toString(),
      price: double.tryParse('${json['price'] ?? ''}'),
      priceBeforeDiscount: json['price_before_discount']?.toString(),
      discountType: json['discount_type']?.toString(),
      discountValue: json['discount_value']?.toString(),
      imageUrl: json['image_url']?.toString(),
      subServices: subs,
    );
  }
}

class ServiceSubItem {
  const ServiceSubItem({
    required this.id,
    this.serviceId,
    this.code,
    this.name,
    this.description,
    this.imageUrl,
  });

  final int id;
  final int? serviceId;
  final String? code;
  final String? name;
  final String? description;
  final String? imageUrl;

  factory ServiceSubItem.fromJson(Map<String, dynamic> json) {
    return ServiceSubItem(
      id: int.tryParse('${json['id']}') ?? 0,
      serviceId: int.tryParse('${json['service_id'] ?? ''}'),
      code: json['code']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }
}
