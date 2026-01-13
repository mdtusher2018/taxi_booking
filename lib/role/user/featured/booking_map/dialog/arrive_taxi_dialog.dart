// arrived_dialog.dart
import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_images/app_images.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class ArrivedDialog extends StatelessWidget {
  const ArrivedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon or Image
            Image.asset(AppImages.arriveTaxiImage, height: 100, width: 100),
            const SizedBox(height: 16),

            // Title
            Text(
              'Your Taxi Has Arrived!!',
              style: CommonStyle.textStyleMedium(
                size: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),

            // Message
            Text(
              'The taxi driver has already arrived at your location. '
              'Please get ready and head downstairs shortly.',
              textAlign: TextAlign.center,
              style: CommonStyle.textStyleSmall(
                size: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Got it Button
            CustomButton(
              paddingVertical: 8,
              onTap: () {
                Navigator.pop(context);

                // Get.to(() => PayNowView());
              },
              title: 'Got it',
            ),
          ],
        ),
      ),
    );
  }
}
