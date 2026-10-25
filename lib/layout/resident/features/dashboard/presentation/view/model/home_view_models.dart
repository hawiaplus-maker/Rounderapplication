/// View data of the resident home dashboard.
///
/// The widgets only receive ready-to-display, localized values; the screen
/// builds these objects from the dashboard cubit and [AppLocaleKey].
class HomeUnit {
  const HomeUnit({required this.name, required this.code});

  final String name;
  final String code;
}

class HomeBalance {
  const HomeBalance({
    required this.title,
    required this.amount,
    required this.currency,
    required this.period,
    required this.actionLabel,
  });

  final String title;
  final String amount;
  final String currency;

  /// Empty when the API does not expose a period-start balance.
  final String period;
  final String actionLabel;
}

class HomeHealthMetric {
  const HomeHealthMetric({required this.label, required this.value});

  final String label;
  final String value;
}

class HomeHealth {
  const HomeHealth({
    required this.title,
    required this.percent,
    required this.score,
    required this.caption,
    required this.metrics,
    required this.actionLabel,
  });

  final String title;

  /// Numeric score drawn by the gauge (0..100).
  final int percent;

  /// Localized score text shown inside the gauge, e.g. "٨٧٪".
  final String score;
  final String caption;
  final List<HomeHealthMetric> metrics;
  final String actionLabel;
}

class HomeVisit {
  const HomeVisit({
    required this.title,
    required this.badge,
    required this.service,
    required this.serviceIcon,
    required this.provider,
    required this.time,
    required this.status,
    required this.actionLabel,
  });

  final String title;
  final String badge;
  final String service;
  final String serviceIcon;
  final String provider;
  final String time;
  final String status;
  final String actionLabel;
}

class HomeNextService {
  const HomeNextService({
    required this.title,
    required this.badge,
    required this.remainingLabel,
    required this.countdown,
    required this.countdownUnit,
    required this.service,
    required this.serviceIcon,
    required this.time,
  });

  final String title;
  final String badge;
  final String remainingLabel;
  final String countdown;
  final String countdownUnit;
  final String service;
  final String serviceIcon;
  final String time;
}
