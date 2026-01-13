import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/models/sign_in_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/models/signup_from_model.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/repository/auth_repository.dart';
part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  late final AuthRepository _repo;

  @override
  FutureOr<dynamic> build() {
    _repo = ref.watch(authRepositoryProvider);
    return null;
  }

  Future<void> login({required String phone, required String password}) async {
    state = AsyncLoading();

    final result = await _repo.login(phone, password);
    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      state = AsyncError(
        error.message,
        error.stackTrace ?? StackTrace.fromString("No trace found"),
      );
    } else if (result is Success) {
      state = AsyncData((result as Success).data as SignInResponse);
    }
    return;
  }

  Future<void> signup(SignupForm form, bool withCar) async {
    state = AsyncLoading();

    final result = await _repo.signup(
      withCar: withCar,
      data: {
        "fullName": form.fullName,
        "email": form.email,
        "dateOfBirth": form.dateOfBirth,
        "address": {
          "street": form.street,
          "postalCode": form.postalCode,
          "city": form.city,
          "country": form.country,
        },
        "nationalIdNumber": form.nationalIdNumber,
        "password": form.password,
        "phone": form.phone,
        "driverLicenseNumber": form.driverLicenseNumber,
        "personalId": form.personalId,
        "businessLicenseDetails":
            form.withCar
                ? {
                  "businessType": form.businessType,
                  "organizationNumber": form.organizationNumber,
                  "taxId": form.taxId,
                  "licenseNumber": form.licenseNumber,
                  "issuingMunicipality": form.issuingMunicipality,
                  "licenseExpiryDate": form.licenseExpiryDate,
                }
                : null,
        "bankAccountNumber": "ACC-XXXX", // Add if needed
        "accountHolderName": form.fullName,
        "accountBelongs": "driver",
        "acceptedTerms": true,
        "acceptedPrivacyPolicy": true,
        "selfieConsent": true,
      },
      files: {
        "driverLicenseFront": form.driverLicenseFront!,
        "driverLicenseBack": form.driverLicenseBack!,
        "driverPermitFront": form.driverPermitFront!,
        "driverPermitBack": form.driverPermitBack!,
        "selfie": form.selfie!,
        "idFront": form.idFront!,
        "idBack": form.idBack!,
        if (form.withCar) ...{
          "operatingLicenseDocument": form.operatingLicenseDocument!,
          "commercialInsuranceCertificate":
              form.commercialInsuranceCertificate!,
          "companyRegistrationCertificate":
              form.companyRegistrationCertificate!,
        },
      },
    );
    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      state = AsyncError(
        error.message,
        error.stackTrace ?? StackTrace.fromString("No trace found"),
      );
    } else if (result is Success) {
      state = AsyncData((result as Success).data as SignInResponse);
    }
    return;
  }
}
