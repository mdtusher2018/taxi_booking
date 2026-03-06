import 'dart:io';

class SignupForm {
  // Page 1 - Basic info
  String fullName = '';
  String email = '';
  String dateOfBirth = '';
  String street = '';
  String postalCode = '';
  String city = '';
  String country = '';
  String nationalIdNumber = '';
  String phone = '';
  String password = '';

  // Page 2 - Driving / business info
  String driverLicenseNumber = '';
  String? personalId;
  String? licenseExpiryDate;
  String? businessType;
  String? organizationNumber;
  String? taxId;
  String? licenseNumber;
  String? issuingMunicipality;

  // Page 3 - Documents
  File? driverLicenseFront;
  File? driverLicenseBack;
  File? driverPermitFront;
  File? driverPermitBack;
  File? selfie;
  File? idFront;
  File? idBack;

  File? operatingLicenseDocument;
  File? commercialInsuranceCertificate;
  File? companyRegistrationCertificate;

  bool withCar = false;
}
