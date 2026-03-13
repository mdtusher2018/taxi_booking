// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/role/user/featured/authentication/controllers/authentication_controller.dart';
import '../../../../../resource/common_widget/custom_button.dart';
import '../../../../../resource/common_widget/custom_otp_widget.dart';
import '../../../../../resource/common_widget/custom_text.dart';
import '../../../../../resource/utilitis/common_style.dart';

import '../widget/auth_app_bar.dart';

class OtpVerifyView extends ConsumerWidget {
  OtpVerifyView({super.key});
  final otpController = List.generate(4, (index) => TextEditingController());

  bool enableResend = false;
  int secondsRemaining = 0;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              title: 'Verification',
              style: CommonStyle.textStyleLarge(),
            ),
            SizedBox(height: 10),
            CustomText(
              title:
                  'Please check your sms inbox, we have sent you the OTP to verify your phone number.',
              style: CommonStyle.textStyleSmall(size: 14),
            ),
            SizedBox(height: 20),

            CustomOtpWidget(
              controllers: otpController,
              numberOfFields: 4,
              borderColor: Colors.grey,
            ),

            /// TIMER SECTION
            SizedBox(height: 20),

            SizedBox(height: MediaQuery.sizeOf(context).height / 16),
            CustomButton(
              title: 'Submit',
              isLoading: ref.watch(userAuthenticationProvider).isLoading,
              onTap: () {
                ref
                    .read(userAuthenticationProvider.notifier)
                    .verifyOtp(
                      otp: otpController.map((e) => e.text).join(),
                      context: context,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
