import 'package:taxi_booking/core/model/pagenation_meta_model.dart';

class MyDriversResponse {
  final bool success;
  final int statusCode;
  final String message;
  final Data data;

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
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final Meta meta;
  final List<Driver> result;

  Data({required this.meta, required this.result});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      meta: Meta.fromJson(json['meta']),
      result: List<Driver>.from(json['result'].map((x) => Driver.fromJson(x))),
    );
  }
}

class Driver {
  final String id;
  final String email;
  final String phone;
  final String role;
  final String provider;
  final bool isVerified;
  final bool isActive;
  final bool isDeleted;
  final bool isOnline;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;

  Driver({
    required this.id,
    required this.email,
    required this.phone,
    required this.role,
    required this.provider,
    required this.isVerified,
    required this.isActive,
    required this.isDeleted,
    required this.isOnline,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      provider: json['provider'],
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      isOnline: json['isOnline'] ?? false,
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String status;
  final String? activeVehicleId;
  final Address address;
  final DriverLicenseUploads? driverLicenseUploads;
  final IdentityUploads? identityUploads;
  final BusinessLicenseDetails? businessLicenseDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.status,
    this.activeVehicleId,
    required this.address,
    this.driverLicenseUploads,
    this.identityUploads,
    this.businessLicenseDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
      activeVehicleId: json['activeVehicleId'],
      address: Address.fromJson(json['address']),
      driverLicenseUploads:
          json['driverLicenseUploads'] != null
              ? DriverLicenseUploads.fromJson(json['driverLicenseUploads'])
              : null,
      identityUploads:
          json['identityUploads'] != null
              ? IdentityUploads.fromJson(json['identityUploads'])
              : null,
      businessLicenseDetails:
          json['businessLicenseDetails'] != null
              ? BusinessLicenseDetails.fromJson(json['businessLicenseDetails'])
              : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      street: json['street'],
      postalCode: json['postalCode'],
      city: json['city'],
      country: json['country'],
    );
  }
}

class DriverLicenseUploads {
  final String? driverLicenseFront;
  final String? driverLicenseBack;
  final String? driverPermitFront;
  final String? driverPermitBack;

  DriverLicenseUploads({
    this.driverLicenseFront,
    this.driverLicenseBack,
    this.driverPermitFront,
    this.driverPermitBack,
  });

  factory DriverLicenseUploads.fromJson(Map<String, dynamic> json) {
    return DriverLicenseUploads(
      driverLicenseFront: json['driverLicenseFront'],
      driverLicenseBack: json['driverLicenseBack'],
      driverPermitFront: json['driverPermitFront'],
      driverPermitBack: json['driverPermitBack'],
    );
  }
}

class IdentityUploads {
  final String? selfie;
  final String? idFront;
  final String? idBack;

  IdentityUploads({this.selfie, this.idFront, this.idBack});

  factory IdentityUploads.fromJson(Map<String, dynamic> json) {
    return IdentityUploads(
      selfie: json['selfie'],
      idFront: json['idFront'],
      idBack: json['idBack'],
    );
  }
}

class BusinessLicenseDetails {
  final String businessType;
  final String licenseNumber;
  final DateTime licenseExpiryDate;

  BusinessLicenseDetails({
    required this.businessType,
    required this.licenseNumber,
    required this.licenseExpiryDate,
  });

  factory BusinessLicenseDetails.fromJson(Map<String, dynamic> json) {
    return BusinessLicenseDetails(
      businessType: json['businessType'],
      licenseNumber: json['licenseNumber'],
      licenseExpiryDate: DateTime.parse(json['licenseExpiryDate']),
    );
  }
}
