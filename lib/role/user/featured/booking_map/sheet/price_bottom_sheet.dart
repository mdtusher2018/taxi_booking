// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taxi_booking/role/user/featured/booking_map/controllers/booking_map_controller.dart';
import 'package:taxi_booking/role/user/featured/booking_map/sheet/create_ride_summary_sheet.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';

class PricingOverviewSheet extends ConsumerStatefulWidget {
  const PricingOverviewSheet({super.key});

  @override
  _PricingOverviewSheetState createState() => _PricingOverviewSheetState();

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PricingOverviewSheet(),
    );
  }
}

class _PricingOverviewSheetState extends ConsumerState<PricingOverviewSheet> {
  int? selectedIndex; // Track selected pricing index

  final pricingList = [
    PricingModel(
      title: "TaxiTil",
      subtitle: "Lowest price option",
      startFare: 34.20,
      perKm: 11.70,
      perMin: 4.14,
      minFare: 99,
      extra: "Weekend higher pricing",
    ),
    PricingModel(
      title: "Comfort",
      subtitle: "Standard",
      startFare: 54,
      perKm: 15.75,
      perMin: 5.40,
      minFare: 100,
    ),
    PricingModel(
      title: "Premium",
      subtitle: "Luxury",
      startFare: 63.90,
      perKm: 21.60,
      perMin: 5.94,
      minFare: 105,
    ),
    PricingModel(
      title: "XL",
      subtitle: "Up to 7 passengers",
      startFare: 71.82,
      perKm: 25.52,
      perMin: 8.98,
      minFare: 251,
    ),
    PricingModel(
      title: "Pet",
      subtitle: "Pet friendly",
      startFare: 34.20,
      perKm: 11.70,
      perMin: 4.14,
      minFare: 99,
      extra: "+25 NOK pet charge",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .85,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text(
            "Pricing Overview",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: pricingList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                return _PricingCard(
                  model: pricingList[index],
                  isSelected: selectedIndex == index,
                  onTap: () {
                    setState(() {
                      selectedIndex = index; // Update selected index
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          CustomButton(
            title: 'Continue',

            onTap: () {
              if (selectedIndex != null) {
                ref
                    .read(bookingMapControllerProvider.notifier)
                    .selectedPriceModel(
                      selectedPriceModel: pricingList[selectedIndex!],
                    );

                SummarySheet.show(context);
              } else {
                CustomToast.showToast(
                  message: "please select a category",
                  isError: true,
                );
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final PricingModel model;
  final bool isSelected;
  final VoidCallback onTap;

  const _PricingCard({
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.amber.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_taxi, size: 20),
                const SizedBox(width: 8),
                Text(
                  model.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  model.subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _row("Start Fare", "${model.startFare.toStringAsFixed(2)} NOK"),
            _row("Per Km", "${model.perKm.toStringAsFixed(2)} NOK"),
            _row("Per Minute", "${model.perMin.toStringAsFixed(2)} NOK"),
            _row("Minimum Fare", "${model.minFare.toStringAsFixed(0)} NOK"),
            if (model.extra != null) ...[
              const SizedBox(height: 6),
              Text(
                model.extra!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 13)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
