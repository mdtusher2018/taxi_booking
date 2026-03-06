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
  final Photos photos;
  final String vehicleOwnerId;
  final String vehicleMake;
  final String model;
  final int year;
  final String color;
  final String registrationNumber;
  final int numberOfSeats;
  final String rentStatus;
  final String category;
  final String registrationDocument;
  final String technicalInspectionCertificate;
  final String insuranceDocument;
  final bool isActive;
  final bool isDeleted;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.photos,
    required this.vehicleOwnerId,
    required this.vehicleMake,
    required this.model,
    required this.year,
    required this.color,
    required this.registrationNumber,
    required this.numberOfSeats,
    required this.rentStatus,
    required this.category,
    required this.registrationDocument,
    required this.technicalInspectionCertificate,
    required this.insuranceDocument,
    required this.isActive,
    required this.isDeleted,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      photos: Photos.fromJson(json['photos']),
      vehicleOwnerId: json['vehicleOwnerId'],
      vehicleMake: json['vehicleMake'],
      model: json['model'],
      year: json['year'],
      color: json['color'],
      registrationNumber: json['registrationNumber'],
      numberOfSeats: json['numberOfSeats'],
      rentStatus: json['rentStatus'],
      category: json['category'],
      registrationDocument: json['registrationDocument'],
      technicalInspectionCertificate: json['technicalInspectionCertificate'],
      insuranceDocument: json['insuranceDocument'],
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      isAvailable: json['isAvailable'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      front: json['front'],
      rear: json['rear'],
      interior: json['interior'],
    );
  }
}
