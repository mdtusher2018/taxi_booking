import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_images/app_images.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class AuthAppBar extends StatelessWidget {
  const AuthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: CommonStyle.paddingVerticalLarge,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          Expanded(
            child: Center(
              child: Image.asset(
                AppImages.authAppLogo,
                width: MediaQuery.sizeOf(context).width / 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
