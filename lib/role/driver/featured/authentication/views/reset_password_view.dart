import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import '../widget/auth_app_bar.dart';
import '../widget/password_strong_widget.dart';
import 'authentication_view.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  int secondsRemaining = 60;
  bool enableResend = false;
  Timer? _timer;

  void startTimer() {
    enableResend = false;
    secondsRemaining = 60;
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
      } else {
        enableResend = true;
        _timer?.cancel();
      }
    });
  }

  void resendCode() {
    // Here you can call your OTP resend API if needed
    startTimer();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  int passwordStrength = 0;
  String passwordLabel = 'Weak';
  String passwordError = '';

  bool isSubmitted = false; // NEW

  void checkPasswordStrength(String value) {
    if (isSubmitted) {
      passwordError =
          value.length < 6 ? 'Password must be at least 6 characters' : '';
    } else {
      passwordError = '';
    }

    int strength = 0;
    if (value.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength++;
    if (RegExp(r'[a-z]').hasMatch(value)) strength++;
    if (RegExp(r'\d').hasMatch(value)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) strength++;

    passwordStrength = strength;

    if (strength <= 2) {
      passwordLabel = 'Weak';
    } else if (strength <= 4) {
      passwordLabel = 'Medium';
    } else {
      passwordLabel = 'Strong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: CommonStyle.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthAppBar(),
            SizedBox(height: 15),
            CustomText(
              title: 'Change New Password!',
              style: CommonStyle.textStyleLarge(),
            ),
            SizedBox(height: 10),
            CustomText(
              title: 'Enter a different password with the previous!',
              style: CommonStyle.textStyleSmall(size: 14),
            ),
            SizedBox(height: 20),
            CustomTextField(
              hint: 'Enter new password',
              obscureText: true,
              prefixIcon: Icon(Icons.lock_outline),
            ),
            SizedBox(height: 20),
            CustomTextField(
              hint: 'Confirm new password',
              obscureText: true,
              prefixIcon: Icon(Icons.lock_outline),
              onChanged: (value) => checkPasswordStrength(value),
            ),
            SizedBox(height: 8),
            PasswordStrengthWidget(
              strength: passwordStrength,
              label: passwordLabel,
            ),

            SizedBox(height: MediaQuery.sizeOf(context).height / 16),
            CustomButton(
              title: 'Reset Password',
              onTap: () {
                CustomToast.showToast(message: 'Password reset successfully');
                MaterialPageRoute(
                  builder:
                      (context) => DriverAuthenticationView(isLoginPage: true),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
