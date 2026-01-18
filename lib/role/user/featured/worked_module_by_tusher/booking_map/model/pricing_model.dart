class PricingModel {
  final String title;
  final String subtitle;
  final double startFare;
  final double perKm;
  final double perMin;
  final double minFare;
  final String? extra;

  PricingModel({
    required this.title,
    required this.subtitle,
    required this.startFare,
    required this.perKm,
    required this.perMin,
    required this.minFare,
    this.extra,
  });
}
