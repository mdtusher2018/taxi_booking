import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/models/signup_from_model.dart';

class SignupFormNotifier extends StateNotifier<SignupForm> {
  SignupFormNotifier() : super(SignupForm());

  void updateBasicInfo({
    required String fullName,
    required String email,
    required String dateOfBirth,
    required String street,
    required String postalCode,
    required String city,
    required String country,
    required String nationalIdNumber,
    required String phone,
    required String password,
  }) {
    state =
        state
          ..fullName = fullName
          ..email = email
          ..dateOfBirth = dateOfBirth
          ..street = street
          ..postalCode = postalCode
          ..city = city
          ..country = country
          ..nationalIdNumber = nationalIdNumber
          ..phone = phone
          ..password = password;
  }

  void updateDrivingAndBusinessInfo({
    required String driverLicenseNumber,
    String? licenseExpiryDate,
    String? personalId,
    String? businessType,
    String? organizationNumber,
    String? taxId,
    String? licenseNumber,
    String? issuingMunicipality,
    required bool withCar,
  }) {
    state =
        state
          ..driverLicenseNumber = driverLicenseNumber
          ..licenseExpiryDate = licenseExpiryDate!
          ..personalId = personalId
          ..businessType = businessType
          ..organizationNumber = organizationNumber
          ..taxId = taxId
          ..licenseNumber = licenseNumber
          ..issuingMunicipality = issuingMunicipality
          ..withCar = withCar;
  }

  void updateDocuments({
    File? driverLicenseFront,
    File? driverLicenseBack,
    File? driverPermitFront,
    File? driverPermitBack,
    File? selfie,
    File? idFront,
    File? idBack,
    File? operatingLicenseDocument,
    File? commercialInsuranceCertificate,
    File? companyRegistrationCertificate,
  }) {
    state =
        state
          ..driverLicenseFront = driverLicenseFront
          ..driverLicenseBack = driverLicenseBack
          ..driverPermitFront = driverPermitFront
          ..driverPermitBack = driverPermitBack
          ..selfie = selfie
          ..idFront = idFront
          ..idBack = idBack
          ..operatingLicenseDocument = operatingLicenseDocument
          ..commercialInsuranceCertificate = commercialInsuranceCertificate
          ..companyRegistrationCertificate = companyRegistrationCertificate;
  }
}

final signupFormProvider =
    StateNotifierProvider<SignupFormNotifier, SignupForm>((ref) {
      return SignupFormNotifier();
    });
