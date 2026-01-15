import 'dart:math';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_booking/core/services/storage/i_local_storage_service.dart';
import 'package:taxi_booking/core/services/storage/storage_key.dart';

double degToRad(double deg) => deg * (pi / 180);

Future<String?> getAccessToken(ILocalStorageService localStorage) async {
  return await localStorage.readKey(StorageKey.accessToken) as String?;
}

double calculatePolylineDistance(List<LatLng> points) {
  double coordinateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371;

    final dLat = degToRad(lat2 - lat1);
    final dLon = degToRad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(degToRad(lat1)) *
            cos(degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double totalDistance = 0.0;

  for (int i = 0; i < points.length - 1; i++) {
    totalDistance += coordinateDistance(
      points[i].latitude,
      points[i].longitude,
      points[i + 1].latitude,
      points[i + 1].longitude,
    );
  }

  return totalDistance;
}

// Helper method to get current location
Future<Position?> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return position;
}

Future<String> getAddressFromLocation(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    Placemark place = placemarks.first;
    String address = '${place.name}, ${place.locality}, ${place.country}';
    return address;
  } catch (e) {
    return "Unknown address";
  }
}
