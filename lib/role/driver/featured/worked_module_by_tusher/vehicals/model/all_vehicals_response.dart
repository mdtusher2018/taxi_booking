import 'package:taxi_booking/core/model/pagenation_meta_model.dart';

class AllVehiclesResponse {
  final bool success;
  final int statusCode;
  final String message;
  final Meta meta;
  final List<Vehicle> data;

  AllVehiclesResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.meta,
    required this.data,
  });

  factory AllVehiclesResponse.fromJson(Map<String, dynamic> json) {
    return AllVehiclesResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      meta: Meta.fromJson(json['meta'] ?? {}),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Vehicle.fromJson(e))
          .toList(),
    );
  }
}

class Vehicle {
  final String id;
  final Photos photos;
  final VehicleOwner vehicleOwner;
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
    required this.vehicleOwner,
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
      id: json['_id'] ?? '',
      photos: Photos.fromJson(json['photos'] ?? {}),
      vehicleOwner: VehicleOwner.fromJson(json['vehicleOwnerId'] ?? {}),
      vehicleMake: json['vehicleMake'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      color: json['color'] ?? '',
      registrationNumber: json['registrationNumber'] ?? '',
      numberOfSeats: json['numberOfSeats'] ?? 0,
      rentStatus: json['rentStatus'] ?? '',
      category: json['category'] ?? '',
      registrationDocument: json['registrationDocument'] ?? '',
      technicalInspectionCertificate:
          json['technicalInspectionCertificate'] ?? '',
      insuranceDocument: json['insuranceDocument'] ?? '',
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      isAvailable: json['isAvailable'] ?? false,
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
      front: json['front'] ?? '',
      rear: json['rear'] ?? '',
      interior: json['interior'] ?? '',
    );
  }
}

class VehicleOwner {
  final String id;
  final User user;

  VehicleOwner({required this.id, required this.user});

  factory VehicleOwner.fromJson(Map<String, dynamic> json) {
    return VehicleOwner(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final Address address;
  final String driverLicenseNumber;

  User({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    required this.driverLicenseNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      driverLicenseNumber: json['driverLicenseNumber'] ?? '',
    );
  }
}

class Address {
  final String street;
  final String postalCode;
  final String city;
  final String country;

  Address({
    required this.street,
    required this.postalCode,
    required this.city,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      postalCode: json['postalCode'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
