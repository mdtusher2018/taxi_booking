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
  final String passengerId;
  final String? driverId;
  final String? vehicleId;
  final String? fleetOwnerId;
  final Location pickupLocation;
  final Location dropOffLocation;
  final String category;
  final String? note;
  final String status;
  final String? cancelledBy;
  final double estimatedDistanceKm;
  final double estimatedDurationMin;
  final Fare fare;
  final Payment payment;
  final bool forcedEndByAdmin;
  final String id;
  final List<dynamic> logs;

  RideData({
    required this.passengerId,
    this.driverId,
    this.vehicleId,
    this.fleetOwnerId,
    required this.pickupLocation,
    required this.dropOffLocation,
    required this.category,
    this.note,
    required this.status,
    this.cancelledBy,
    required this.estimatedDistanceKm,
    required this.estimatedDurationMin,
    required this.fare,
    required this.payment,
    required this.forcedEndByAdmin,
    required this.id,
    required this.logs,
  });

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      passengerId: json['passengerId'],
      driverId: json['driverId'],
      vehicleId: json['vehicleId'],
      fleetOwnerId: json['fleetOwnerId'],
      pickupLocation: Location.fromJson(json['pickupLocation']),
      dropOffLocation: Location.fromJson(json['dropOffLocation']),
      category: json['category'],
      note: json['note'],
      status: json['status'],
      cancelledBy: json['cancelledBy'],
      estimatedDistanceKm: (json['estimatedDistanceKm'] as num).toDouble(),
      estimatedDurationMin: (json['estimatedDurationMin'] as num).toDouble(),
      fare: Fare.fromJson(json['fare']),
      payment: Payment.fromJson(json['payment']),
      forcedEndByAdmin: json['forcedEndByAdmin'],
      id: json['_id'],
      logs: List<dynamic>.from(json['logs']),
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
      coordinates:
          (json['coordinates'] as List)
              .map((e) => (e as num).toDouble())
              .toList(),
      address: json['address'],
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
      baseFare: json['baseFare'],
      distanceFare: json['distanceFare'],
      timeFare: json['timeFare'],
      surgeMultiplier: json['surgeMultiplier'],
      totalFare: json['totalFare'],
    );
  }
}

class Payment {
  final String? method;
  final String? status;

  Payment({required this.method, required this.status});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(method: json['method'], status: json['status']);
  }
}
