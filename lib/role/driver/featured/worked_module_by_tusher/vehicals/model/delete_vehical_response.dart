class DeleteVehicleResponse {
  final bool success;
  final int statusCode;
  final String message;
  final VehicleData data;

  DeleteVehicleResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  // Factory constructor to parse the JSON response
  factory DeleteVehicleResponse.fromJson(Map<String, dynamic> json) {
    return DeleteVehicleResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: VehicleData.fromJson(json['data']),
    );
  }
}

class VehicleData {
  final bool isActive;
  final bool isDeleted;

  VehicleData({required this.isActive, required this.isDeleted});

  // Factory constructor to parse the nested data
  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
    );
  }
}
