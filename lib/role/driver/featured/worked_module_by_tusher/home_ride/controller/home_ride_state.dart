import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_booking/core/utilitis/enum/driver_enums.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/driver_online_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/ride_request_response.dart';

class HomeRideState {
  final DriverStatus status;
  final DriverOnlineResponse? onlineResponse;
  final List<RideRequestResponse> rideRequest;
  final String? expandedRequestId;
  final RideRequestResponse? selectedRide;
  final String? error;
  final bool haveUnreadMessage;

  final LatLng? driverLocation;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  const HomeRideState({
    required this.status,
    this.haveUnreadMessage = false,
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
    bool? haveUnreadMessage,
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
      haveUnreadMessage: haveUnreadMessage ?? this.haveUnreadMessage,
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
