import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';

import 'package:taxi_booking/resource/common_widget/custom_network_image.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import '../model/transection_model.dart';

class TransactionHistoryCard extends StatelessWidget {
  final TransectionModel transection;

  const TransactionHistoryCard({
    super.key,
    required this.transection,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Date and Amount ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(transection.dateTime,
                    style: CommonStyle.textStyleSmall(size: 12, color: Colors.grey.shade600)),
                Text(transection.amount,
                    style: CommonStyle.textStyleSmall(size: 12)),
              ],
            ),
            const SizedBox(height: 12),

            // --- Locations and Profile Image ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: Colors.orange, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(transection.pickup,
                                style: CommonStyle.textStyleSmall(size: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.blue, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(transection.dropoff,
                                style: CommonStyle.textStyleSmall(size: 13)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                CustomNetworkImage(
                  imageUrl: transection.imageUrl,
                  height: 50,
                  width: 50,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // --- Action and Rating ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Request Again",
                    style: CommonStyle.textStyleMedium(size: 13, color: AppColors.mainColor)),
                Text('(${transection.rating.toString()})',
                    style: CommonStyle.textStyleSmall(size: 13)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
