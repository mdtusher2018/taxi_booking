class MonthlyRevenue {
  final String month;
  final num revenue;

  MonthlyRevenue({required this.month, required this.revenue});

  factory MonthlyRevenue.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenue(month: json['month'], revenue: json['revenue']);
  }
}
