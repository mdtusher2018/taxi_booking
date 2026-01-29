import 'package:taxi_booking/core/model/pagenation_meta_model.dart';
import 'package:taxi_booking/core/utilitis/api_data_praser_helper.dart';

class Coordinates {
  num latitude;
  num longitude;

  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(List<dynamic>? json) {
    return Coordinates(
      latitude: JsonHelper.doubleVal(json?.elementAt(1), fallback: 0.0),
      longitude: JsonHelper.doubleVal(json?.elementAt(0), fallback: 0.0),
    );
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

  factory Location.fromJson(dynamic json) {
    return Location(
      type: JsonHelper.stringVal(json?['type']),
      coordinates: Coordinates.fromJson(json?['coordinates'] as List<dynamic>?),
      address: JsonHelper.stringVal(json?['address']),
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

  factory Fare.fromJson(dynamic json) {
    return Fare(
      baseFare: JsonHelper.doubleVal(json?['baseFare']),
      distanceFare: JsonHelper.doubleVal(json?['distanceFare']),
      timeFare: JsonHelper.doubleVal(json?['timeFare']),
      surgeMultiplier: JsonHelper.doubleVal(
        json?['surgeMultiplier'],
        fallback: 1.0,
      ),
      totalFare: JsonHelper.doubleVal(json?['totalFare']),
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
  DateTime? createdAt;
  DateTime? updatedAt;

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

  factory Ride.fromJson(dynamic json) {
    return Ride(
      id: JsonHelper.stringVal(json?['_id']),
      pickupLocation: Location.fromJson(json?['pickupLocation']),
      dropOffLocation: Location.fromJson(json?['dropOffLocation']),
      fare: Fare.fromJson(json?['fare']),
      estimatedDistanceKm: JsonHelper.doubleVal(json?['estimatedDistanceKm']),
      estimatedDurationMin: JsonHelper.doubleVal(json?['estimatedDurationMin']),
      createdAt: JsonHelper.parseDate(json?['createdAt']),
      updatedAt: JsonHelper.parseDate(json?['updatedAt']),
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

  factory RideHistoryResponse.fromJson(dynamic json) {
    final data = json?['data'] ?? {};
    return RideHistoryResponse(
      success: JsonHelper.boolVal(json?['success']),
      statusCode: JsonHelper.intVal(json?['statusCode'], fallback: 200),
      message: JsonHelper.stringVal(json?['message']),
      meta: Meta.fromJson(data['meta']),
      result:
          (data['result'] as List<dynamic>?)
              ?.map((x) => Ride.fromJson(x))
              .toList() ??
          [],
    );
  }
}
