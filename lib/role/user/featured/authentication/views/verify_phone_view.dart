import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:taxi_booking/role/user/featured/authentication/controllers/authentication_controller.dart';
import 'package:taxi_booking/role/user/featured/authentication/controllers/validation_check_controller.dart';
import 'package:taxi_booking/role/user/featured/authentication/widget/auth_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_country_picker.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyPhoneView extends ConsumerWidget {
  const VerifyPhoneView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userAuthenticationProvider);
    final authController = ref.read(userAuthenticationProvider.notifier);

    final validationController = ref.read(validationProvider.notifier);
    final validationState = ref.watch(validationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: CommonStyle.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthAppBar(),
            const SizedBox(height: 15),

            CustomText(
              title: 'Phone Number Verify',
              style: CommonStyle.textStyleLarge(),
            ),

            const SizedBox(height: 10),

            CustomText(
              title:
                  'Please confirm your country code and enter your phone number :',
              style: CommonStyle.textStyleSmall(size: 14),
            ),

            const SizedBox(height: 20),

            CustomCountryPicker(
              defaultIsoCode: 'IE',
              titleText: 'Enter phone number',
              hintText: 'Enter number',
              controller: validationController.phoneController,
            ),

            SizedBox(height: MediaQuery.of(context).size.height / 16),

            CustomButton(
              title: 'Send Code',
              isLoading: authState.isLoading,
              onTap: () async {
                final phone = validationController.phoneController.text;

                log(phone);

                await authController.signup(
                  name: validationState.fullName,
                  email: validationState.email,
                  phoneNumber: phone,
                  gender: validationState.gender,
                  password: validationState.password,
                );

                if (!context.mounted) return;

                // Navigate to OTP screen if needed
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => const OtpView(),
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
