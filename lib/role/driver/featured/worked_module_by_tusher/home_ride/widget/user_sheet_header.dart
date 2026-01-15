import 'package:flutter/material.dart';


class UserSheetHeader extends StatelessWidget {
  final String passengerImage;
  final String passengerName;
  final String distance;
  final String fare;
  const UserSheetHeader({
    super.key,
    required this.passengerImage,
    required this.passengerName,
    required this.distance,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(passengerImage),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                passengerName,
                style: const TextStyle(
                  fontSize: 20,
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
              '${distance} km',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            Text(
              '\$${fare}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
