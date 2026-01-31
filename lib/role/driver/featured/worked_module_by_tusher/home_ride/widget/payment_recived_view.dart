import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/driver_app_routes.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/controller/home_ride_controller.dart';

class PaymentRecivedView extends ConsumerWidget {
  const PaymentRecivedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(homeRideControllerProvider);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 20),
              ),
            ),

            const SizedBox(height: 8),

            // Success Icon
            const Icon(Icons.verified, color: Colors.green, size: 80),

            const SizedBox(height: 16),

            // Title
            const Text(
              "Payment Receive",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            // Description
            const Text(
              "You successfully receive payment\nfrom Jenny Wilson",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // Amount Label
            const Text(
              "Payment Amount",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 6),

            // Amount
            Text(
              "\$${state.selectedRide?.rideInfo.fare.totalFare ?? 0}",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            CustomButton(
              title: "Got it",
              onTap: () {
                ref.invalidate(homeRideControllerProvider);
                context.go(DriverAppRoutes.driverRoot);
              },
            ),
          ],
        ),
      ),
    );
  }
}
