// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/common_app_pages.dart';
import 'package:taxi_booking/core/utilitis/launch_url.dart';
import 'package:taxi_booking/resource/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/controller/home_ride_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/ride_request_response.dart';

class OnTheWaySheet extends ConsumerWidget {
  const OnTheWaySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeRideControllerProvider);

    /// assuming only one active ride after accept
    final RideRequestResponse? request = state.selectedRide;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 1.2,
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        builder: (context, scrollController) {
          if (request == null) {
            return Container(
              padding: const EdgeInsets.only(bottom: 100),
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Something went wrong',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'An internal issue occurred.\n'
                        'Please disconnect and reconnect to the internet.\n\n'
                        'This ride has been cancelled.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
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
                    'On The Way',
                    style: CommonStyle.textStyleMedium(
                      size: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildOnTheWayItem(context, ref, request, true),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOnTheWayItem(
    BuildContext context,
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            /// -------- COLLAPSED VIEW --------
            ListTile(
              contentPadding: EdgeInsets.zero,
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
                style: TextStyle(color: Colors.grey.shade600),
              ),
              trailing: Text(
                '\$${request.rideInfo.fare.totalFare}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// -------- EXPANDED VIEW --------
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Column(
                      children: [
                        const Divider(),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 16),

                        /// -------- ACTION BUTTONS (Cancel | Message | Call) --------
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _actionIcon(
                                icon: Icons.close,
                                label: 'Cancel',

                                onTap: () {
                                  // TODO: cancel ride logic
                                },
                              ),
                              Badge(
                                isLabelVisible: ref
                                    .read(homeRideControllerProvider)
                                    .haveUnreadMessage,
                                child: _actionIcon(
                                  icon: Icons.message,
                                  label: 'Message',

                                  onTap: () {
                                    final id = ref
                                        .read(homeRideControllerProvider)
                                        .selectedRide
                                        ?.passengerInfo
                                        .id;

                                    context.push(
                                      CommonAppRoutes.messagingView,
                                      extra: {
                                        'id': id,
                                        'isDriverToDriverConversation': false,
                                      },
                                    );
                                    ref
                                        .read(
                                          homeRideControllerProvider.notifier,
                                        )
                                        .clearUnreadMessage();
                                  },
                                ),
                              ),
                              _actionIcon(
                                icon: Icons.call,
                                label: 'Call',

                                onTap: () {
                                  LaunchUrlService().makePhoneCall(
                                    phoneNumber: request.passengerInfo.phone,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        /// -------- ARRIVED BUTTON --------
                        CustomButton(
                          title: "Start Ride",
                          border: Border.all(
                            width: 2,
                            color: AppColors.btnColor,
                          ),
                          onTap: () {
                            ref
                                .read(homeRideControllerProvider.notifier)
                                .startRide(rideId: request.rideInfo.id);
                          },
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

  Widget _actionIcon({
    required IconData icon,
    required String label,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greenLightHover,
            ),
            child: Icon(icon, color: AppColors.btnColor, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 250, child: Text(value, maxLines: 2)),
          ],
        ),
      ],
    );
  }
}
