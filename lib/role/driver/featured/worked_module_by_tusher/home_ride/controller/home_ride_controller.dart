import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
import 'package:taxi_booking/core/utilitis/enum/driver_enums.dart';
import 'package:taxi_booking/core/utilitis/helper.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/controller/home_ride_state.dart';
import 'package:taxi_booking/core/utilitis/mixin/map_mixin.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/driver_online_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/ride_request_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/repository/home_ride_repository.dart';

part 'home_ride_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeRideController extends _$HomeRideController with MapMixin {
  late HomeRideRepository repository;

  Timer? _locationTimer;
  StreamSubscription<Position>? _locationStream;
  final polylinePoints = PolylinePoints(apiKey: DriverApiEndpoints.mapKey);

  void startTrackingDriverLocation() {
    _locationStream?.cancel();

    _locationStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((position) {
          final latLng = LatLng(position.latitude, position.longitude);

          final driverMarker = Marker(
            markerId: const MarkerId("driver"),
            position: latLng,
            icon: currentLocationIcon ?? BitmapDescriptor.defaultMarker,
          );
          cameraMove(latLng);

          /// 🔁 REDRAW ROUTE IF RIDE IS ACTIVE
          if (state.status == DriverStatus.onGoingToPick &&
              state.selectedRide != null) {
            _drawRouteToPickup(state.selectedRide!);
          }

          state = state.copyWith(
            driverLocation: latLng,
            markers: {
              ...state.markers.where((m) => m.markerId.value != "driver"),
              driverMarker,
            },
          );
        });
  }

  void stopTracking() {
    _locationStream?.cancel();
    _locationStream = null;

    state = state.copyWith(markers: {}, polylines: {}, driverLocation: null);
  }

  Future<void> _drawRouteToPickup(RideRequestResponse ride) async {
    LatLng? driverLatLng = state.driverLocation;

    if (driverLatLng == null) {
      final position = await getCurrentLocation();
      if (position == null) return;

      driverLatLng = LatLng(position.latitude, position.longitude);
    }

    final pickupLatLng = LatLng(
      ride.rideInfo.pickupLocation.coordinates[1], // latitude
      ride.rideInfo.pickupLocation.coordinates[0], // longitude
    );

    /// Pickup marker
    final pickupMarker = Marker(
      markerId: const MarkerId("pickup"),
      position: pickupLatLng,
      icon: pickupIcon ?? BitmapDescriptor.defaultMarker,
    );

    final result = await polylinePoints.getRouteBetweenCoordinatesV2(
      request: RoutesApiRequest(
        origin: PointLatLng(driverLatLng.latitude, driverLatLng.longitude),
        destination: PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
        travelMode: TravelMode.driving,
      ),
    );

    if (result.primaryRoute?.polylinePoints == null ||
        result.primaryRoute!.polylinePoints!.isEmpty) {
      AppLogger.e("❌ Route not found: ${result.errorMessage}");
      return;
    }

    final routePoints = result.primaryRoute!.polylinePoints!
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.blue,
      width: 5,
      points: routePoints,
    );

    state = state.copyWith(
      markers: {
        ...state.markers.where((m) => m.markerId.value != "pickup"),
        pickupMarker,
      },
      polylines: {polyline},
    );
  }

  @override
  HomeRideState build() {
    repository = ref.read(homerideRepositoryProvider);
    initMarkers();
    return HomeRideState(status: DriverStatus.offline);
  }

  void toggleExpand(String requestId) {
    state = state.copyWith(
      expandedRequestId: state.expandedRequestId == requestId
          ? null
          : requestId,
    );
  }

  Future<void> driverOnline() async {
    Position? position = await getCurrentLocation();
    if (position == null) {
      state = state.copyWith(error: "Failed to get current location");
      return;
    }
    String address = await getAddressFromLocation(
      position.latitude,
      position.longitude,
    );

    final res = await repository.driverOnline(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
    );
    if (res is FailureResult) {
      final error = (res as FailureResult).error as Failure;
      state = state.copyWith(error: error.message);
    }

    repository.listenToRideRequest().listen((rideRequestResponse) {
      final alreadyExists = state.rideRequest.any(
        (e) => e.rideInfo.id == rideRequestResponse.rideInfo.id,
      );

      if (!alreadyExists) {
        state = state.copyWith(
          rideRequest: [...state.rideRequest, rideRequestResponse],
        );
      }
    });

    startTrackingDriverLocation();

    state = state.copyWith(
      status: DriverStatus.online,
      onlineResponse: (res as Success).data as DriverOnlineResponse,
      rideRequest: [],
    );
  }

  Future<void> driverOffline() async {
    repository.stopListenToRideRequest();
    stopTracking();

    state = state.copyWith(status: DriverStatus.offline);
  }

  Future<void> rideAccepted({required RideRequestResponse ride}) async {
    repository.rideAccept(rideId: ride.rideInfo.id);

    _startLocationUpdates(ride.rideInfo.id, ride.passengerInfo.id);
    _drawRouteToPickup(ride);

    repository.listenMessageBadge(receiverId: ride.passengerInfo.id).listen((
      chatMessage,
    ) {
      state = state.copyWith(haveUnreadMessage: true);
    });

    repository.reachedPickupLocation().listen((response) {
      state = state.copyWith(status: DriverStatus.reachedPickupLocation);
    });
    repository.reachedDestinationLocation().listen((response) {
      state = state.copyWith(status: DriverStatus.reachedDestinationLocation);
    });

    state = state.copyWith(
      status: DriverStatus.onGoingToPick,
      selectedRide: ride,
    );
  }

  void clearUnreadMessage() {
    state = state.copyWith(haveUnreadMessage: false);
  }

  void _startLocationUpdates(String rideId, String passengerId) {
    _locationTimer?.cancel();

    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final position = await getCurrentLocation();

      if (position != null && state.status == DriverStatus.onGoingToPick) {
        repository.updateDriverLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          passengerId: passengerId,
          rideId: rideId,
          averageSpeedKmPH: 1,
        );
      }
      if (position != null && state.status == DriverStatus.rideStartrd) {
        repository.updateDriverLocationAfterRideStart(
          latitude: position.latitude,
          longitude: position.longitude,
          passengerId: passengerId,
          rideId: rideId,
          averageSpeedKmPH: 1,
        );
      }
    });
  }

  Future<void> rideDecline({required String rideId}) async {
    repository.rideDecline(rideId: rideId);

    state = state.copyWith(status: DriverStatus.online);
  }

  void startRide({required String rideId}) async {
    final position = await getCurrentLocation();

    if (position != null) {
      repository.startRide(
        latitude: position.latitude,
        longitude: position.longitude,

        rideId: rideId,
        averageSpeedKmPH: 1,
        onSuccess: (response) {
          state = state.copyWith(status: DriverStatus.rideStartrd);
        },
      );
    }
  }

  void endRide({required String rideId}) async {
    final position = await getCurrentLocation();

    if (position != null) {
      repository.endRide(
        rideId: rideId,
        onSuccess: (response) {
          state = state.copyWith(status: DriverStatus.rideEnd);
        },
      );
    }
  }
}
