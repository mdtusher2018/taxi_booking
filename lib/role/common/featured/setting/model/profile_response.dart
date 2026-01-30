import 'package:taxi_booking/core/utilitis/api_data_praser_helper.dart';
import 'package:taxi_booking/role/common/featured/setting/model/support_info_model.dart';

class ProfileResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ProfileData data;
  SupportInfoResponse? adminInfo;

  ProfileResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    this.adminInfo,
  });

  factory ProfileResponse.fromJson(dynamic json) {
    return ProfileResponse(
      success: JsonHelper.boolVal(json?['success']),
      statusCode: JsonHelper.intVal(json?['statusCode']),
      message: JsonHelper.stringVal(json?['message']),
      data: ProfileData.fromJson(json?['data']),
    );
  }
}

class ProfileData {
  final String id;
  final String role;
  final User user;

  ProfileData({required this.id, required this.role, required this.user});

  factory ProfileData.fromJson(dynamic json) {
    return ProfileData(
      id: JsonHelper.stringVal(json?['_id']),
      role: JsonHelper.stringVal(json?['role']),
      user: User.fromJson(json?['user'] ?? {}),
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
      id: JsonHelper.stringVal(json['_id']),
      fullName: JsonHelper.stringVal(
        json['fullName'] ?? json['fullname'],
        fallback: "Unnamed User",
      ),
      phone: JsonHelper.stringVal(json['phone'], fallback: "No number"),
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

  factory Address.fromJson(dynamic json) {
    return Address(
      street: JsonHelper.stringVal(json?['street']),
      postalCode: JsonHelper.stringVal(json?['postalCode']),
      city: JsonHelper.stringVal(json?['city']),
      country: JsonHelper.stringVal(json?['country']),
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

  factory DriverLicenseUploads.fromJson(dynamic json) {
    return DriverLicenseUploads(
      driverLicenseFront: JsonHelper.stringVal(json?['driverLicenseFront']),
      driverLicenseBack: JsonHelper.stringVal(json?['driverLicenseBack']),
      driverPermitFront: JsonHelper.stringVal(json?['driverPermitFront']),
      driverPermitBack: JsonHelper.stringVal(json?['driverPermitBack']),
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

  factory IdentityUploads.fromJson(dynamic json) {
    return IdentityUploads(
      selfie: JsonHelper.stringVal(json?['selfie']),
      idFront: JsonHelper.stringVal(json?['idFront']),
      idBack: JsonHelper.stringVal(json?['idBack']),
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

  factory BusinessLicenseDetails.fromJson(dynamic json) {
    return BusinessLicenseDetails(
      businessType: JsonHelper.stringVal(json?['businessType']),
      organizationNumber: JsonHelper.stringVal(json?['organizationNumber']),
      taxId: JsonHelper.stringVal(json?['taxId']),
      licenseNumber: JsonHelper.stringVal(json?['licenseNumber']),
      issuingMunicipality: JsonHelper.stringVal(json?['issuingMunicipality']),
      licenseExpiryDate: JsonHelper.stringVal(json?['licenseExpiryDate']),
      operatingLicenseDocument: JsonHelper.stringVal(
        json?['operatingLicenseDocument'],
      ),
      commercialInsuranceCertificate: JsonHelper.stringVal(
        json?['commercialInsuranceCertificate'],
      ),
      companyRegistrationCertificate: JsonHelper.stringVal(
        json?['companyRegistrationCertificate'],
      ),
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

  factory Location.fromJson(dynamic json) {
    List<double> coords = [];
    if (json?['coordinates'] is List) {
      coords = (json['coordinates'] as List)
          .map((e) => JsonHelper.doubleVal(e))
          .toList();
    }

    return Location(
      type: JsonHelper.stringVal(json?['type']),
      coordinates: coords,
      address: JsonHelper.stringVal(json?['address']),
    );
  }
}
