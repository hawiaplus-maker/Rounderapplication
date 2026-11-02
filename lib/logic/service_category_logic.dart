import 'package:rounder_application/layout/resident/features/services/data/model/service_category_model.dart';

/// Subtitle of a service category card (Figma 298:251): the first two service
/// names joined by " • " — e.g. "سباكة • كهرباء". Fewer names are joined the
/// same way; an empty list yields an empty string.
const serviceSubtitleSeparator = ' • ';

String serviceCategorySubtitle(List<ServiceItem> services) {
  if (services.isEmpty) return '';
  return services
      .take(2)
      .map((service) => service.name)
      .join(serviceSubtitleSeparator);
}
