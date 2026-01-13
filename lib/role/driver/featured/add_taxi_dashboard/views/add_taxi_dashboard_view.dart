import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/add_taxi_dashboard/views/car_details_view.dart';
import 'package:taxi_booking/role/driver/featured/add_taxi_dashboard/widget/add_taxi_card.dart';
import '../widget/add_driver_dialog.dart';

class AddTaxiDashboardView extends StatelessWidget {
  const AddTaxiDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: CustomAppBar(title: 'Dashboard'),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CarDetailsView();
                  },
                ),
              );
            },
            child: AddTaxiCard(
              imageUrl:
                  "https://img.freepik.com/free-psd/black-isolated-car_23-2151852894.jpg?semt=ais_hybrid&w=740&q=80",
              carName: "Corolla Hatchback",
              carFeature: "Paddle shifters",
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        height: MediaQuery.sizeOf(context).height / 13,
        child: CustomButton(
          title: 'Add Taxi',
          widget: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.black),
              const SizedBox(width: 4),
              CustomText(
                title: 'Add Taxi',
                style: CommonStyle.textStyleMedium(color: Colors.black),
              ),
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const AddDriverDialog(),
            );
          },
        ),
      ),
    );
  }
}
