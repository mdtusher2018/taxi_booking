// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import '../widget/custom_history_card.dart';

class RideHistoryView extends StatelessWidget {
  RideHistoryView({super.key});

  var rideList = <Map<String, dynamic>>[
    {
      'title': 'Ride to University',
      'from': 'Home, Bashundhara R/A',
      'to': 'North South University',
      'address': 'NSU Campus, Dhaka',
      'date': DateTime(2024, 12, 12, 10, 30),
      'duration': 43,
      'distance': 2.3,
      'location': const LatLng(23.8156, 90.4250),
    },
    {
      'title': 'Office Commute',
      'from': 'Gulshan-2',
      'to': 'Motijheel Commercial Area',
      'address': 'Motijheel, Dhaka',
      'date': DateTime(2024, 12, 11, 8, 15),
      'duration': 50,
      'distance': 9.2,
      'location': const LatLng(23.7336, 90.4148),
    },
    {
      'title': 'Ride to Airport',
      'from': 'Banani',
      'to': 'Hazrat Shahjalal International Airport',
      'address': 'Airport Road, Dhaka',
      'date': DateTime(2024, 12, 10, 6, 45),
      'duration': 25,
      'distance': 7.4,
      'location': const LatLng(23.8436, 90.3984),
    },
    {
      'title': 'Evening Tea Ride',
      'from': 'Uttara Sector 10',
      'to': 'Tea Stall, Sector 4',
      'address': 'Uttara, Dhaka',
      'date': DateTime(2024, 12, 9, 17, 30),
      'duration': 10,
      'distance': 1.8,
      'location': const LatLng(23.8762, 90.3796),
    },
    {
      'title': 'Hospital Drop',
      'from': 'Mirpur DOHS',
      'to': 'Bangabandhu Sheikh Mujib Medical University',
      'address': 'Shahbagh, Dhaka',
      'date': DateTime(2024, 12, 8, 9, 10),
      'duration': 42,
      'distance': 8.0,
      'location': const LatLng(23.7380, 90.3952),
    },
    {
      'title': 'Cafe Ride',
      'from': 'Dhanmondi 27',
      'to': 'North End Coffee, Banani',
      'address': 'Banani 11, Dhaka',
      'date': DateTime(2024, 12, 7, 19, 45),
      'duration': 35,
      'distance': 5.7,
      'location': const LatLng(23.7937, 90.4041),
    },
    {
      'title': 'Early Gym Session',
      'from': 'Baridhara DOHS',
      'to': 'Gold’s Gym, Gulshan-1',
      'address': 'Gulshan-1, Dhaka',
      'date': DateTime(2024, 12, 6, 6, 10),
      'duration': 20,
      'distance': 3.3,
      'location': const LatLng(23.7911, 90.4125),
    },
    {
      'title': 'Ride to Shopping Mall',
      'from': 'Rampura',
      'to': 'Jamuna Future Park',
      'address': 'Khilkhet, Dhaka',
      'date': DateTime(2024, 12, 5, 15, 20),
      'duration': 30,
      'distance': 6.0,
      'location': const LatLng(23.8197, 90.4265),
    },
    {
      'title': 'Ride to Park',
      'from': 'Shantinagar',
      'to': 'Ramna Park',
      'address': 'Ramna, Dhaka',
      'date': DateTime(2024, 12, 4, 16, 45),
      'duration': 18,
      'distance': 2.5,
      'location': const LatLng(23.7365, 90.4042),
    },
    {
      'title': 'Night Ride Home',
      'from': 'New Market',
      'to': 'Mohammadpur Residential',
      'address': 'Mohammadpur, Dhaka',
      'date': DateTime(2024, 12, 3, 22, 30),
      'duration': 25,
      'distance': 4.1,
      'location': const LatLng(23.7591, 90.3666),
    },
    {
      'title': 'Visit to School',
      'from': 'Gulshan Link Road',
      'to': 'International School Dhaka',
      'address': 'Bashundhara R/A',
      'date': DateTime(2024, 12, 2, 7, 40),
      'duration': 28,
      'distance': 5.5,
      'location': const LatLng(23.8150, 90.4242),
    },
  ];

  var expandedIndices = <int>{};

  void toggleExpanded(int index) {
    if (expandedIndices.contains(index)) {
      expandedIndices.remove(index);
    } else {
      expandedIndices.add(index);
    }
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
            onToggle: () => toggleExpanded(index),
          );
        },
      ),
    );
  }
}
