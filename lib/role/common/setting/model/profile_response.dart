class ProfileResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ProfileData data;

  ProfileResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: ProfileData.fromJson(json['data']),
    );
  }
}

class ProfileData {
  final String id;
  final String role;
  final User user;

  ProfileData({required this.id, required this.role, required this.user});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['_id'],
      role: json['role'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String? status;
  final String? dateOfBirth;
  final String? nationalIdNumber;
  final String? driverLicenseNumber;
  final String? fcmToken;
  final Address? address;
  final DriverLicenseUploads? driverLicenseUploads;
  final IdentityUploads? identityUploads;
  final BusinessLicenseDetails? businessLicenseDetails;
  final String? bankAccountNumber;
  final String? accountHolderName;
  final String? accountBelongs;
  final bool? acceptedTerms;
  final bool? acceptedPrivacyPolicy;
  final bool? selfieConsent;
  final Location? currentLocation;
  final String? activeVehicleId;

  User({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.status,
    this.dateOfBirth,
    this.nationalIdNumber,
    this.driverLicenseNumber,
    this.fcmToken,
    required this.address,
    this.driverLicenseUploads,
    this.identityUploads,
    this.businessLicenseDetails,
    this.bankAccountNumber,
    this.accountHolderName,
    this.accountBelongs,
    required this.acceptedTerms,
    required this.acceptedPrivacyPolicy,
    required this.selfieConsent,
    this.currentLocation,
    this.activeVehicleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['fullName'] ?? json['fullname'] ?? "Unnamed User",
      phone: json['phone'],
      email: json['email'],
      status: json['status'],
      dateOfBirth: json['dateOfBirth'],
      nationalIdNumber: json['nationalIdNumber'],
      driverLicenseNumber: json['driverLicenseNumber'],
      fcmToken: json['fcmToken'],
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address']),
      driverLicenseUploads: json['driverLicenseUploads'] != null
          ? DriverLicenseUploads.fromJson(json['driverLicenseUploads'])
          : null,
      identityUploads: json['identityUploads'] != null
          ? IdentityUploads.fromJson(json['identityUploads'])
          : null,
      businessLicenseDetails: json['businessLicenseDetails'] != null
          ? BusinessLicenseDetails.fromJson(json['businessLicenseDetails'])
          : null,
      bankAccountNumber: json['bankAccountNumber'],
      accountHolderName: json['accountHolderName'],
      accountBelongs: json['accountBelongs'],
      acceptedTerms: json['acceptedTerms'],
      acceptedPrivacyPolicy: json['acceptedPrivacyPolicy'],
      selfieConsent: json['selfieConsent'],
      currentLocation: json['currentLocation'] != null
          ? Location.fromJson(json['currentLocation'])
          : null,
      activeVehicleId: json['activeVehicleId'],
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
  final String driverLicenseFront;
  final String driverLicenseBack;
  final String driverPermitFront;
  final String driverPermitBack;

  DriverLicenseUploads({
    required this.driverLicenseFront,
    required this.driverLicenseBack,
    required this.driverPermitFront,
    required this.driverPermitBack,
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
  final String selfie;
  final String idFront;
  final String idBack;

  IdentityUploads({
    required this.selfie,
    required this.idFront,
    required this.idBack,
  });

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
  final String organizationNumber;
  final String taxId;
  final String licenseNumber;
  final String issuingMunicipality;
  final String licenseExpiryDate;
  final String? operatingLicenseDocument;
  final String? commercialInsuranceCertificate;
  final String? companyRegistrationCertificate;

  BusinessLicenseDetails({
    required this.businessType,
    required this.organizationNumber,
    required this.taxId,
    required this.licenseNumber,
    required this.issuingMunicipality,
    required this.licenseExpiryDate,
    this.operatingLicenseDocument,
    this.commercialInsuranceCertificate,
    this.companyRegistrationCertificate,
  });

  factory BusinessLicenseDetails.fromJson(Map<String, dynamic> json) {
    return BusinessLicenseDetails(
      businessType: json['businessType'],
      organizationNumber: json['organizationNumber'],
      taxId: json['taxId'],
      licenseNumber: json['licenseNumber'],
      issuingMunicipality: json['issuingMunicipality'],
      licenseExpiryDate: json['licenseExpiryDate'],
      operatingLicenseDocument: json['operatingLicenseDocument'],
      commercialInsuranceCertificate: json['commercialInsuranceCertificate'],
      companyRegistrationCertificate: json['companyRegistrationCertificate'],
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
      coordinates: List<double>.from(json['coordinates']),
      address: json['address'],
    );
  }
}
