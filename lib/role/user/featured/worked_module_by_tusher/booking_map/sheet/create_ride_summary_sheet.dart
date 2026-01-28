import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/controllers/booking_map_controller.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/controllers/price_calculation_helper.dart';

import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import '../../../../../../resource/utilitis/common_style.dart';

class SummarySheet extends ConsumerStatefulWidget {
  SummarySheet({super.key});
  @override
  ConsumerState<SummarySheet> createState() => _SummarySheetState();

  /// 🔽 SHOW FUNCTION
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SummarySheet(),
    );
  }
}

class _SummarySheetState extends ConsumerState<SummarySheet> {
  double? _distanceFare;
  double? _timeFare;
  double? _totalFare;

  @override
  void initState() {
    super.initState();
    calculatePrice();
  }

  void calculatePrice() async {
    final controller = ref.read(bookingMapControllerProvider);

    _distanceFare = distanceFare(
      pricing: controller.selectedPriceModel!,
      distanceKm: controller.routeDistanceKm,
    );
    _timeFare = timeFare(
      pricing: controller.selectedPriceModel!,
      durationMin: controller.tripDurationMin,
    );
    _totalFare = totalFare(
      pricing: controller.selectedPriceModel!,
      distanceKm: controller.routeDistanceKm,
      durationMin: controller.tripDurationMin,
      surgeMultiplier: controller.surgeMultiplier,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(bookingMapControllerProvider.notifier);
    final state = ref.watch(bookingMapControllerProvider);
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.85,

      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Summary',
                      style: CommonStyle.textStyleLarge(size: 18),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Summary Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // 📍 Locations
                    _buildCardRow(
                      title: 'Pickup Location',
                      value: controller.pickupLocationController.text,
                    ),
                    const SizedBox(height: 12),

                    _buildCardRow(
                      title: 'Drop Location',
                      value: controller.dropLocationController.text,
                    ),
                    const SizedBox(height: 12),

                    // 🛣 Distance & Time
                    _buildCardRow(
                      title: "Distance",
                      value: "${state.routeDistanceKm.toStringAsFixed(2)} km",
                    ),
                    const SizedBox(height: 8),
                    _buildCardRow(
                      title: "Estimated Time",
                      value: "${state.tripDurationMin.toStringAsFixed(0)} min",
                    ),

                    const SizedBox(height: 12),

                    /// 🚕 Ride Details
                    _buildSection(
                      title: "Ride Details",
                      children: [
                        _buildRow(
                          "Category",
                          state.selectedPriceModel?.title ?? "-",
                        ),
                        _buildRow(
                          "Description",
                          state.selectedPriceModel?.subtitle ?? "-",
                        ),
                        if (state.selectedPriceModel?.extra != null)
                          _buildRow("Extra", state.selectedPriceModel!.extra!),
                      ],
                    ),

                    /// 💰 Fare Breakdown
                    _buildSection(
                      title: "Fare Breakdown",
                      children: [
                        _buildRow(
                          "Start Fare",
                          state.selectedPriceModel?.startFare != null
                              ? "NOK ${state.selectedPriceModel?.startFare.toStringAsFixed(2)}"
                              : "Calculating...",
                        ),
                        _buildRow(
                          "Distance Fare",
                          _distanceFare != null
                              ? "NOK ${_distanceFare!.toStringAsFixed(2)}"
                              : "Calculating...",
                        ),
                        _buildRow(
                          "Time Fare",
                          _timeFare != null
                              ? "NOK ${_timeFare!.toStringAsFixed(2)}"
                              : "Calculating...",
                        ),
                        const Divider(),
                        _buildRow(
                          "Total Fare",
                          _totalFare != null
                              ? "NOK ${_totalFare!.toStringAsFixed(2)}"
                              : "Calculating...",
                          isBold: true,
                        ),
                      ],
                    ),

                    CustomButton(
                      title: 'Continue',

                      onTap: () async {
                        if (_distanceFare != null &&
                            _timeFare != null &&
                            _totalFare != null) {
                          Navigator.popUntil(context, (route) => route.isFirst);

                          await controller.createRide(
                            distanceFare: _distanceFare!,
                            timeFare: _timeFare!,
                            totalFare: _totalFare!,
                          );
                        } else {
                          CustomToast.showToast(
                            message:
                                "Please wait untill cauculation is compleate",
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardRow({required String title, required String value}) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$title: ',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
