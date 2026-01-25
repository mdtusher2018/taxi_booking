import 'package:taxi_booking/core/model/pagenation_meta_model.dart';

class MyDriversResponse {
  final bool success;
  final int statusCode;
  final String message;
  final AssignedDriversData data;

  MyDriversResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory MyDriversResponse.fromJson(Map<String, dynamic> json) {
    return MyDriversResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: AssignedDriversData.fromJson(json['data']),
    );
  }
}

class AssignedDriversData {
  final Meta meta;
  final List<AssignedDriver> result;

  AssignedDriversData({required this.meta, required this.result});

  factory AssignedDriversData.fromJson(Map<String, dynamic> json) {
    return AssignedDriversData(
      meta: Meta.fromJson(json['meta']),
      result: (json['result'] as List)
          .map((e) => AssignedDriver.fromJson(e))
          .toList(),
    );
  }
}

class AssignedDriver {
  final String id;
  final AssignedBy assignedBy;
  final Vehicle vehicleId;
  final Driver driverId;
  final DateTime assignedAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssignedDriver({
    required this.id,
    required this.assignedBy,
    required this.vehicleId,
    required this.driverId,
    required this.assignedAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssignedDriver.fromJson(Map<String, dynamic> json) {
    return AssignedDriver(
      id: json['_id'],
      assignedBy: AssignedBy.fromJson(json['assignedBy']),
      vehicleId: Vehicle.fromJson(json['vehicleId']),
      driverId: Driver.fromJson(json['driverId']),
      assignedAt: DateTime.parse(json['assignedAt']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class AssignedBy {
  final String id;
  final String role;
  final UserData user;

  AssignedBy({required this.id, required this.role, required this.user});

  factory AssignedBy.fromJson(Map<String, dynamic> json) {
    return AssignedBy(
      id: json['_id'],
      role: json['role'],
      user: UserData.fromJson(json['user']),
    );
  }
}

class Driver {
  final String id;
  final String role;
  final UserData user;

  Driver({required this.id, required this.role, required this.user});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'],
      role: json['role'],
      user: UserData.fromJson(json['user']),
    );
  }
}

class UserData {
  final String id;
  final String phone;
  final String email;
  final String status;

  UserData({
    required this.id,
    required this.phone,
    required this.email,
    required this.status,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      phone: json['phone'],
      email: json['email'],
      status: json['status'],
    );
  }
}

class Vehicle {
  final String id;
  final String vehicleOwnerId;
  final String vehicleMake;
  final String model;
  final int year;
  final String color;
  final int numberOfSeats;
  final bool isActive;
  final VehiclePhotos photos;

  Vehicle({
    required this.id,
    required this.vehicleOwnerId,
    required this.vehicleMake,
    required this.model,
    required this.year,
    required this.color,
    required this.numberOfSeats,
    required this.isActive,
    required this.photos,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      vehicleOwnerId: json['vehicleOwnerId'],
      vehicleMake: json['vehicleMake'],
      model: json['model'],
      year: json['year'],
      color: json['color'],
      numberOfSeats: json['numberOfSeats'],
      isActive: json['isActive'],
      photos: VehiclePhotos.fromJson(json['photos']),
    );
  }
}

class VehiclePhotos {
  final String? front;
  final String? rear;
  final String? interior;

  VehiclePhotos({this.front, this.rear, this.interior});

  factory VehiclePhotos.fromJson(Map<String, dynamic> json) {
    return VehiclePhotos(
      front: json['front'],
      rear: json['rear'],
      interior: json['interior'],
    );
  }
}
