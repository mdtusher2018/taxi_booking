import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taxi_booking/role/user/featured/authentication/views/forgot_password_view.dart';
import 'package:taxi_booking/role/user/featured/authentication/views/verify_phone_view.dart';
import 'package:taxi_booking/role/user/featured/authentication/widget/auth_app_bar.dart';
import 'package:taxi_booking/role/user/featured/authentication/widget/auth_change_widget.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_checkbox.dart';
import 'package:taxi_booking/resource/common_widget/custom_drop_down_widget.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';

import '../controllers/authentication_controller.dart';
import '../controllers/validation_check_controller.dart';
import '../widget/password_strong_widget.dart';

class UserAuthenticationView extends ConsumerStatefulWidget {
  const UserAuthenticationView({super.key, required this.isLoginPage});
  final bool isLoginPage;

  @override
  ConsumerState<UserAuthenticationView> createState() =>
      _AuthenticationViewState();
}

class _AuthenticationViewState extends ConsumerState<UserAuthenticationView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tab = widget.isLoginPage ? 'login' : 'signup';
      ref.read(userAuthenticationProvider.notifier).setInitialTab(tab);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(userAuthenticationProvider);
    final authController = ref.read(userAuthenticationProvider.notifier);

    final validationState = ref.watch(validationProvider);
    final validationController = ref.read(validationProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: CommonStyle.paddingAllSmall,
          child: Column(
            children: [
              AuthAppBar(),
              SizedBox(height: 15),
              AuthChangeWidget(),
              SizedBox(height: 15),

              ///if selected login
              Visibility(
                visible: authState.selectedAuth == 'login',
                child: Column(
                  children: [
                    CustomTextField(
                      controller: validationController.loginPhoneController,
                      prefixIcon: Icon(Icons.phone),
                      hint: 'Phone number',
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: validationController.loginPasswordController,
                      obscureText: true,
                      prefixIcon: Icon(Icons.lock_outline),
                      hint: 'Password',
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        CustomCheckBox(
                          size: 20,
                          isChecked: authState.rememberMe,
                          onChanged: (value) {
                            authController.toggleRemember(value);
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ForgotPasswordView();
                                },
                              ),
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
                        if (validationController
                            .loginPhoneController
                            .text
                            .isEmpty) {
                          CustomToast.showToast(
                            message: 'Please enter phone number',
                            isError: true,
                          );
                          return;
                        }
                        if (validationController
                            .loginPasswordController
                            .text
                            .isEmpty) {
                          CustomToast.showToast(
                            message: 'Please enter password',
                            isError: true,
                          );
                          return;
                        }
                        await authController.login(
                          phone: validationController.loginPhoneController.text,
                          password:
                              validationController.loginPasswordController.text,
                        );
                      },
                    ),
                  ],
                ),
              ),

              ///if selected sign up
              Visibility(
                visible: authState.selectedAuth == 'signup',
                child: Column(
                  children: [
                    CustomTextField(
                      controller: validationController.fullNameController,
                      prefixIcon: Icon(Icons.person),
                      hint: 'Full name',
                      onChanged: (value) =>
                          validationController.validateFullName(value),
                      errorText: validationState.nameError.isNotEmpty
                          ? validationState.nameError
                          : null,
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: validationController.emailController,
                      prefixIcon: Icon(Icons.email),
                      hint: 'Enter email',
                      onChanged: (value) =>
                          validationController.validateEmail(value),
                      errorText: validationState.emailError.isNotEmpty
                          ? validationState.emailError
                          : null,
                    ),

                    SizedBox(height: 8),
                    CustomDropDownWidget(
                      items: ['male', 'female', 'other'],
                      hintText: 'Gender',
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: validationController.passwordController,
                      prefixIcon: Icon(Icons.lock_outline),
                      hint: 'Password ...',
                      obscureText: true,
                      onChanged: (value) =>
                          validationController.checkPasswordStrength(value),
                      errorText: validationState.passwordError.isNotEmpty
                          ? validationState.passwordError
                          : null,
                    ),
                    SizedBox(height: 8),
                    PasswordStrengthWidget(
                      strength: validationState.passwordStrength,
                      label: validationState.passwordLabel,
                    ),

                    SizedBox(height: 20),
                    CustomButton(
                      title: 'Next',

                      onTap: () {
                        if (validationController.validateAllFields()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyPhoneView(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
