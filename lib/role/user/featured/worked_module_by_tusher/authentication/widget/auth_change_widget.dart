import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import '../../../../../../resource/common_widget/custom_button.dart';
import '../controllers/authentication_controller.dart';

class AuthChangeWidget extends ConsumerWidget {
  const AuthChangeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(userAuthenticationProvider.notifier);
    final state = ref.watch(userAuthenticationProvider);

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xffF4F5FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              title: 'Login',
              buttonColor:
                  state.selectedAuth == 'login'
                      ? AppColors.mainColor
                      : Colors.transparent,
              onTap: () {
                controller.toggleAuth('login');
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: 2,
              height: MediaQuery.sizeOf(context).height / 26,
              color: Colors.grey.shade300,
            ),
          ),
          Expanded(
            child: CustomButton(
              title: 'Sign up',
              buttonColor:
                  state.selectedAuth == 'signup'
                      ? AppColors.mainColor
                      : Colors.transparent,
              onTap: () {
                controller.toggleAuth('signup');
              },
            ),
          ),
        ],
      ),
    );
  }
}
