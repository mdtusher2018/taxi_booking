import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/models/monthly_revenue_model.dart';

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
