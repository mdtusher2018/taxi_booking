import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_images/app_images.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/common_widget/lottie_loader.dart';
import '../../../../../../resource/utilitis/common_style.dart';

class TakeRewardViewView extends StatelessWidget {
  const TakeRewardViewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Reward Points',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Reward animation
            LottieLoaderWidget(
              lottieAssetPath: AppImages.takeReward,
              height: 200,
              width: 200,
            ),

            const SizedBox(height: 16),

            // Main reward message
            CustomText(
              title: 'You earned 3 points for this trip!',
              style: CommonStyle.textStyleMedium(size: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Description
            CustomText(
              title:
              'Thank you for riding with us. These points have been added to your account and can be redeemed for discounts or special offers.',
              style: CommonStyle.textStyleMedium(size: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Display total points earned
            CustomText(
              title: '3.0',
              style: CommonStyle.textStyleLarge(),
            ),

            const SizedBox(height: 20),

            // Take reward button
            CustomButton(
              title: 'Claim Reward',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
