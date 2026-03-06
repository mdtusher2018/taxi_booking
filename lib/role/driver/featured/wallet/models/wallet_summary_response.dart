class WalletSummaryResponse {
  final bool success;
  final int statusCode;
  final String message;
  final WalletData data;

  WalletSummaryResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory WalletSummaryResponse.fromJson(Map<String, dynamic> json) {
    return WalletSummaryResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: WalletData.fromJson(json['data']),
    );
  }
}

class WalletData {
  final num totalRevenue;
  final num monthlyRevenue;
  final num monthlyGrowth;
  final int activeDrivers;
  final int totalTrips;
  final int newTrips;
  final int newDrivers;
  final num fleetUtilization;

  WalletData({
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.monthlyGrowth,
    required this.activeDrivers,
    required this.totalTrips,
    required this.newTrips,
    required this.newDrivers,
    required this.fleetUtilization,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      totalRevenue: json['totalRevenue'],
      monthlyRevenue: json['monthlyRevenue'],
      monthlyGrowth: json['monthlyGrowth'],
      activeDrivers: json['activeDrivers'],
      totalTrips: json['totalTrips'],
      newTrips: json['totalTrips'],
      newDrivers: json['newDrivers'],
      fleetUtilization: json['fleetUtilization'],
    );
  }
}
