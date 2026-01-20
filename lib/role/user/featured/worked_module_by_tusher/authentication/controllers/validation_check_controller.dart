import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class ValidationState {
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String password;

  final int passwordStrength;
  final String passwordLabel;

  final String nameError;
  final String emailError;
  final String phoneError;
  final String passwordError;

  final bool isSubmitted;

  const ValidationState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.gender = '',
    this.password = '',
    this.passwordStrength = 0,
    this.passwordLabel = 'Weak',
    this.nameError = '',
    this.emailError = '',
    this.phoneError = '',
    this.passwordError = '',
    this.isSubmitted = false,
  });

  ValidationState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? gender,
    String? password,
    int? passwordStrength,
    String? passwordLabel,
    String? nameError,
    String? emailError,
    String? phoneError,
    String? passwordError,
    bool? isSubmitted,
  }) {
    return ValidationState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      passwordStrength: passwordStrength ?? this.passwordStrength,
      passwordLabel: passwordLabel ?? this.passwordLabel,
      nameError: nameError ?? this.nameError,
      emailError: emailError ?? this.emailError,
      phoneError: phoneError ?? this.phoneError,
      passwordError: passwordError ?? this.passwordError,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}

final validationProvider =
    StateNotifierProvider.autoDispose<ValidationNotifier, ValidationState>(
      (ref) => ValidationNotifier(),
    );

class ValidationNotifier extends StateNotifier<ValidationState> {
  ValidationNotifier() : super(const ValidationState());

  //================ Text Controllers =================

  final TextEditingController fullNameController = TextEditingController(
    text: kDebugMode ? "tusher" : null,
  );

  final TextEditingController emailController = TextEditingController(
    text: kDebugMode ? "number@gmail.com" : null,
  );

  final TextEditingController phoneController = TextEditingController(
    text: kDebugMode ? "+12314534123" : null,
  );

  final TextEditingController genderController = TextEditingController();

  final TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? "Hello123@" : null,
  );

  // login
  final TextEditingController loginPhoneController = TextEditingController(
    text: kDebugMode ? "+12314534125" : null,
  );

  final TextEditingController loginPasswordController = TextEditingController(
    text: kDebugMode ? "P@ssw0rd!" : null,
  );

  //================ Validators =================

  void validateFullName(String value) {
    final error = state.isSubmitted && value.length < 3
        ? 'Name must be at least 3 characters'
        : '';

    state = state.copyWith(fullName: value, nameError: error);
  }

  void validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    final error = state.isSubmitted && !emailRegex.hasMatch(value)
        ? 'Enter a valid email'
        : '';

    state = state.copyWith(email: value, emailError: error);
  }

  void validatePhone(String value) {
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

    final error = state.isSubmitted && !phoneRegex.hasMatch(value)
        ? 'Enter a valid phone'
        : '';

    state = state.copyWith(phone: value, phoneError: error);
  }

  void validateGender(String value) {
    state = state.copyWith(gender: value);
  }

  void checkPasswordStrength(String value) {
    int strength = 0;

    if (value.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength++;
    if (RegExp(r'[a-z]').hasMatch(value)) strength++;
    if (RegExp(r'\d').hasMatch(value)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) strength++;

    String label = 'Weak';
    if (strength <= 2) {
      label = 'Weak';
    } else if (strength <= 4) {
      label = 'Medium';
    } else {
      label = 'Strong';
    }

    final error = state.isSubmitted && value.length < 6
        ? 'Password must be at least 6 characters'
        : '';

    state = state.copyWith(
      password: value,
      passwordStrength: strength,
      passwordLabel: label,
      passwordError: error,
    );
  }

  //================ Validate All =================

  bool validateAllFields() {
    state = state.copyWith(isSubmitted: true);

    validateFullName(fullNameController.text);
    validateEmail(emailController.text);
    validatePhone(phoneController.text);
    checkPasswordStrength(passwordController.text);

    return state.nameError.isEmpty &&
        state.emailError.isEmpty &&
        state.passwordError.isEmpty;
  }

  //================ Dispose =================

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    genderController.dispose();
    passwordController.dispose();
    loginPhoneController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }
}
