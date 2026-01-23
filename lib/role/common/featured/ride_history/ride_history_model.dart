import 'package:taxi_booking/core/model/pagenation_meta_model.dart';

class Coordinates {
  num latitude;
  num longitude;

  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(List<dynamic> json) {
    return Coordinates(latitude: json[1], longitude: json[0]);
  }
}

class Location {
  String type;
  Coordinates coordinates;
  String address;

  Location({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: Coordinates.fromJson(json['coordinates'] ?? []),
      address: json['address'] ?? '',
    );
  }
}

class Fare {
  num baseFare;
  num distanceFare;
  num timeFare;
  num surgeMultiplier;
  num totalFare;

  Fare({
    required this.baseFare,
    required this.distanceFare,
    required this.timeFare,
    required this.surgeMultiplier,
    required this.totalFare,
  });

  factory Fare.fromJson(Map<String, dynamic> json) {
    return Fare(
      baseFare: json['baseFare'] ?? 0.0,
      distanceFare: json['distanceFare'] ?? 0.0,
      timeFare: json['timeFare'] ?? 0.0,
      surgeMultiplier: json['surgeMultiplier'] ?? 1.0,
      totalFare: json['totalFare'] ?? 0.0,
    );
  }
}

class Ride {
  String id;
  Location pickupLocation;
  Location dropOffLocation;
  Fare fare;
  num estimatedDistanceKm;
  num estimatedDurationMin;
  DateTime createdAt;
  DateTime updatedAt;

  Ride({
    required this.id,
    required this.pickupLocation,
    required this.dropOffLocation,
    required this.fare,
    required this.estimatedDistanceKm,
    required this.estimatedDurationMin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['_id'] ?? '',
      pickupLocation: Location.fromJson(json['pickupLocation'] ?? {}),
      dropOffLocation: Location.fromJson(json['dropOffLocation'] ?? {}),
      fare: Fare.fromJson(json['fare'] ?? {}),
      estimatedDistanceKm: json['estimatedDistanceKm'] ?? 0.0,
      estimatedDurationMin: json['estimatedDurationMin'] ?? 0.0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class RideHistoryResponse {
  bool success;
  int statusCode;
  String message;
  Meta meta;
  List<Ride> result;

  RideHistoryResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.meta,
    required this.result,
  });

  factory RideHistoryResponse.fromJson(Map<String, dynamic> json) {
    return RideHistoryResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      meta: Meta.fromJson(json['data']['meta'] ?? {}),
      result: List<Ride>.from(
        (json['data']['result'] ?? []).map((x) => Ride.fromJson(x)),
      ),
    );
  }
}
