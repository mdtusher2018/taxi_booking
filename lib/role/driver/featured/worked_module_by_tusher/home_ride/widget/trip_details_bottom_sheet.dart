// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/common_app_pages.dart';
import 'package:taxi_booking/core/utilitis/launch_url.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/ride_request_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/widget/user_sheet_header.dart';

class TripDetailsSheet extends StatelessWidget {
  TripDetailsSheet({super.key});

  bool showTripDetailsSheet = true;
  dynamic currentTrip;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (!showTripDetailsSheet || currentTrip == null) {
          return const SizedBox.shrink();
        }

        final trip = currentTrip!;

        return SizedBox(
          height: MediaQuery.sizeOf(context).height / 1.1,
          child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
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
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      UserSheetHeader(
                        passengerImage: trip.passenger.profileImage,
                        passengerName: trip.passenger.name,
                        distance: trip.distance,
                        fare: trip.fare,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pickup point',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  trip.pickup,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pick Off',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  trip.dropoff,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (trip.status == 'accepted' ||
                          trip.status == 'arrived' ||
                          trip.status == 'in_progress') ...[
                        const SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Note:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lorem ipsum dolor sit amet consectetur. Ac odio eiusmod dignissim ipsum mattis.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Ride fare:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Rent',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '\$${trip.rent.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Vat',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '\$${trip.vat.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Discount',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '\$${trip.discount.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total fare =',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '\$${trip.fare}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                      _buildActionButtons(trip),
                      if (trip.status == 'accepted' ||
                          trip.status == 'arrived' ||
                          trip.status == 'in_progress') ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              Icons.close,
                              Colors.grey[200]!,
                              Colors.grey[600]!,
                              onTap: () {},
                            ),
                            _buildActionButton(
                              Icons.chat_bubble_outline,
                              const Color(0xffFFC107),
                              Colors.white,
                              onTap: () {
                                context.push(
                                  CommonAppRoutes.messagingView,
                                  extra: "",
                                );
                              },
                            ),
                            _buildActionButton(
                              Icons.phone,
                              const Color(0xffFFC107),
                              Colors.white,
                              onTap: () {
                                CustomToast.showToast(
                                  message: 'Calling ${trip.passenger.name}',
                                  isError: false,
                                );
                                LaunchUrlService().makePhoneCall(
                                  phoneNumber: '+8801889564894',
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(RideRequestResponse trip) {
    switch ('accepted') {
      case 'accepted':
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: CustomButton(onTap: () {}, title: 'Arrived'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onTap: () {},
                buttonColor: Colors.white,
                titleColor: Colors.black,
                border: Border.all(color: AppColors.mainColor),
                title: 'Tap to Start Trip',
              ),
            ),
          ],
        );
      case 'arrived':
        return SizedBox(
          width: double.infinity,
          child: CustomButton(onTap: () {}, title: 'Tap to Start Trip'),
        );
      case 'in_progress':
        return SizedBox(
          width: double.infinity,
          child: CustomButton(onTap: () {}, title: 'Finish Trip'),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  static Widget _buildActionButton(
    IconData icon,
    Color bgColor,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}
