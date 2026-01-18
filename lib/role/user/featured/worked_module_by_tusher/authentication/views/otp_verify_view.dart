// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/authentication/views/reset_password_view.dart';
import '../../../../../../resource/common_widget/custom_button.dart';
import '../../../../../../resource/common_widget/custom_otp_widget.dart';
import '../../../../../../resource/common_widget/custom_text.dart';
import '../../../../../../resource/utilitis/common_style.dart';

import '../widget/auth_app_bar.dart';

class OtpVerifyView extends StatelessWidget {
  OtpVerifyView({super.key});
  final otpController = List.generate(4, (index) => TextEditingController());

  bool enableResend = false;
  int secondsRemaining = 0;
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
              title: 'Verification',
              style: CommonStyle.textStyleLarge(),
            ),
            SizedBox(height: 10),
            CustomText(
              title: 'Please check your sms for create a new password',
              style: CommonStyle.textStyleSmall(size: 14),
            ),
            SizedBox(height: 20),

            Center(
              child: CustomButton(
                width: MediaQuery.sizeOf(context).width / 2,
                title: '+880 0156780****',
                onTap: () {},
              ),
            ),
            SizedBox(height: 20),
            CustomOtpWidget(
              controllers: otpController,
              numberOfFields: 4,
              borderColor: Colors.grey,
            ),

            /// TIMER SECTION
            SizedBox(height: 20),
            Center(
              child:
                  enableResend
                      ? CustomButton(
                        onTap: () {},
                        title: 'Resend Code',
                        buttonColor: Colors.white,
                        titleColor: AppColors.mainColor,
                        border: Border.all(color: AppColors.mainColor),
                        width: MediaQuery.sizeOf(context).width / 2,
                      )
                      : Text(
                        'Resend code in ${secondsRemaining}s',
                        style: CommonStyle.textStyleSmall(
                          size: 14,
                          color: Colors.grey,
                        ),
                      ),
            ),

            SizedBox(height: MediaQuery.sizeOf(context).height / 16),
            CustomButton(
              title: 'Submit',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
