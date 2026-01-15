import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/core/utilitis/helper.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/controller/marker_icon.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/driver_online_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/ride_request_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/repository/home_ride_repository.dart';

part 'home_ride_controller.g.dart';

enum DriverStatus { offline, online, haveSelectedRequest, showTripDetailsSheet }

class HomeRideState {
  final DriverStatus status;
  final DriverOnlineResponse? onlineResponse;
  final List<RideRequestResponse> rideRequest;
  final String? expandedRequestId;
  final RideRequestResponse? selectedRide;
  final String? error;

  final LatLng? driverLocation;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  const HomeRideState({
    required this.status,
    this.onlineResponse,
    this.error,
    this.rideRequest = const [],
    this.expandedRequestId,
    this.selectedRide,
    this.driverLocation,
    this.markers = const {},
    this.polylines = const {},
  });

  HomeRideState copyWith({
    DriverStatus? status,
    DriverOnlineResponse? onlineResponse,
    List<RideRequestResponse>? rideRequest,
    String? error,
    String? expandedRequestId,
    RideRequestResponse? selectedRide,
    LatLng? driverLocation,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
  }) {
    return HomeRideState(
      status: status ?? this.status,
      onlineResponse: onlineResponse ?? this.onlineResponse,
      rideRequest: rideRequest ?? this.rideRequest,
      error: error,
      expandedRequestId: expandedRequestId ?? this.expandedRequestId,
      selectedRide: selectedRide ?? this.selectedRide,
      driverLocation: driverLocation ?? this.driverLocation,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
    );
  }
}

@riverpod
class HomeRideController extends _$HomeRideController with MapMarkerIcon {
  late HomeRideRepository repository;

  Timer? _locationTimer;
  StreamSubscription<Position>? _locationStream;

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
    if (state.driverLocation == null) return;

    final pickupLatLng = LatLng(
      ride.rideInfo.pickupLocation.coordinates[0],
      ride.rideInfo.pickupLocation.coordinates[1],
    );

    /// Pickup marker
    final pickupMarker = Marker(
      markerId: const MarkerId("pickup"),
      position: pickupLatLng,
      icon: pickupIcon ?? BitmapDescriptor.defaultMarker,
    );

    /// Simple straight polyline (for now)
    final polyline = Polyline(
      polylineId: const PolylineId("route"),
      points: [state.driverLocation!, pickupLatLng],
      width: 5,
      color: Colors.yellowAccent,
    );

    state = state.copyWith(
      markers: {...state.markers, pickupMarker},
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

    _startLocationUpdates(ride.rideInfo.id);
    _drawRouteToPickup(ride);
    state = state.copyWith(
      status: DriverStatus.haveSelectedRequest,
      selectedRide: ride,
    );
  }

  void _startLocationUpdates(String rideId) {
    _locationTimer?.cancel();

    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      AppLogger.i("Timer tick: Updating driver location for rideId: $rideId");
      final position = await getCurrentLocation();

      if (position != null) {
        repository.updateDriverLocation(
          latitude: position.latitude,
          longitude: position.longitude,
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
}
