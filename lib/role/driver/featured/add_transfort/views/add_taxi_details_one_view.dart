import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_drop_down_widget.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field_with_label.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/add_transfort/views/add_taxi_details_two_view.dart';



// ignore: must_be_immutable
class AddTaxiDetailsOneView extends StatelessWidget {
  AddTaxiDetailsOneView({super.key});

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController languageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Taxi Details'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal information',
              style: CommonStyle.textStyleLarge(size: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Only your first name and vehicle details are visible to clients during the booking',
              style: CommonStyle.textStyleSmall(size: 14),
            ),
            SizedBox(height: 20),

            /// input section
            CustomTextFieldWithLabel(
              label: 'First Name',
              hint: 'Enter your first name',
              controller: firstnameController,
            ),
            CustomTextFieldWithLabel(
              label: 'Last Name',
              hint: 'Enter your last name',
              controller: lastnameController,
            ),

            SizedBox(height: 10),
            Text('Language', style: CommonStyle.textStyleMedium(size: 16)),
            SizedBox(height: 10),
            CustomDropDownWidget(
              items: ['English', 'Hindi', 'Bengali', 'Spanish'],
              hintText: 'Select Language',
              onChanged: (value) {
                if (value != null) {
                  languageController.text = value;
                }
              },
            ),

            SizedBox(height: 20),
            CustomButton(
              title: 'Next',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaxiDetailsTwoView(),
                  ),
                );
              },
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
