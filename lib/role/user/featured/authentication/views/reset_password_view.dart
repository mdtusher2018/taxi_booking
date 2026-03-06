import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/role/user/featured/authentication/views/authentication_view.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';

import '../../../../../resource/common_widget/custom_button.dart';
import '../../../../../resource/common_widget/custom_text.dart';
import '../../../../../resource/utilitis/common_style.dart';
import '../controllers/validation_check_controller.dart';
import '../widget/auth_app_bar.dart';
import '../widget/password_strong_widget.dart';

class ResetPasswordView extends ConsumerWidget {
  const ResetPasswordView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validationController = ref.read(validationProvider.notifier);
    final state = ref.read(validationProvider);

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
              onChanged: (value) =>
                  validationController.checkPasswordStrength(value),
            ),
            SizedBox(height: 8),
            PasswordStrengthWidget(
              strength: state.passwordStrength,
              label: state.passwordLabel,
            ),

            SizedBox(height: MediaQuery.sizeOf(context).height / 16),
            CustomButton(
              title: 'Reset Password',
              onTap: () {
                CustomToast.showToast(message: 'Password reset successfully');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserAuthenticationView(isLoginPage: true),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
