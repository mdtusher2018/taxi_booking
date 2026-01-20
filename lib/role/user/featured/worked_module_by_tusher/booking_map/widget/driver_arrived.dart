import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/core/utilitis/launch_url.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/role/common/chat/views/message_view.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/resource/common_widget/custom_network_image.dart';
import '../views/cancel_booking_view.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/controllers/booking_map_controller.dart';

// Create the Professional Driver Arrived Card
class DriverArrivedCard extends ConsumerStatefulWidget {
  final VoidCallback? onCancel;

  DriverArrivedCard({super.key, this.onCancel});

  @override
  ConsumerState<DriverArrivedCard> createState() =>
      _ProfessionalDriverArrivedCardState();

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

class _ProfessionalDriverArrivedCardState
    extends ConsumerState<DriverArrivedCard> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingMapControllerProvider);

    return Container(
      height: MediaQuery.of(context).size.height / 3,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top drag indicator
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Close icon at top right
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: widget.onCancel,
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          // "Driver Arrived" Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Driver Arrived",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${state.tripDurationMin.toStringAsFixed(2)} min",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Driver Info
          Row(
            children: [
              CustomNetworkImage(
                imageUrl: state.acceptedDriverInfo?.image ?? "",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          state.acceptedDriverInfo?.name ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          (state.acceptedDriverInfo?.rating ?? 0).toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          state.acceptedDriverInfo?.vehicle?.name ?? "N/A",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${state.routeDistanceKm.toString()} Km",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DriverArrivedCard._buildActionButton(
                Icons.close,
                Colors.grey[200]!,
                Colors.grey[600]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CancelBookingView();
                      },
                    ),
                  );
                },
              ),
              DriverArrivedCard._buildActionButton(
                Icons.chat_bubble_outline,
                const Color(0xffFFC107),
                Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MessageView(
                          reciverId: state.acceptedDriverInfo?.driverId ?? "",
                        );
                      },
                    ),
                  );
                },
              ),
              DriverArrivedCard._buildActionButton(
                Icons.phone,
                const Color(0xffFFC107),
                Colors.white,
                onTap: () {
                  CustomToast.showToast(
                    message: 'Calling ${state.acceptedDriverInfo?.name ?? ""}',
                    isError: false,
                  );
                  LaunchUrlService().makePhoneCall(
                    phoneNumber: state.acceptedDriverInfo?.phone ?? "",
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          CustomButton(title: "Driver Arrived", onTap: () {}),
        ],
      ),
    );
  }
}
