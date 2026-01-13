import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_otp_widget.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/transport_selection_view.dart';
import '../widget/auth_app_bar.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key, required this.phoneNumber});
  final String? phoneNumber;

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  final otpController = List.generate(4, (index) => TextEditingController());

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
        setState(() {});
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
              title: 'Verification code was sent to',
              style: CommonStyle.textStyleSmall(size: 14),
            ),
            SizedBox(height: 20),

            if (widget.phoneNumber != null && widget.phoneNumber!.length > 5)
              Center(
                child: CustomButton(
                  width: MediaQuery.sizeOf(context).width / 2,
                  title: '${widget.phoneNumber!.substring(5)}****',
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
                        onTap: resendCode,
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
              title: 'Send Code',
              onTap: () {
                MaterialPageRoute(
                  builder: (context) => DriverTransportSelectionView(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
