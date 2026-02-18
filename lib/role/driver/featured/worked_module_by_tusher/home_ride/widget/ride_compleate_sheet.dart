import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/driver_app_routes.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/controller/home_ride_controller.dart';

class RideCompleateSheet extends ConsumerWidget {
  const RideCompleateSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 1.15,
      child: DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.only(bottom: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              children: [
                _dragHandle(),
                _header(),

                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    title: "Done",
                    onTap: () {
                      ref.invalidate(homeRideControllerProvider);
                      context.go(DriverAppRoutes.driverRoot);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _dragHandle() => Center(
    child: Container(
      margin: const EdgeInsets.only(top: 16),
      width: 48,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  Widget _header() => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Text(
          "Congratulations",
          style: CommonStyle.textStyleMedium(
            size: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text("You sucessfully compleate the ride"),
      ],
    ),
  );
}
