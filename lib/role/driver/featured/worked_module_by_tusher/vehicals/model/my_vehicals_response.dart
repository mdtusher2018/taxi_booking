import 'package:taxi_booking/core/model/pagenation_meta_model.dart';

class MyVehiclesResponse {
  final bool success;
  final int statusCode;
  final String message;
  final Meta meta;
  final List<Vehicle> data;

  MyVehiclesResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.meta,
    required this.data,
  });

  factory MyVehiclesResponse.fromJson(Map<String, dynamic> json) {
    return MyVehiclesResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      meta: Meta.fromJson(json['data']['meta'] ?? {}),
      data: (json['data']['data'] as List<dynamic>? ?? [])
          .map((e) => Vehicle.fromJson(e))
          .toList(),
    );
  }
}

class Vehicle {
  final String id;
  final String vehicleMake;
  final String model;
  final int year;
  final String color;
  final String registrationNumber;
  final String rentStatus;
  final Photos photos;

  Vehicle({
    required this.id,
    required this.vehicleMake,
    required this.model,
    required this.year,
    required this.color,
    required this.registrationNumber,
    required this.rentStatus,
    required this.photos,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] ?? '',
      vehicleMake: json['vehicleMake'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      color: json['color'] ?? '',
      registrationNumber: json['registrationNumber'] ?? '',
      rentStatus: json['rentStatus'] ?? '',
      photos: Photos.fromJson(json['photos'] ?? {}),
    );
  }
}

class Photos {
  final String front;
  final String rear;
  final String interior;

  Photos({required this.front, required this.rear, required this.interior});

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
      front: json['front'] ?? '',
      rear: json['rear'] ?? '',
      interior: json['interior'] ?? '',
    );
  }
}
