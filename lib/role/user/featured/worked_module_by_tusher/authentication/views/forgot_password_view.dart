import 'package:flutter/material.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/authentication/views/otp_verify_view.dart';

import '../../../../../../resource/common_widget/custom_button.dart';
import '../../../../../../resource/common_widget/custom_country_picker.dart';
import '../../../../../../resource/common_widget/custom_text.dart';
import '../../../../../../resource/utilitis/common_style.dart';
import '../widget/auth_app_bar.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OtpVerifyView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
