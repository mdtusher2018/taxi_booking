

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_drop_down_widget.dart';
import 'package:taxi_booking/resource/common_widget/custom_switch_widget.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field_with_label.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/add_transfort/views/kjoresedded_information_view.dart';
import 'package:taxi_booking/role/driver/featured/add_transfort/widget/upload_taxi_image_widget.dart';

class AddTaxiDetailsTwoView extends StatelessWidget {
  AddTaxiDetailsTwoView({super.key});

  TextEditingController joinAsController = TextEditingController();
  TextEditingController vehicleBrandNameController = TextEditingController();
  TextEditingController vehicleTransportLicenseNumberController =
      TextEditingController();
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController vehicleYearController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextEditingController? vehicleManufacturerModelController;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Taxi Details'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Legal and pricing details',
              style: CommonStyle.textStyleLarge(size: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Your national ID and license details will be kept private.',
              style: CommonStyle.textStyleSmall(size: 14),
            ),
            SizedBox(height: 20),

            /// input section
            Text(
              'I want to join Tilx Driver as:*',
              style: CommonStyle.textStyleMedium(size: 16),
            ),
            SizedBox(height: 10),
            CustomDropDownWidget(
              items: [
                'A self-employed driver with own Taxi',
                'A driver without a car (will drive company Taxi)',
                'Want to join as a rental/taxi partner',
              ],
              hintText: 'Select Option',
              onChanged: (value) {
                if (value != null) {
                  joinAsController.text = value;
                }
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: 40,
                  child: CustomSwitchWidget(
                    value: true,
                    scale: 0.8,
                    activeColor: AppColors.mainColor,
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'I have a vehicle Without Owner Ship.',
                  style: CommonStyle.textStyleMedium(size: 12),
                ),
              ],
            ),

            CustomTextFieldWithLabel(
              label: 'License plate',
              hint: 'Enter your license plate number',
              controller: licensePlateController,
            ),
            CustomTextFieldWithLabel(
              label: 'Vehicle transport license number',
              hint: 'Enter vehicle transport licence number',
              controller: vehicleTransportLicenseNumberController,
            ),
            CustomTextFieldWithLabel(
              label: 'Vehicle Brand Name',
              hint: 'e.g. Toyota',
              controller: vehicleBrandNameController,
            ),
            CustomTextFieldWithLabel(
              label: 'Vehicle manufacturer and model',
              hint: 'e.g. Toyota Corolla',
              controller: vehicleManufacturerModelController,
            ),

            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle Year',
                        style: CommonStyle.textStyleMedium(size: 16),
                      ),
                      SizedBox(height: 10),
                      CustomDropDownWidget(
                        items: ['2020', '2021', '2022'],
                        hintText: 'Select year',
                        onChanged: (value) {
                          if (value != null) {
                            vehicleYearController.text = value;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle Color',
                        style: CommonStyle.textStyleMedium(size: 16),
                      ),
                      SizedBox(height: 10),
                      CustomDropDownWidget(
                        items: ['Black', 'White', 'Red'],
                        hintText: 'Select color',
                        onChanged: (value) {
                          if (value != null) {
                            vehicleColorController.text = value;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            UploadTaxiImageWidget(),

            SizedBox(height: 20),
            CustomButton(
              title: 'Next',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KjoreseddedInformationView(),
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
