import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideAcceptResponse {
  final String? rideId;
  final DriverInfo? driverInfo;

  RideAcceptResponse({this.rideId, this.driverInfo});

  // Converts JSON into a Ride object
  factory RideAcceptResponse.fromJson(Map<String, dynamic> json) {
    return RideAcceptResponse(
      rideId: json['rideId'] as String?,
      driverInfo:
          json['driverInfo'] != null
              ? DriverInfo.fromJson(json['driverInfo'])
              : null,
    );
  }

  // Converts Ride object to JSON
  Map<String, dynamic> toJson() {
    return {'rideId': rideId, 'driverInfo': driverInfo?.toJson()};
  }
}

class DriverInfo {
  final String? driverId;
  final String? name;
  final String? image;
  final String? email;
  final String? phone;
  final double? rating;
  final Location? location;
  final Vehicle? vehicle;

  DriverInfo({
    this.driverId,
    this.name,
    this.image,
    this.email,
    this.phone,
    this.rating,
    this.location,
    this.vehicle,
  });

  // Converts JSON into a DriverInfo object
  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      driverId: json['driverId'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
    );
  }

  // Converts DriverInfo object to JSON
  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'name': name,
      'image': image,
      'email': email,
      'phone': phone,
      'rating': rating,
      'location': location?.toJson(),
      'vehicle': vehicle?.toJson(),
    };
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;
  final String? address;

  Location({this.type, this.coordinates, this.address});

  // Converts JSON into a Location object
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String?,
      coordinates:
          json['coordinates'] != null
              ? List<double>.from(json['coordinates'])
              : null,
      address: json['address'] as String?,
    );
  }

  // Converts Location object to JSON
  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates, 'address': address};
  }
}

class Vehicle {
  final String? photo;
  final String? name;
  final String? model;

  Vehicle({this.photo, this.name, this.model});

  // Converts JSON into a Vehicle object
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      photo: json['photo'] as String?,
      name: json['name'] as String?,
      model: json['model'] as String?,
    );
  }

  // Converts Vehicle object to JSON
  Map<String, dynamic> toJson() {
    return {'photo': photo, 'name': name, 'model': model};
  }
}

//demo
class LocationSuggestion {
  final String name;
  final String address;
  final LatLng position;

  LocationSuggestion({
    required this.name,
    required this.address,
    required this.position,
  });
}
