import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_checkbox.dart';
import 'package:taxi_booking/resource/common_widget/custom_country_picker.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field_with_label.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/controller/auth_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/controller/signup_from_provider.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/models/sign_in_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/forgot_password_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/widget/auth_app_bar.dart';

import 'package:taxi_booking/core/routes/driver_app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

final _authModeProvider = StateProvider.family<bool, bool>((ref, initialValue) {
  return initialValue;
});

class DriverAuthenticationView extends ConsumerStatefulWidget {
  final bool isLoginPage;
  const DriverAuthenticationView({super.key, this.isLoginPage = true});

  @override
  ConsumerState<DriverAuthenticationView> createState() =>
      _AuthenticationViewState();
}

class _AuthenticationViewState extends ConsumerState<DriverAuthenticationView> {
  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? "password@!5" : null,
  );
  bool checkRemember = false;

  final TextEditingController fullNameController = TextEditingController(
    text: kDebugMode ? "md. tusher" : null,
  );
  final TextEditingController emailController = TextEditingController(
    text: kDebugMode ? "tusher@gmail.com" : null,
  );
  final TextEditingController dateOfBirthController = TextEditingController(
    text: kDebugMode ? "03/01/1995" : null,
  );
  final TextEditingController streetController = TextEditingController(
    text: kDebugMode ? "mohakhali" : null,
  );
  final TextEditingController postalController = TextEditingController(
    text: kDebugMode ? "1234" : null,
  );
  final TextEditingController cityController = TextEditingController(
    text: kDebugMode ? "Dhaka" : null,
  );
  final TextEditingController countryController = TextEditingController(
    text: kDebugMode ? "Bangladesh" : null,
  );
  final TextEditingController nationalIdController = TextEditingController(
    text: kDebugMode ? "123456789" : null,
  );
  final TextEditingController phoneNumberController = TextEditingController(
    text: kDebugMode ? "+8801646456521" : null,
  );
  // login
  final TextEditingController loginPhoneController = TextEditingController(
    text: kDebugMode ? "+8801933141861" : null,
  );
  final TextEditingController loginPasswordController = TextEditingController(
    text: kDebugMode ? "password@!5" : null,
  );

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);
    // Listen for changes to react
    ref.listen<AsyncValue<dynamic>>(authControllerProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data != null && data is SignInResponse) {
            // Success: show snackbar and navigate
            ref
                .watch(snackbarServiceProvider)
                .showSuccess("Login successful!", context: context);
            Future.microtask(() => context.push(DriverAppRoutes.dashboardView));
          }
        },
        loading: () {
          // Optional: show loading indicator if needed
        },
        error: (error, stackTrace) {
          ref
              .watch(snackbarServiceProvider)
              .showError(context: context, error.toString());
        },
      );
    });

    final authModeisLogin = ref.watch(_authModeProvider(widget.isLoginPage));
    final authModeController = ref.read(
      _authModeProvider(widget.isLoginPage).notifier,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: CommonStyle.paddingAllSmall,
          child: Column(
            children: [
              AuthAppBar(),
              SizedBox(height: 15),

              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xffF4F5FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: 'Login',
                        buttonColor: authModeisLogin
                            ? AppColors.mainColor
                            : Colors.transparent,
                        onTap: () {
                          authModeController.state = true;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 2,
                        height: MediaQuery.sizeOf(context).height / 26,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        title: 'Sign up',
                        buttonColor: !authModeisLogin
                            ? AppColors.mainColor
                            : Colors.transparent,
                        onTap: () {
                          authModeController.state = false;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              ///if selected login
              Visibility(
                visible: authModeisLogin,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: loginPhoneController,
                      prefixIcon: Icon(Icons.phone),
                      hint: 'Phone number',
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: loginPasswordController,
                      obscureText: true,
                      prefixIcon: Icon(Icons.lock_outline),
                      hint: 'Password',
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        CustomCheckBox(
                          size: 20,
                          isChecked: checkRemember,
                          onChanged: (value) {
                            checkRemember = value;
                          },
                        ),
                        SizedBox(width: 5),
                        CustomText(
                          title: 'Remember me',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordView(),
                            );
                          },
                          child: CustomText(
                            title: 'Forgot password',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      title: 'Next',
                      isLoading: authState.isLoading,
                      onTap: () async {
                        authController.login(
                          phone: loginPhoneController.text.trim(),
                          password: loginPasswordController.text.trim(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              ///if selected sign up
              Visibility(
                visible: !authModeisLogin,
                child: Column(
                  children: [
                    Text(
                      'Only your first name and vehicle details are visible to clients during the booking',
                      style: CommonStyle.textStyleSmall(size: 14),
                    ),
                    SizedBox(height: 20),

                    /// input section
                    CustomTextFieldWithLabel(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      controller: fullNameController,
                    ),

                    CustomTextFieldWithLabel(
                      label: 'Enter email',
                      hint: 'Enter your email address',
                      controller: emailController,
                    ),
                    Row(
                      children: [
                        Text(
                          'Phone number',
                          style: CommonStyle.textStyleMedium(),
                        ),
                      ],
                    ),

                    SizedBox(height: 5),
                    CustomCountryPicker(
                      defaultIsoCode: 'IE',
                      titleText: 'Enter phone number',
                      hintText: 'Enter number',
                      controller: phoneNumberController,
                      isLabelHidden: true,
                    ),
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(1995),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          dateOfBirthController.text =
                              "${pickedDate.day.toString().padLeft(2, '0')}/"
                              "${pickedDate.month.toString().padLeft(2, '0')}/"
                              "${pickedDate.year}";
                        }
                      },
                      child: AbsorbPointer(
                        child: CustomTextFieldWithLabel(
                          label: "Date of Birth",
                          hint: "DD/MM/YYYY",
                          controller: dateOfBirthController,
                          suffixIcon: Icon(Icons.calendar_month),
                        ),
                      ),
                    ),

                    CustomTextFieldWithLabel(
                      label: 'Street Address',
                      hint: 'e.g. 221B Baker Street',
                      controller: streetController,
                    ),

                    CustomTextFieldWithLabel(
                      label: 'Postal Code',
                      hint: 'e.g. 10001',
                      controller: postalController,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFieldWithLabel(
                            label: 'City',
                            hint: 'e.g. New York',
                            controller: cityController,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: CustomTextFieldWithLabel(
                            label: 'Country',
                            hint: 'e.g. USA',
                            controller: countryController,
                          ),
                        ),
                      ],
                    ),

                    CustomTextFieldWithLabel(
                      label: 'National ID',
                      hint: 'e.g. 1234567890',
                      subText:
                          "Your social security number or country\'s alternative (e.g. BVN)",
                      controller: nationalIdController,
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Password', style: CommonStyle.textStyleMedium()),
                      ],
                    ),

                    SizedBox(height: 5),

                    CustomTextField(
                      controller: passwordController,
                      hint: 'Password',
                      obscureText: true,
                    ),

                    SizedBox(height: 20),
                    CustomButton(title: 'Next', onTap: _moveNext),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _moveNext() {
    // Trim all text fields
    String fullName = fullNameController.text.trim();
    String email = emailController.text.trim();
    String dateOfBirth = dateOfBirthController.text.trim();
    String street = streetController.text.trim();
    String postal = postalController.text.trim();
    String city = cityController.text.trim();
    String country = countryController.text.trim();
    String nationalId = nationalIdController.text.trim();
    String phone = phoneNumberController.text.trim();
    String password = passwordController.text.trim();

    if (fullName.isEmpty) {
      CustomToast.showToast(message: 'Please enter your full name');
      return;
    }

    if (email.isEmpty) {
      CustomToast.showToast(message: 'Please enter your email', isError: true);
      return;
    } else if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email)) {
      CustomToast.showToast(
        message: 'Please enter a valid email address',
        isError: true,
      );
      return;
    }

    if (dateOfBirth.isEmpty) {
      CustomToast.showToast(
        message: 'Please enter your date of birth',
        isError: true,
      );
      return;
    }

    if (street.isEmpty) {
      CustomToast.showToast(
        message: 'Please enter your street address',
        isError: true,
      );
      return;
    }

    if (postal.isEmpty) {
      CustomToast.showToast(
        message: 'Please enter your postal code',
        isError: true,
      );
      return;
    }

    if (city.isEmpty) {
      CustomToast.showToast(message: 'Please enter your city', isError: true);
      return;
    }

    if (country.isEmpty) {
      CustomToast.showToast(
        message: 'Please enter your country',
        isError: true,
      );
      return;
    }

    if (nationalId.isEmpty) {
      CustomToast.showToast(
        message: 'Please enter your national ID',
        isError: true,
      );
      return;
    }

    if (phone.isEmpty) {
      CustomToast.showToast(
        message: 'Please enter your phone number',
        isError: true,
      );
      return;
    } else if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(phone)) {
      CustomToast.showToast(
        message: 'Please enter a valid phone number',
        isError: true,
      );
      return;
    }

    if (password.isEmpty) {
      CustomToast.showToast(
        message: 'Please enter your password',
        isError: true,
      );
      return;
    } else if (password.length < 6) {
      CustomToast.showToast(
        message: 'Password must be at least 6 characters',
        isError: true,
      );
      return;
    }

    final formNotifier = ref.read(signupFormProvider.notifier);
    formNotifier.updateBasicInfo(
      fullName: fullNameController.text,
      email: emailController.text,
      dateOfBirth: dateOfBirthController.text,
      street: streetController.text,
      postalCode: postalController.text,
      city: cityController.text,
      country: countryController.text,
      nationalIdNumber: nationalIdController.text,
      phone: phoneNumberController.text,
      password: passwordController.text,
    );
    context.push(DriverAppRoutes.transportSelectionView);
  }
}
