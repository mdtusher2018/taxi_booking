import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import '../widget/custom_history_card.dart';

class RideHistoryView extends StatefulWidget {
  const RideHistoryView({super.key});

  @override
  _RideHistoryViewState createState() => _RideHistoryViewState();
}

class _RideHistoryViewState extends State<RideHistoryView> {
  // Sample demo data
  final List<Map<String, dynamic>> rideList = [
    {
      'title': 'Ride 1',
      'address': '123 Main St, City A',
      'duration': 30,
      'distance': 12.5,
      'location': LatLng(37.7749, -122.4194), // San Francisco Coordinates
      'date': DateTime(2023, 10, 10, 10, 30),
    },
    {
      'title': 'Ride 2',
      'address': '456 Elm St, City B',
      'duration': 45,
      'distance': 15.2,
      'location': LatLng(34.0522, -118.2437), // Los Angeles Coordinates
      'date': DateTime(2023, 9, 15, 14, 0),
    },
    {
      'title': 'Ride 3',
      'address': '789 Oak St, City C',
      'duration': 60,
      'distance': 20.8,
      'location': LatLng(40.7128, -74.0060), // New York Coordinates
      'date': DateTime(2023, 8, 20, 16, 15),
    },
  ];

  // Expanded indices
  final Set<int> expandedIndices = Set<int>();

  // Function to toggle the expanded state
  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndices.contains(index)) {
        expandedIndices.remove(index);
      } else {
        expandedIndices.add(index);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Ride History', leading: const SizedBox()),
      body: ListView.builder(
        padding: const EdgeInsets.only(
          bottom: 80,
          top: 16,
          left: 16,
          right: 16,
        ),
        itemCount: rideList.length,
        itemBuilder: (context, index) {
          final ride = rideList[index];
          final isExpanded = expandedIndices.contains(index);

          // Safe data parsing
          final title = ride['title']?.toString() ?? '';
          final address = ride['address']?.toString() ?? '';
          final duration = ride['duration'] ?? 0;
          final distance = (ride['distance'] ?? 0).toDouble();
          final LatLng location = ride['location'] ?? const LatLng(0.0, 0.0);

          String dateFormatted = '';
          try {
            final date = ride['date'];
            if (date is DateTime) {
              dateFormatted = DateFormat('EEEE, dd MMM yyyy').format(date);
            } else {
              dateFormatted = date.toString(); // fallback
            }
          } catch (_) {
            dateFormatted = '';
          }

          return CustomHistoryCard(
            title: title,
            address: address,
            dateFormatted: dateFormatted,
            duration: duration,
            distance: distance,
            location: location,
            isExpanded: isExpanded,
            onToggle: () {
              toggleExpanded(index); // Update the expanded state
            },
          );
        },
      ),
    );
  }
}
