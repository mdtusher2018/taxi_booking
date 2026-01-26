class CreateRideResponse {
  final bool success;
  final int statusCode;
  final String message;
  final RideData data;

  CreateRideResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CreateRideResponse.fromJson(Map<String, dynamic> json) {
    return CreateRideResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: RideData.fromJson(json['data']),
    );
  }
}

class RideData {
  final String id;
  final String checkoutUrl;

  RideData({required this.id, required this.checkoutUrl});

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(id: json['rideId'], checkoutUrl: json['checkoutUrl']);
  }
}
