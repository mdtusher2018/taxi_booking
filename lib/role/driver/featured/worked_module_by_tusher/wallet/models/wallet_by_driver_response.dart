import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/models/monthly_revenue_model.dart';

class DriverWalletByIdResponse {
  final bool success;
  final int statusCode;
  final String message;
  final DriverWalletByIdData data;

  DriverWalletByIdResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DriverWalletByIdResponse.fromJson(Map<String, dynamic> json) {
    return DriverWalletByIdResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: DriverWalletByIdData.fromJson(json['data']),
    );
  }
}

class DriverWalletByIdData {
  final double driverTotalEarning;
  final MonthEarningSummary isMonthEarningSummary;
  final MonthSummary isMonthSummary;
  final List<MonthlyRevenue> fullYearData;
  final List<RecentTrip> recentTrips;

  DriverWalletByIdData({
    required this.driverTotalEarning,
    required this.isMonthEarningSummary,
    required this.isMonthSummary,
    required this.fullYearData,
    required this.recentTrips,
  });

  factory DriverWalletByIdData.fromJson(Map<String, dynamic> json) {
    return DriverWalletByIdData(
      driverTotalEarning: (json['driverTotalEarning'] as num).toDouble(),
      isMonthEarningSummary: MonthEarningSummary.fromJson(
        json['isMonthEarningSummary'],
      ),
      isMonthSummary: MonthSummary.fromJson(json['isMonthSummary']),
      fullYearData: (json['fullYearData'] as List)
          .map((e) => MonthlyRevenue.fromJson(e))
          .toList(),
      recentTrips: (json['recentTrips'] as List)
          .map((e) => RecentTrip.fromJson(e))
          .toList(),
    );
  }
}

class MonthEarningSummary {
  final String? id;
  final double gross;
  final double commission;
  final double net;

  MonthEarningSummary({
    this.id,
    required this.gross,
    required this.commission,
    required this.net,
  });

  factory MonthEarningSummary.fromJson(Map<String, dynamic> json) {
    return MonthEarningSummary(
      id: json['_id'],
      gross: (json['gross'] as num).toDouble(),
      commission: (json['commission'] as num).toDouble(),
      net: (json['net'] as num).toDouble(),
    );
  }
}

class MonthSummary {
  final int totalTrips;
  final double avgRating;

  MonthSummary({required this.totalTrips, required this.avgRating});

  factory MonthSummary.fromJson(Map<String, dynamic> json) {
    return MonthSummary(
      totalTrips: json['totalTrips'],
      avgRating: (json['avgRating'] as num).toDouble(),
    );
  }
}

class RecentTrip {
  final String id;
  final double tipAmount;
  final String status;
  final DateTime createdAt;
  final double estimatedMinutes;
  final String pickupAddress;
  final String dropOffAddress;
  final double distanceKm;

  RecentTrip({
    required this.id,
    required this.tipAmount,
    required this.status,
    required this.createdAt,
    required this.estimatedMinutes,
    required this.pickupAddress,
    required this.dropOffAddress,
    required this.distanceKm,
  });

  factory RecentTrip.fromJson(Map<String, dynamic> json) {
    return RecentTrip(
      id: json['_id'],
      tipAmount: (json['tipAmount'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      estimatedMinutes: (json['estimatedMinutes'] as num).toDouble(),
      pickupAddress: json['pickupAddress'],
      dropOffAddress: json['dropOffAddress'],
      distanceKm: (json['distanceKm'] as num).toDouble(),
    );
  }
}
