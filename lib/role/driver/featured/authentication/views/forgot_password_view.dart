import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_country_picker.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import '../widget/auth_app_bar.dart';
import 'otp_verify_view.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});
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
              title: 'Forget Password!',
              style: CommonStyle.textStyleLarge(),
            ),
            SizedBox(height: 10),
            CustomText(
              title: 'Enter your registered phone number below',
              style: CommonStyle.textStyleSmall(size: 14),
            ),
            SizedBox(height: 20),
            CustomCountryPicker(
              defaultIsoCode: 'IE',
              titleText: 'Enter phone number',
              hintText: 'Enter number',
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height / 16),
            CustomButton(
              title: 'Send Code',
              onTap: () {
                MaterialPageRoute(builder: (context) => OtpVerifyView());
              },
            ),
          ],
        ),
      ),
    );
  }
}
