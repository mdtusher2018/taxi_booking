import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_booking/resource/app_images/app_images.dart';

mixin MapMixin {
  BitmapDescriptor? taxiIcon;
  BitmapDescriptor? pickupIcon;
  BitmapDescriptor? currentLocationIcon;
  Future<void> initMarkers() async {
    try {
      final ByteData byteData = await rootBundle.load(AppImages.pickupMarker);
      final Uint8List bytes = byteData.buffer.asUint8List();
      pickupIcon = BitmapDescriptor.fromBytes(bytes);
    } catch (e) {
      pickupIcon = BitmapDescriptor.defaultMarker;
    }

    try {
      final ByteData byteData = await rootBundle.load(AppImages.customMarker);
      final Uint8List bytes = byteData.buffer.asUint8List();
      taxiIcon = BitmapDescriptor.fromBytes(bytes);
    } catch (e) {
      taxiIcon = BitmapDescriptor.defaultMarker;
    }

    try {
      final ByteData byteData = await rootBundle.load(
        AppImages.myCurrentLocationMarker,
      );
      final Uint8List bytes = byteData.buffer.asUint8List();
      currentLocationIcon = BitmapDescriptor.fromBytes(bytes);
    } catch (_) {
      currentLocationIcon = BitmapDescriptor.defaultMarker;
    }
  }

  GoogleMapController? mapController;

  void mapControllerSet(GoogleMapController controller) {
    mapController = controller;
  }

  void fitCameraBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  Future<void> cameraMove(LatLng location) async {
    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 13.0),
      ),
    );
  }
}
