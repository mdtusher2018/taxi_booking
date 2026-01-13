import 'package:taxi_booking/resource/app_images/app_images.dart';
import 'package:taxi_booking/resource/common_widget/custom_network_image.dart';
import 'package:taxi_booking/role/driver/featured/add_taxi_dashboard/views/add_taxi_dashboard_view.dart';
import 'package:taxi_booking/role/driver/routes/driver_app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            context.push(DriverAppRoutes.settingView);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CustomNetworkImage(
              imageUrl:
                  "https://tse2.mm.bing.net/th/id/OIP.xrZIEhpJrAdGTbuBh8JHOQHaJy?cb=ucfimg2&ucfimg=1&w=3024&h=4000&rs=1&pid=ImgDetMain&o=7&rm=3",
              height: MediaQuery.sizeOf(context).height / 14,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),

        Container(
          height: MediaQuery.sizeOf(context).height / 14,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                isOnline ? 'Online' : 'Offline',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  isOnline = !isOnline;
                  setState(() {});
                },
                child: Container(
                  width: 44,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isOnline
                        ? const Color(0xFFF59E0B)
                        : Colors.grey.shade300,
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: isOnline
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        InkWell(
          onTap: () =>
              MaterialPageRoute(builder: (context) => AddTaxiDashboardView()),
          child: Container(
            height: MediaQuery.sizeOf(context).height / 14,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(AppImages.realEstateAgent, scale: 4),
          ),
        ),
      ],
    );
  }
}
