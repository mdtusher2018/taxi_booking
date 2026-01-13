import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import '../controllers/booking_map_controller.dart';

class SearchBarWidget extends ConsumerWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(bookingMapControllerProvider.notifier);
    return GestureDetector(
      onTap: controller.onSearchTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }
}

// CountPrice
class CountPriceWidget extends ConsumerWidget {
  const CountPriceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final controller = ref.read(bookingMapControllerProvider.notifier);
    return GestureDetector(
      // onTap: controller.onSearchTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.credit_card, color: Colors.grey),
              const SizedBox(width: 8.0),
              Text('\$80', style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 8.0),
              const Icon(Icons.add_box, color: AppColors.mainColor),
            ],
          ),
        ),
      ),
    );
  }
}
