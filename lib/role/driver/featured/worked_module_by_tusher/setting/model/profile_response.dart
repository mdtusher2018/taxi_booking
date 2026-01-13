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
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: ProfileData.fromJson(json['data']),
    );
  }
}

class ProfileData {
  final Verification emailVerification;
  final Verification phoneVerification;
  final String id;
  final String email;
  final String phone;
  final String role;
  final String provider;
  final UserProfile user;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileData({
    required this.emailVerification,
    required this.phoneVerification,
    required this.id,
    required this.email,
    required this.phone,
    required this.role,
    required this.provider,
    required this.user,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      emailVerification: Verification.fromJson(json['emailVerification']),
      phoneVerification: Verification.fromJson(json['phoneVerification']),
      id: json['_id'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      provider: json['provider'],
      user: UserProfile.fromJson(json['user']),
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Verification {
  final int? otp;
  final DateTime? expiresAt;
  final bool status;

  Verification({this.otp, this.expiresAt, required this.status});

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      otp: json['otp'],
      expiresAt:
          json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      status: json['status'] ?? false,
    );
  }
}

class UserProfile {
  final String id;
  final String fullName;
  final DateTime dateOfBirth;
  final String personalId;
  final String phone;
  final String email;
  final Address address;
  final String driverLicenseNumber;
  final DriverLicenseUploads driverLicenseUploads;
  final IdentityUploads identityUploads;
  final bool acceptedTerms;
  final bool acceptedPrivacyPolicy;
  final bool selfieConsent;
  final String status;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.personalId,
    required this.phone,
    required this.email,
    required this.address,
    required this.driverLicenseNumber,
    required this.driverLicenseUploads,
    required this.identityUploads,
    required this.acceptedTerms,
    required this.acceptedPrivacyPolicy,
    required this.selfieConsent,
    required this.status,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'],
      fullName: json['fullName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      personalId: json['personalId'],
      phone: json['phone'],
      email: json['email'],
      address: Address.fromJson(json['address']),
      driverLicenseNumber: json['driverLicenseNumber'],
      driverLicenseUploads: DriverLicenseUploads.fromJson(
        json['driverLicenseUploads'],
      ),
      identityUploads: IdentityUploads.fromJson(json['identityUploads']),
      acceptedTerms: json['acceptedTerms'],
      acceptedPrivacyPolicy: json['acceptedPrivacyPolicy'],
      selfieConsent: json['selfieConsent'],
      status: json['status'],
    );
  }
}

class Address {
  final String street;
  final String postalCode;
  final String city;
  final String country;
  final String id;

  Address({
    required this.street,
    required this.postalCode,
    required this.city,
    required this.country,
    required this.id,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      postalCode: json['postalCode'],
      city: json['city'],
      country: json['country'],
      id: json['_id'],
    );
  }
}

class DriverLicenseUploads {
  final String driverLicenseFront;
  final String driverLicenseBack;
  final String driverPermitFront;
  final String driverPermitBack;
  final String id;

  DriverLicenseUploads({
    required this.driverLicenseFront,
    required this.driverLicenseBack,
    required this.driverPermitFront,
    required this.driverPermitBack,
    required this.id,
  });

  factory DriverLicenseUploads.fromJson(Map<String, dynamic> json) {
    return DriverLicenseUploads(
      driverLicenseFront: json['driverLicenseFront'],
      driverLicenseBack: json['driverLicenseBack'],
      driverPermitFront: json['driverPermitFront'],
      driverPermitBack: json['driverPermitBack'],
      id: json['_id'],
    );
  }
}

class IdentityUploads {
  final String selfie;
  final String idFront;
  final String idBack;
  final String id;

  IdentityUploads({
    required this.selfie,
    required this.idFront,
    required this.idBack,
    required this.id,
  });

  factory IdentityUploads.fromJson(Map<String, dynamic> json) {
    return IdentityUploads(
      selfie: json['selfie'],
      idFront: json['idFront'],
      idBack: json['idBack'],
      id: json['_id'],
    );
  }
}
