import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/core/routes/user_app_routes.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/services/storage/i_local_storage_service.dart';
import 'package:taxi_booking/core/services/storage/storage_key.dart';
import 'package:taxi_booking/core/utilitis/user_api_end_points.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/authentication/models/sign_in_response.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/authentication/models/signup_response.dart';

class AuthenticationState {
  final String selectedAuth;
  final bool rememberMe;
  final bool isLoading;

  const AuthenticationState({
    this.selectedAuth = 'login',
    this.rememberMe = false,
    this.isLoading = false,
  });

  AuthenticationState copyWith({
    String? selectedAuth,
    bool? rememberMe,
    bool? isLoading,
  }) {
    return AuthenticationState(
      selectedAuth: selectedAuth ?? this.selectedAuth,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final userAuthenticationProvider =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationState>(
      (ref) => AuthenticationNotifier(
        apiService: ref.read(apiServiceProvider),
        localStorage: ref.read(localStorageServiceProvider),
      ),
    );

class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  AuthenticationNotifier({required this.apiService, required this.localStorage})
    : super(const AuthenticationState());

  final IApiService apiService;
  final ILocalStorageService localStorage;

  //================ UI STATE =================

  void toggleAuth(String auth) {
    state = state.copyWith(selectedAuth: auth);
  }

  void toggleRemember(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  void setInitialTab(String tab) {
    state = state.copyWith(selectedAuth: tab);
  }

  //================ LOGIN =================

  Future<void> login({
    required String phone,
    required String password,
    required BuildContext context,
  }) async {
    try {
      state = state.copyWith(isLoading: true);

      final body = {"phone": phone, "password": password};
      final response = await apiService.post(UserApiEndpoints.login, body);
      final loginResponse = SignInResponse.fromJson(response);

      if (loginResponse.statusCode == 200 && loginResponse.data != null) {
        final token = loginResponse.data!.accessToken;
        await localStorage.saveKey(StorageKey.accessToken, token);
        context.go(UserAppRoutes.rootView);
      } else {
        CustomToast.showToast(message: loginResponse.message, isError: true);
      }
    } catch (e) {
      AppLogger.e(e.toString());
      CustomToast.showToast(message: e.toString(), isError: true);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  //================ SIGNUP =================

  Future<void> signup({
    required String name,
    required String email,
    required String phoneNumber,
    required String gender,
    required String password,
    String role = "user",
  }) async {
    try {
      state = state.copyWith(isLoading: true);

      final body = {
        "fullname": name,
        "email": email,
        "phone": phoneNumber,
        "password": password,
        "role": role,
      };
      log(body.toString());

      final response = await apiService.post(UserApiEndpoints.signup, body);
      final signupResponse = SignupResponse.fromJson(response);

      if (signupResponse.statusCode == 201) {
        final token = signupResponse.data.sendOtp.token;
        await localStorage.saveKey(StorageKey.accessToken, token);
      } else {
        throw Exception(signupResponse.message);
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
