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

  factory PricingModel.fromJson(Map<String, dynamic> json) {
    return PricingModel(
      title: json['category']['title'] ?? '',
      subtitle: json['category']['subtitle'] ?? '',
      startFare: (json['startFare'] as num).toDouble(),
      perKm: (json['perKm'] as num).toDouble(),
      perMin: (json['perMin'] as num).toDouble(),
      minFare: (json['minFare'] as num).toDouble(),
      extra: json['extra'],
    );
  }

  static List<PricingModel> fromJsonList(List list) {
    return list.map((e) => PricingModel.fromJson(e)).toList();
  }
}
