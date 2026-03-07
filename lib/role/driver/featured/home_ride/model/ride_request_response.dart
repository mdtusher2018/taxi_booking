class RideRequestResponse {
  final RideInfo rideInfo;
  final PassengerInfo passengerInfo;
  final String? referenceId; // for "PnfidQS"

  RideRequestResponse({
    required this.rideInfo,
    required this.passengerInfo,
    this.referenceId,
  });

  factory RideRequestResponse.fromJson(Map<String, dynamic> json) {
    return RideRequestResponse(
      rideInfo: RideInfo.fromJson(json['rideInfo']),
      passengerInfo: PassengerInfo.fromJson(json['passengerInfo']),
      referenceId: json['referenceId'],
    );
  }
}

class RideInfo {
  final String id;
  final Fare fare;
  final num estimatedDistanceKm;
  final num estimatedDurationMin;
  final Location pickupLocation;
  final Location dropOffLocation;

  RideInfo({
    required this.id,
    required this.fare,
    required this.estimatedDistanceKm,
    required this.estimatedDurationMin,
    required this.pickupLocation,
    required this.dropOffLocation,
  });

  factory RideInfo.fromJson(Map<String, dynamic> json) {
    return RideInfo(
      id: json['id'],
      fare: Fare.fromJson(json['fare']),
      estimatedDistanceKm: (json['estimatedDistanceKm'] as num).toDouble(),
      estimatedDurationMin: (json['estimatedDurationMin'] as num).toDouble(),
      pickupLocation: Location.fromJson(json['pickupLocation']),
      dropOffLocation: Location.fromJson(json['dropOffLocation']),
    );
  }
}

class Fare {
  final num baseFare;
  final num distanceFare;
  final num timeFare;
  final num surgeMultiplier;
  final num totalFare;

  Fare({
    required this.baseFare,
    required this.distanceFare,
    required this.timeFare,
    required this.surgeMultiplier,
    required this.totalFare,
  });

  factory Fare.fromJson(Map<String, dynamic> json) {
    return Fare(
      baseFare: (json['baseFare'] as num).toDouble(),
      distanceFare: (json['distanceFare'] as num).toDouble(),
      timeFare: (json['timeFare'] as num).toDouble(),
      surgeMultiplier: (json['surgeMultiplier'] as num).toDouble(),
      totalFare: (json['totalFare'] as num).toDouble(),
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;
  final String address;

  Location({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: (json['coordinates'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': coordinates,
    'address': address,
  };
}

class PassengerInfo {
  final String id;
  final String name;
  final String? image;
  final String phone;

  PassengerInfo({
    required this.id,
    required this.name,
    this.image,
    required this.phone,
  });

  factory PassengerInfo.fromJson(Map<String, dynamic> json) {
    return PassengerInfo(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      phone: json['phone'],
    );
  }
}
