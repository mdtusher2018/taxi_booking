

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/driver/featured/home/model/pessanger_model.dart';

import '../model/ride_request_model.dart';

class RequestListSheet extends StatelessWidget {
  RequestListSheet({super.key});

  List<RideRequestModel> rideRequested = [
    RideRequestModel(
      id: "id",
      passenger: PassengerModel(name: "name", profileImage: "profileImage"),
      pickup: "pickup",
      dropoff: "dropoff",
      distance: "distance",
      fare: "fare",
      rent: 15,
      vat: 12,
      discount: 5,
    ),
  ];
  RideRequestModel? selectedRequest;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height / 1.1,
          child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.only(bottom: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Ride Requests',
                        style: CommonStyle.textStyleMedium(
                          size: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildRequestItem(context, rideRequested.first),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRequestItem(BuildContext context, RideRequestModel request) {
    return GestureDetector(
      onTap: () {
        selectedRequest = request;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(request.passenger.profileImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.passenger.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'User',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${request.distance} km',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '\$${request.fare}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
