// class RideRequestResponse {
//   final RideInfo rideInfo;
//   final PassengerInfo passengerInfo;

//   RideRequestResponse({required this.rideInfo, required this.passengerInfo});

//   factory RideRequestResponse.fromJson(Map<String, dynamic> json) {
//     return RideRequestResponse(
//       rideInfo: RideInfo.fromJson(json['rideInfo']),
//       passengerInfo: PassengerInfo.fromJson(json['passengerInfo']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'rideInfo': rideInfo.toJson(),
//       'passengerInfo': passengerInfo.toJson(),
//     };
//   }
// }

// // Ride Info
// class RideInfo {
//   final String id;
//   final Fare fare;
//   final double estimatedDistanceKm;
//   final double estimatedDurationMin;
//   final Location pickupLocation;
//   final Location dropOffLocation;

//   RideInfo({
//     required this.id,
//     required this.fare,
//     required this.estimatedDistanceKm,
//     required this.estimatedDurationMin,
//     required this.pickupLocation,
//     required this.dropOffLocation,
//   });

//   factory RideInfo.fromJson(Map<String, dynamic> json) {
//     return RideInfo(
//       id: json['id'],
//       fare: Fare.fromJson(json['fare']),
//       estimatedDistanceKm: (json['estimatedDistanceKm'] as num).toDouble(),
//       estimatedDurationMin: (json['estimatedDurationMin'] as num).toDouble(),
//       pickupLocation: Location.fromJson(json['pickupLocation']),
//       dropOffLocation: Location.fromJson(json['dropOffLocation']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'fare': fare.toJson(),
//       'estimatedDistanceKm': estimatedDistanceKm,
//       'estimatedDurationMin': estimatedDurationMin,
//       'pickupLocation': pickupLocation.toJson(),
//       'dropOffLocation': dropOffLocation.toJson(),
//     };
//   }
// }

// // Fare
// class Fare {
//   final double baseFare;
//   final double distanceFare;
//   final double timeFare;
//   final double surgeMultiplier;
//   final double totalFare;

//   Fare({
//     required this.baseFare,
//     required this.distanceFare,
//     required this.timeFare,
//     required this.surgeMultiplier,
//     required this.totalFare,
//   });

//   factory Fare.fromJson(Map<String, dynamic> json) {
//     return Fare(
//       baseFare: (json['baseFare'] as num).toDouble(),
//       distanceFare: (json['distanceFare'] as num).toDouble(),
//       timeFare: (json['timeFare'] as num).toDouble(),
//       surgeMultiplier: (json['surgeMultiplier'] as num).toDouble(),
//       totalFare: (json['totalFare'] as num).toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'baseFare': baseFare,
//       'distanceFare': distanceFare,
//       'timeFare': timeFare,
//       'surgeMultiplier': surgeMultiplier,
//       'totalFare': totalFare,
//     };
//   }
// }

// // Location
// class Location {
//   final String type;
//   final List<double> coordinates;
//   final String address;

//   Location({
//     required this.type,
//     required this.coordinates,
//     required this.address,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       type: json['type'],
//       coordinates: (json['coordinates'] as List)
//           .map((e) => (e as num).toDouble())
//           .toList(),
//       address: json['address'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {'type': type, 'coordinates': coordinates, 'address': address};
//   }
// }

// // Passenger Info
// class PassengerInfo {
//   final String id;
//   final String name;
//   final String? image;
//   final String phone;

//   PassengerInfo({
//     required this.id,
//     required this.name,
//     this.image,
//     required this.phone,
//   });

//   factory PassengerInfo.fromJson(Map<String, dynamic> json) {
//     return PassengerInfo(
//       id: json['id'],
//       name: json['name'] ?? 'Unnamed',
//       image: json['image'],
//       phone: json['phone'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {'id': id, 'name': name, 'image': image, 'phone': phone};
//   }
// }

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

  Map<String, dynamic> toJson() => {
    'rideInfo': rideInfo.toJson(),
    'passengerInfo': passengerInfo.toJson(),
    'referenceId': referenceId,
  };
}

class RideInfo {
  final String id;
  final Fare fare;
  final double estimatedDistanceKm;
  final double estimatedDurationMin;
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'fare': fare.toJson(),
    'estimatedDistanceKm': estimatedDistanceKm,
    'estimatedDurationMin': estimatedDurationMin,
    'pickupLocation': pickupLocation.toJson(),
    'dropOffLocation': dropOffLocation.toJson(),
  };
}

class Fare {
  final double baseFare;
  final double distanceFare;
  final double timeFare;
  final double surgeMultiplier;
  final double totalFare;

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

  Map<String, dynamic> toJson() => {
    'baseFare': baseFare,
    'distanceFare': distanceFare,
    'timeFare': timeFare,
    'surgeMultiplier': surgeMultiplier,
    'totalFare': totalFare,
  };
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'phone': phone,
  };
}
