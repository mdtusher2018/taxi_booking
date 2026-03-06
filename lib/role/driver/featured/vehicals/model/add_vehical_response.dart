class AddVehicleResponse {
  final bool success;
  final int statusCode;
  final String message;
  final Vehicle data;

  AddVehicleResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AddVehicleResponse.fromJson(Map<String, dynamic> json) {
    return AddVehicleResponse(
      success: json['success'] as bool,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: Vehicle.fromJson(json['data']),
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
  final String registrationNumber;
  final int numberOfSeats;
  final VehiclePhotos photos;
  final String rentStatus;
  final String registrationDocument;
  final String technicalInspectionCertificate;
  final String insuranceDocument;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.vehicleOwnerId,
    required this.vehicleMake,
    required this.model,
    required this.year,
    required this.color,
    required this.registrationNumber,
    required this.numberOfSeats,
    required this.photos,
    required this.rentStatus,
    required this.registrationDocument,
    required this.technicalInspectionCertificate,
    required this.insuranceDocument,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      vehicleOwnerId: json['vehicleOwnerId'] ?? "",
      vehicleMake: json['vehicleMake'],
      model: json['model'],
      year: json['year'],
      color: json['color'],
      registrationNumber: json['registrationNumber'],
      numberOfSeats: json['numberOfSeats'],
      photos: VehiclePhotos.fromJson(json['photos']),
      rentStatus: json['rentStatus'],
      registrationDocument: json['registrationDocument'],
      technicalInspectionCertificate: json['technicalInspectionCertificate'],
      insuranceDocument: json['insuranceDocument'],
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vehicleOwnerId': vehicleOwnerId,
      'vehicleMake': vehicleMake,
      'model': model,
      'year': year,
      'color': color,
      'registrationNumber': registrationNumber,
      'numberOfSeats': numberOfSeats,
      'photos': photos.toJson(),
      'rentStatus': rentStatus,
      'registrationDocument': registrationDocument,
      'technicalInspectionCertificate': technicalInspectionCertificate,
      'insuranceDocument': insuranceDocument,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class VehiclePhotos {
  final String front;
  final String rear;
  final String interior;

  VehiclePhotos({
    required this.front,
    required this.rear,
    required this.interior,
  });

  factory VehiclePhotos.fromJson(Map<String, dynamic> json) {
    return VehiclePhotos(
      front: json['front'],
      rear: json['rear'],
      interior: json['interior'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'front': front, 'rear': rear, 'interior': interior};
  }
}
