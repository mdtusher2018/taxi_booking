import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Builder(
          builder: (context) {
            final markers = <Marker>{
              Marker(
                markerId: const MarkerId('driver'),
                position: const LatLng(23.8103, 90.4125),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange,
                ),
              ),
            };

            markers.addAll([
              Marker(
                markerId: const MarkerId('pickup'),
                position: const LatLng(23.8000, 90.4000),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
              ),
              Marker(
                markerId: const MarkerId('dropoff'),
                position: const LatLng(23.8200, 90.4200),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ),
            ]);

            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(23.8103, 90.4125),
                zoom: 13.0,
              ),
              markers: markers,
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: const [
                    LatLng(23.8000, 90.4000),
                    LatLng(23.8200, 90.4200),
                  ],
                  color: Colors.black,
                  width: 3,
                  patterns: [PatternItem.dash(10), PatternItem.gap(5)],
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            );
          },
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
