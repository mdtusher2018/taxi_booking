class DriverCurrentLocation {
  final double latitude;
  final double longitude;

  DriverCurrentLocation({required this.latitude, required this.longitude});

  // Factory constructor for creating a DriverCurrentLocation from JSON
  factory DriverCurrentLocation.fromJson(Map<String, dynamic> json) {
    return DriverCurrentLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // Convert the DriverCurrentLocation instance to a map
  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}

class Distance {
  final num meters;
  final num km;
  final String text;
  final num etaMinutes;

  Distance({
    required this.meters,
    required this.km,
    required this.text,
    required this.etaMinutes,
  });

  // Factory constructor for creating a Distance from JSON
  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      meters: json['meters'],
      km: json['km'],
      text: json['text'],
      etaMinutes: json['etaMinutes'],
    );
  }

  // Convert the Distance instance to a map
  Map<String, dynamic> toJson() {
    return {'meters': meters, 'km': km, 'text': text, 'etaMinutes': etaMinutes};
  }
}

class DriverCurrentLocationResponse {
  final DriverCurrentLocation driverCurrentLocation;
  final Distance distance;

  DriverCurrentLocationResponse({
    required this.driverCurrentLocation,
    required this.distance,
  });

  // Factory constructor for creating a RideDetails from JSON
  factory DriverCurrentLocationResponse.fromJson(Map<String, dynamic> json) {
    return DriverCurrentLocationResponse(
      driverCurrentLocation: DriverCurrentLocation.fromJson(
        json['driverCurrentLocation'],
      ),
      distance: Distance.fromJson(json['distance']),
    );
  }

  // Convert the RideDetails instance to a map
  Map<String, dynamic> toJson() {
    return {
      'driverCurrentLocation': driverCurrentLocation.toJson(),
      'distance': distance.toJson(),
    };
  }
}
