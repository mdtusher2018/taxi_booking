class DriverOnlineResponse {
  final bool success;
  final int statusCode;
  final String message;
  final LocationData data;

  DriverOnlineResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DriverOnlineResponse.fromJson(Map<String, dynamic> json) {
    return DriverOnlineResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'] ?? "",
      data: LocationData.fromJson(json['data'] ?? {}),
    );
  }
}

class LocationData {
  final CurrentLocation currentLocation;
  final String id;

  LocationData({required this.currentLocation, required this.id});

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      currentLocation: CurrentLocation.fromJson(json['currentLocation'] ?? {}),
      id: json['_id'] ?? "",
    );
  }
}

class CurrentLocation {
  final String type;
  final List<double> coordinates;
  final String address;

  CurrentLocation({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      type: json['type'] ?? "",
      coordinates: List<double>.from(json['coordinates'] ?? []),
      address: json['address'] ?? "",
    );
  }
}
