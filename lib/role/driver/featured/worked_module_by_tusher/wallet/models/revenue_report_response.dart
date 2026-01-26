class RevenueReportResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<MonthlyRevenue> data;

  RevenueReportResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RevenueReportResponse.fromJson(Map<String, dynamic> json) {
    return RevenueReportResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => MonthlyRevenue.fromJson(e))
          .toList(),
    );
  }
}

class MonthlyRevenue {
  final String month;
  final num revenue;

  MonthlyRevenue({required this.month, required this.revenue});

  factory MonthlyRevenue.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenue(month: json['month'], revenue: json['revenue']);
  }
}
