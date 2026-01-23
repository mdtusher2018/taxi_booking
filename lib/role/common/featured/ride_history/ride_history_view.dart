// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/common/featured/ride_history/ride_history_controller.dart';
import 'package:taxi_booking/role/common/featured/ride_history/ride_history_model.dart';

class RideHistoryView extends ConsumerStatefulWidget {
  const RideHistoryView({super.key});

  @override
  ConsumerState<RideHistoryView> createState() => _RideHistoryViewState();
}

class _RideHistoryViewState extends ConsumerState<RideHistoryView> {
  ScrollController scrollController = ScrollController();
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rideHistoryControllerProvider.notifier).load();
    });

    final controller = ref.read(rideHistoryControllerProvider.notifier);
    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rideHistoryControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Ride History', leading: SizedBox()),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: CustomText(
            title: e.toString(),
            style: CommonStyle.textStyleMedium(color: Colors.white),
          ),
        ),
        data: (pagination) {
          final rideHistory = pagination.items;

          if (rideHistory.isEmpty) {
            return noRidesFound();
          }

          final grouped = _groupRides(rideHistory);

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(rideHistoryControllerProvider.notifier).refresh();
            },
            child: ListView(
              controller: scrollController,
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    /// Ride History Items
                    ...entry.value.map((item) {
                      final index = entry.value.indexOf(item);
                      return _CustomHistoryCard(
                        dropAddress: item.dropOffLocation.address,
                        pickupAddress: item.pickupLocation.address,
                        dropLocation: LatLng(
                          item.dropOffLocation.coordinates.latitude.toDouble(),
                          item.dropOffLocation.coordinates.longitude.toDouble(),
                        ),
                        dateFormatted: DateFormat(
                          'EEE, dd MMM yyyy',
                        ).format(item.createdAt),
                        duration: item.estimatedDurationMin.toInt(),
                        distance: item.estimatedDistanceKm.toDouble(),
                        fare: item.fare,
                        isExpanded: expandedIndex == index,
                        onToggle: () => _toggleExpanded(index),
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _toggleExpanded(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null; // Collapse the expanded card
      } else {
        expandedIndex = index; // Expand the selected card
      }
    });
  }

  Widget noRidesFound() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(Icons.history, size: 60, color: Colors.blueGrey[400]),
          ),
          const SizedBox(height: 20),
          const Text(
            "No Ride History Found",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "You don't have any ride history yet. Please check back later.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            title: "Refresh Ride History",
            onTap: () async {
              ref.read(rideHistoryControllerProvider.notifier).refresh();
            },
          ),
        ],
      ),
    );
  }

  Map<String, List<Ride>> _groupRides(List<Ride> rides) {
    final Map<String, List<Ride>> grouped = {};

    for (final ride in rides) {
      final date = ride.createdAt;
      String key;

      if (_isToday(date)) {
        key = 'Today';
      } else if (_isYesterday(date)) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMM dd, yyyy').format(date);
      }

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(ride);
    }

    return grouped;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
}

class _CustomHistoryCard extends StatelessWidget {
  final String dropAddress;
  final String pickupAddress;
  final String dateFormatted;
  final int duration;
  final double distance;
  final Fare fare;
  final LatLng dropLocation;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _CustomHistoryCard({
    required this.dropAddress,
    required this.pickupAddress,
    required this.dateFormatted,
    required this.duration,
    required this.distance,
    required this.fare,
    required this.dropLocation,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Address Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        dropAddress,
                        style: CommonStyle.textStyleLarge(
                          size: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Address
                      Text(
                        "From: $pickupAddress",
                        style: CommonStyle.textStyleMedium(
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      if (!isExpanded) ...[
                        SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 20,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$duration min',
                              style: CommonStyle.textStyleMedium(
                                size: 14,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$distance km',
                              style: CommonStyle.textStyleMedium(
                                size: 14,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Expand/Collapse Arrow
                IconButton(
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 24,
                    color: Colors.blueGrey[700],
                  ),
                  onPressed: onToggle,
                ),
              ],
            ),
            if (isExpanded) ...[
              // Map and Fare Breakdown
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: dropLocation,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('marker'),
                        position: dropLocation,
                      ),
                    },
                    zoomControlsEnabled: false,
                    liteModeEnabled: false,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Ride Details (Duration & Distance)
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$duration min',
                    style: CommonStyle.textStyleMedium(
                      size: 14,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$distance km',
                    style: CommonStyle.textStyleMedium(
                      size: 14,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Fare Breakdown
              Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Fare: \$${fare.totalFare.toStringAsFixed(2)}',
                    style: CommonStyle.textStyleMedium(
                      size: 14,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
