// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_images/app_images.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_radio_title_widget.dart';
import 'package:taxi_booking/role/driver/featured/add_transfort/views/add_taxi_details_one_view.dart';
import 'package:taxi_booking/role/driver/routes/driver_app_routes.dart';
import 'package:go_router/go_router.dart';

class DriverTransportSelectionView extends StatelessWidget {
  DriverTransportSelectionView({super.key});

  int selectedTransport = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Select your transport'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 🚕 Taxi Tile
            CustomRadioTile(
              value: 1,
              groupValue: selectedTransport,
              onChanged: (value) {
                selectedTransport = value;

                MaterialPageRoute(
                  builder: (context) => AddTaxiDetailsOneView(),
                );
              },
              leading: Image.asset(
                AppImages.taxi,
                width: MediaQuery.sizeOf(context).width / 10,
                height: MediaQuery.sizeOf(context).width / 10,
              ),
              titleText: 'Taxi',
              onTap: () {
                selectedTransport = 1;
                context.push(
                  DriverAppRoutes.drivingLicenseAndBusinessInfoView,
                  extra: {"withCar": true},
                );
              },
            ),

            const SizedBox(height: 20),

            /// ❌ No Taxi Tile
            CustomRadioTile(
              value: 2,
              groupValue: selectedTransport,
              onChanged: (value) {
                selectedTransport = value;
              },
              leading: const Icon(Icons.close, size: 30),
              titleText: 'No Taxi',
              onTap: () {
                selectedTransport = 2;
                context.push(
                  DriverAppRoutes.drivingLicenseAndBusinessInfoView,
                  extra: {"withCar": false},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
