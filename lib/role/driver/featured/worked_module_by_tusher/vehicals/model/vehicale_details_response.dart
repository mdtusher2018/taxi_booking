class VehicleResponse {
  bool success;
  int statusCode;
  String message;
  VehicleData data;

  VehicleResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) {
    return VehicleResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: VehicleData.fromJson(json['data']),
    );
  }
}

class VehicleData {
  String id;
  VehicleOwner vehicleOwner;
  String vehicleMake;
  String model;
  int year;
  String color;
  String category;
  String registrationNumber;
  int numberOfSeats;
  String rentStatus;
  String registrationDocument;
  String technicalInspectionCertificate;
  String insuranceDocument;
  bool isActive;
  bool isDeleted;
  String createdAt;
  String updatedAt;
  VehiclePhotos photos;
  bool isAvailable;

  VehicleData({
    required this.id,
    required this.vehicleOwner,
    required this.vehicleMake,
    required this.model,
    required this.year,
    required this.color,
    required this.category,
    required this.registrationNumber,
    required this.numberOfSeats,
    required this.rentStatus,
    required this.registrationDocument,
    required this.technicalInspectionCertificate,
    required this.insuranceDocument,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.photos,
    required this.isAvailable,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      id: json['_id'],
      vehicleOwner: VehicleOwner.fromJson(json['vehicleOwnerId']['user']),
      vehicleMake: json['vehicleMake'],
      model: json['model'],
      year: json['year'],
      color: json['color'],
      category: json["category"],
      registrationNumber: json['registrationNumber'],
      numberOfSeats: json['numberOfSeats'],
      rentStatus: json['rentStatus'],
      registrationDocument: json['registrationDocument'],
      technicalInspectionCertificate: json['technicalInspectionCertificate'],
      insuranceDocument: json['insuranceDocument'],
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      photos: VehiclePhotos.fromJson(json['photos']),
      isAvailable: json["isAvailable"] ?? false,
    );
  }
}

class VehicleOwner {
  String id;
  String fullName;
  String dateOfBirth;
  String nationalIdNumber;
  String phone;
  String email;
  Address address;
  String driverLicenseNumber;
  BusinessLicenseDetails businessLicenseDetails;
  String status;
  String bankAccountNumber;
  String accountHolderName;
  String accountBelongs;
  bool acceptedTerms;
  bool acceptedPrivacyPolicy;
  bool selfieConsent;
  String createdAt;
  String updatedAt;

  VehicleOwner({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.nationalIdNumber,
    required this.phone,
    required this.email,
    required this.address,
    required this.driverLicenseNumber,
    required this.businessLicenseDetails,
    required this.status,
    required this.bankAccountNumber,
    required this.accountHolderName,
    required this.accountBelongs,
    required this.acceptedTerms,
    required this.acceptedPrivacyPolicy,
    required this.selfieConsent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleOwner.fromJson(Map<String, dynamic> json) {
    return VehicleOwner(
      id: json['_id'],
      fullName: json['fullName'],
      dateOfBirth: json['dateOfBirth'],
      nationalIdNumber: json['nationalIdNumber'],
      phone: json['phone'],
      email: json['email'],
      address: Address.fromJson(json['address']),
      driverLicenseNumber: json['driverLicenseNumber'],
      businessLicenseDetails: BusinessLicenseDetails.fromJson(
        json['businessLicenseDetails'],
      ),
      status: json['status'],
      bankAccountNumber: json['bankAccountNumber'],
      accountHolderName: json['accountHolderName'],
      accountBelongs: json['accountBelongs'],
      acceptedTerms: json['acceptedTerms'],
      acceptedPrivacyPolicy: json['acceptedPrivacyPolicy'],
      selfieConsent: json['selfieConsent'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Address {
  String street;
  String postalCode;
  String city;
  String country;

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

class BusinessLicenseDetails {
  String businessType;
  String organizationNumber;
  String taxId;
  String? operatingLicenseDocument;
  String licenseNumber;
  String issuingMunicipality;
  String licenseExpiryDate;

  BusinessLicenseDetails({
    required this.businessType,
    required this.organizationNumber,
    required this.taxId,
    this.operatingLicenseDocument,
    required this.licenseNumber,
    required this.issuingMunicipality,
    required this.licenseExpiryDate,
  });

  factory BusinessLicenseDetails.fromJson(Map<String, dynamic> json) {
    return BusinessLicenseDetails(
      businessType: json['businessType'],
      organizationNumber: json['organizationNumber'],
      taxId: json['taxId'],
      operatingLicenseDocument: json['operatingLicenseDocument'],
      licenseNumber: json['licenseNumber'],
      issuingMunicipality: json['issuingMunicipality'],
      licenseExpiryDate: json['licenseExpiryDate'],
    );
  }
}

class VehiclePhotos {
  String front;
  String rear;
  String interior;

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
}
