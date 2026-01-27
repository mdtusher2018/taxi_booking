import 'dart:developer';
import 'dart:io';

import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/services/storage/i_local_storage_service.dart';
import 'package:taxi_booking/core/services/storage/storage_key.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/models/sign_in_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/models/signup_response.dart';

class AuthRepository extends Repository {
  final IApiService api;
  final ILocalStorageService localStorageService;
  AuthRepository({required this.api, required this.localStorageService});

  Future<Result<SignInResponse, Failure>> login(
    String phone,
    String password, {
    required bool rememberMe,
  }) {
    return asyncGuard(() async {
      final res = await api.post(DriverApiEndpoints.login, {
        "phone": phone,
        "password": password,
      });

      final response = SignInResponse.fromJson(res);

      if (response.success) {
        if (rememberMe) {
          localStorageService.disableSessionMode(false);
        }
        localStorageService.saveKey(StorageKey.rememberMe, rememberMe);
        localStorageService.saveKey(
          StorageKey.accessToken,
          response.data?.accessToken,
        );
        localStorageService.saveKey(
          StorageKey.refreshToken,
          response.data?.refreshToken,
        );
      }
      return response;
    });
  }

  Future<Result<SignupResponse, Failure>> signup({
    required Map<String, dynamic> data,
    required Map<String, File> files,
    required bool withCar,
  }) async {
    return asyncGuard(() async {
      log(data.toString());
      log(files.toString());

      final res = await api.multipart(
        (withCar)
            ? DriverApiEndpoints.signupWithCar
            : DriverApiEndpoints.signupWithoutCar,
        files: files,
        method: "POST",
        body: data,
      );
      return SignupResponse.fromJson(res);
    });
  }

  // Future<Result<EmailVerifiedResponse, Failure>> emailVerification(
  //   String otp,
  // ) async {
  //   return asyncGuard(() async {
  //     final res = await api.post(ApiEndpoints.emailVerification, {
  //       "otp": otp,
  //       "purpose": "email-verification",
  //     });

  //     return EmailVerifiedResponse.fromJson(res);
  //   });
  // }

  // Future<ForgotPasswordResponse> forgotPassword(String email) async {
  //   final res = await api.patch(ApiEndpoints.forgetPassword, {'email': email});
  //   return ForgotPasswordResponse.fromJson(res);
  // }

  // Future<OtpVerifiedResponse> otpVerification(String otp) async {
  //   final res = await api.post(ApiEndpoints.verifyOTP, {
  //     "otp": otp,
  //     "purpose": "forget-password",
  //   });

  //   return OtpVerifiedResponse.fromJson(res);
  // }
}
