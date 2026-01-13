// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:taxi_booking/role/driver/featured/home/sheet/confirmation_sheet.dart';
import 'package:taxi_booking/role/driver/featured/home/sheet/request_bottom_sheet.dart';
import 'package:taxi_booking/role/driver/featured/home/sheet/trip_details_bottom_sheet.dart';
import 'package:taxi_booking/role/driver/featured/home/widget/header_widget.dart';

import 'map_view.dart';

class DriverHomeView extends StatelessWidget {
  DriverHomeView({super.key});

  bool showTripDetailsSheet = true;
  dynamic selectedRequest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: MapView()),
          Positioned(top: 32, left: 16, right: 16, child: HeaderWidget()),

          Positioned(bottom: 0, left: 0, right: 0, child: RequestListSheet()),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child:
                selectedRequest != null
                    ? ConfirmationSheet()
                    : const SizedBox.shrink(),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child:
                showTripDetailsSheet
                    ? TripDetailsSheet()
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
