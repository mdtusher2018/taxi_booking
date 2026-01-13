// ignore_for_file: must_be_immutable


import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_drop_down_widget.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field_with_label.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/add_transfort/widget/upload_kjoresed_image.dart';

class KjoreseddedInformationView extends StatelessWidget {
  KjoreseddedInformationView({super.key});

  TextEditingController kjoresedCharacter = TextEditingController();
  TextEditingController kjoresedHealth = TextEditingController();
  TextEditingController kjoresedage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Kjøresedded'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'kjøreseddel information',
              style: CommonStyle.textStyleLarge(size: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Kjøreseddel is confirmation that the driver has good character, good health and is 20 years of age',
              style: CommonStyle.textStyleSmall(size: 14),
            ),
            SizedBox(height: 20),

            /// input section
            Text(
              'Your Character',
              style: CommonStyle.textStyleMedium(size: 16),
            ),
            SizedBox(height: 5),
            CustomDropDownWidget(
              items: [
                'Professional Driver',
                'Friendly & Polite',
                'Safe & Reliable',
              ],
              hintText: 'Select Option',
              onChanged: (value) {
                if (value != null) {
                  kjoresedCharacter.text = value;
                }
              },
            ),

            SizedBox(height: 10),
            Text('Your Health', style: CommonStyle.textStyleMedium(size: 16)),
            SizedBox(height: 5),
            CustomDropDownWidget(
              items: ['Excellent', 'Good', 'Average', 'Below Average'],
              hintText: 'Select Option',
              onChanged: (value) {
                if (value != null) {
                  kjoresedHealth.text = value;
                }
              },
            ),

            CustomTextFieldWithLabel(
              label: 'Age',
              hint: 'Enter your age',
              controller: kjoresedage,
            ),
            Text(
              'Minimum age requirement: 20 years',
              style: CommonStyle.textStyleSmall(size: 12),
            ),

            /// upload section
            UploadKjoresedImage(),

            /// next button
            SizedBox(height: 20),
            CustomButton(
              title: 'Save',
              onTap: () {
                // MaterialPageRoute(
                //   builder: (context) => VerificationDocumentView(),
                // );
              },
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
