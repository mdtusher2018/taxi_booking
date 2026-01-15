// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/resource/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/controller/home_ride_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/ride_request_response.dart';

class RequestListSheet extends ConsumerWidget {
  RequestListSheet({super.key});
  RideRequestResponse? selectedRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeRideControllerProvider);

    return Builder(
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height / 1.1,
          child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.only(bottom: 30),
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
                  padding: EdgeInsets.all(0),
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Ride Requests',
                        style: CommonStyle.textStyleMedium(
                          size: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.rideRequest.length,
                      itemBuilder: (context, index) {
                        final request = state.rideRequest[index];
                        final isExpanded =
                            state.expandedRequestId == request.rideInfo.id;

                        return _buildRequestItem(ref, request, isExpanded);
                      },
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRequestItem(
    WidgetRef ref,
    RideRequestResponse request,
    bool isExpanded,
  ) {
    return GestureDetector(
      onTap: () {
        ref
            .read(homeRideControllerProvider.notifier)
            .toggleExpand(request.rideInfo.id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // ---------- COLLAPSED VIEW ----------
            ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              leading: CircleAvatar(
                radius: 24,
                backgroundImage:
                    request.passengerInfo.image != null &&
                        request.passengerInfo.image!.isNotEmpty
                    ? NetworkImage(request.passengerInfo.image!)
                    : null,
                child: request.passengerInfo.image == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(
                request.passengerInfo.name.isEmpty
                    ? 'Unknown Passenger'
                    : request.passengerInfo.name,
              ),
              subtitle: Text(
                '${request.rideInfo.estimatedDistanceKm} km',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              trailing: Text(
                '\$${request.rideInfo.fare.totalFare}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // ---------- EXPANDED VIEW ----------
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Column(
                      children: [
                        const Divider(),
                        SizedBox(height: 8),
                        _infoRow(
                          Icons.my_location,
                          'Pickup',
                          request.rideInfo.pickupLocation.address,
                        ),
                        const SizedBox(height: 6),
                        _infoRow(
                          Icons.location_on,
                          'Drop-off',
                          request.rideInfo.dropOffLocation.address,
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                title: "Decline",
                                buttonColor: Colors.transparent,

                                border: Border.all(
                                  width: 2,
                                  color: AppColors.btnColor,
                                ),
                                onTap: () {
                                  ref
                                      .read(homeRideControllerProvider.notifier)
                                      .rideDecline(rideId: request.rideInfo.id);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomButton(
                                title: "Accept",
                                border: Border.all(
                                  width: 2,
                                  color: AppColors.btnColor,
                                ),
                                onTap: () {
                                  ref
                                      .read(homeRideControllerProvider.notifier)
                                      .rideAccepted(ride: request);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(value, maxLines: 2),
            ],
          ),
        ),
      ],
    );
  }
}
