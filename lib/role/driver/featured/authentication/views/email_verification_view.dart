import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/routes/driver_app_routes.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_otp_widget.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/authentication/controller/auth_controller.dart';
import '../widget/auth_app_bar.dart';

class EmailVerificationView extends ConsumerStatefulWidget {
  const EmailVerificationView({super.key, required this.phoneNumber});
  final String phoneNumber;

  @override
  ConsumerState<EmailVerificationView> createState() =>
      _EmailVerificationViewState();
}

class _EmailVerificationViewState extends ConsumerState<EmailVerificationView> {
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
    final controller = ref.read(authControllerProvider.notifier);
    final state = ref.watch(authControllerProvider);
    ref.listen<AsyncValue<dynamic>>(authControllerProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data != null && data is Map<String, bool>) {
            () => context.go(DriverAppRoutes.driverRoot);
          }
        },
        loading: () {
          // Optional: show loading indicator if needed
        },
        error: (error, stackTrace) {
          ref.watch(snackbarServiceProvider).showError(error.toString());
        },
      );
    });
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

            CustomOtpWidget(
              controllers: otpController,
              numberOfFields: 4,
              borderColor: Colors.grey,
            ),

            /// TIMER SECTION
            SizedBox(height: 20),

            CustomButton(
              title: 'Send Code',
              isLoading: state.isLoading,
              onTap: () {
                controller.otpVerification(
                  otp: otpController.map((e) => e.text).join(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
