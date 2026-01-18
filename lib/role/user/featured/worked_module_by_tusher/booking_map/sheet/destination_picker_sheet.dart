// Enhanced DestinationPickerSheet with search functionality and driver selection
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/sheet/price_bottom_sheet.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/location_search_textfield.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import '../controllers/booking_map_controller.dart';

class DestinationPickerSheet extends ConsumerStatefulWidget {
  const DestinationPickerSheet({super.key});

  @override
  ConsumerState<DestinationPickerSheet> createState() =>
      _DestinationPickerSheetState();
}

class _DestinationPickerSheetState
    extends ConsumerState<DestinationPickerSheet> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(bookingMapControllerProvider.notifier);
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.2,
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 1.0,
          expand: true,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Header
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Plan your trip',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            child: const Icon(Icons.close),
                            onTap: () => controller.onCancelDestination(),
                          ),
                        ],
                      ),
                      const Center(
                        child: Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                    ],
                  ),

                  // Content
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(8),
                      controller: scrollController,
                      children: [
                        LocationSearchField(
                          hint: "Pickup Location",
                          controller: controller.pickupLocationController,
                          onAddressSelected: (address) {
                            controller.pickupLocationController.text = address;
                          },
                          onLatLngSelected: (latLng) {
                            controller.updatePickUpLatLng(latlng: latLng);
                            controller.cameraMove(latLng);
                          },
                        ),
                        SizedBox(height: 16),
                        LocationSearchField(
                          hint: "Drop Location",
                          controller: controller.dropLocationController,
                          enableCurrentLocation: false,
                          onAddressSelected: (address) {
                            controller.dropLocationController.text = address;
                          },
                          onLatLngSelected: (latLng) {
                            controller.updateDropLatLng(latlng: latLng);
                            controller.cameraMove(latLng);
                          },
                        ),

                        const SizedBox(height: 20),

                        // Popular Destinations (show only when not searching)
                        ...[
                          const Text(
                            'Popular Destinations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...controller
                              .getPopularLocations()
                              .map(
                                (location) => ListTile(
                                  leading: const Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  title: Text(location.name),
                                  subtitle: Text(location.address),
                                  onTap: () {
                                    controller.dropLocationController.text =
                                        location.address;
                                    controller.dropLocationController.text =
                                        location.address;

                                    controller.updateDropLatLng(
                                      latlng: location.position,
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ],

                        const SizedBox(height: 20),

                        CustomButton(
                          title: 'Continue',
                          onTap: () {
                            if (controller
                                    .pickupLocationController
                                    .text
                                    .isNotEmpty &&
                                controller
                                    .dropLocationController
                                    .text
                                    .isNotEmpty) {
                              PricingOverviewSheet.show(context);
                            } else {
                              CustomToast.showToast(
                                message:
                                    "please select both pick up and destination",
                                isError: true,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
