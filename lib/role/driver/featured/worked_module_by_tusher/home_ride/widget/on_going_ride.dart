import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/resource/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/controller/home_ride_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/ride_request_response.dart';

class OngoingRideSheet extends ConsumerWidget {
  const OngoingRideSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeRideControllerProvider);
    final ride = state.selectedRide;

    if (ride == null) return const SizedBox.shrink();

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
                _header(ride.passengerInfo.name),
                _passengerCard(ride),
                const SizedBox(height: 12),
                _rideStats(ride),

                const SizedBox(height: 24),
                _endRideButton(ref, ride.rideInfo.id),
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

  Widget _header(String passengerName) => Padding(
    padding: const EdgeInsets.all(16),
    child: Text(
      "Ride in Progress",
      style: CommonStyle.textStyleMedium(size: 18, fontWeight: FontWeight.w700),
    ),
  );

  Widget _passengerCard(RideRequestResponse ride) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: ride.passengerInfo.image != null
              ? NetworkImage(ride.passengerInfo.image!)
              : null,
          child: ride.passengerInfo.image == null
              ? const Icon(Icons.person, size: 30)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ride.passengerInfo.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Trip Fare: \$${ride.rideInfo.fare.totalFare.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        _ActionIcon(icon: Icons.support_agent, label: "Support"),
      ],
    ),
  );

  Widget _rideStats(RideRequestResponse ride) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statCard(
          "Distance",
          "${ride.rideInfo.estimatedDistanceKm.toStringAsFixed(2)} km",
        ),
        _statCard(
          "ETA",
          "${ride.rideInfo.estimatedDurationMin.toStringAsFixed(2)} min",
        ),
        _statCard("Status", "Ongoing"),
      ],
    ),
  );

  Widget _statCard(String title, String value) => Container(
    width: 100,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey.shade100,
    ),
    child: Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.grey.shade600)),
      ],
    ),
  );

  Widget _endRideButton(WidgetRef ref, String rideId) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: CustomButton(
      title: "Cancle Ride",
      onTap: () {
        // ref.read(homeRideControllerProvider.notifier).endRide(rideId: rideId);
      },
    ),
  );
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: AppColors.blackColor),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
