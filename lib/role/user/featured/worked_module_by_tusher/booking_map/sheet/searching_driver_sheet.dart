// Show the Searching Driver Bottom Sheet
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/user_app_routes.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/controllers/booking_map_controller.dart';

// Creating a class to handle the Draggable BottomSheet
class SearchingDriverBottomSheet extends ConsumerStatefulWidget {
  const SearchingDriverBottomSheet({super.key});

  @override
  ConsumerState<SearchingDriverBottomSheet> createState() =>
      _SearchingDriverBottomSheetState();

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false, // Disable dismiss by tapping outside
      enableDrag: true, // Enable drag gesture to close the sheet
      builder: (_) => SearchingDriverBottomSheet(),
    );
  }
}

class _SearchingDriverBottomSheetState
    extends ConsumerState<SearchingDriverBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize:
          0.3, // Initial height of the bottom sheet (30% of screen)
      minChildSize: 0.3, // Minimum size of the bottom sheet
      maxChildSize: 0.8, // Maximum size of the bottom sheet (80% of screen)
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          final result = await ref
                              .read(bookingMapControllerProvider.notifier)
                              .onRideCancel();
                          if (result && mounted) {
                            ref.invalidate(bookingMapControllerProvider);
                            context.go(UserAppRoutes.rootView);
                          }
                        },
                        child: const Icon(Icons.cancel),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.directions_car,
                    size: 50,
                    color: AppColors.btnColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Searching for a Driver...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Linear progress indicator
                  const LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blueAccent,
                    ),
                    backgroundColor: AppColors.btnColor,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
