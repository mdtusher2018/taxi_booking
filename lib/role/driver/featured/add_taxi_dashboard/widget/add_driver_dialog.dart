import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_images/app_images.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field.dart';

class AddDriverDialog extends StatelessWidget {
  const AddDriverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController driverIdController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Close icon
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ),

            const SizedBox(height: 8),

            /// Circle icon
            Image.asset(
              AppImages.addTaxiHeaderIcon,
              width: MediaQuery.sizeOf(context).width / 5,
            ),

            const SizedBox(height: 16),

            /// Title
            const Text(
              "Add a Driver to Your Taxi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            /// Subtitle
            const Text(
              "Please enter the driver ID number and assign the driver to your taxi.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            /// Input field
            CustomTextField(
              hint: "ID-abc_123_23",
              controller: driverIdController,
              prefixIcon: Icon(Icons.qr_code_scanner_sharp),
            ),

            const SizedBox(height: 24),

            /// Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                onTap: () {
                  // handle submit
                  Navigator.pop(context);
                },
                title: 'Add Driver',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
