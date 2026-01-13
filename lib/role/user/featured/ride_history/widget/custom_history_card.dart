import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class CustomHistoryCard extends StatelessWidget {
  final String title;
  final String address;
  final String dateFormatted;
  final int duration;
  final double distance;
  final LatLng location;
  final bool isExpanded;
  final VoidCallback onToggle;

  const CustomHistoryCard({
    super.key,
    required this.title,
    required this.address,
    required this.dateFormatted,
    required this.duration,
    required this.distance,
    required this.location,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: CommonStyle.textStyleLarge(size: 16)),
                      const SizedBox(height: 4),
                      Text(address, style: CommonStyle.textStyleMedium(size: 14)),
                      const SizedBox(height: 4),
                      Text(dateFormatted, style: CommonStyle.textStyleSmall()),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                  onPressed: onToggle,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              Container(
                height: 180,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: location,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('marker'),
                        position: location,
                      )
                    },
                    zoomControlsEnabled: false,
                    liteModeEnabled: true,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text('$duration min'),
                  const SizedBox(width: 16),
                  const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text('$distance km'),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
