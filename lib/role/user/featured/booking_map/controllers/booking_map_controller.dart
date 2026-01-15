// booking_map_controller.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/services/socket/socket_events.dart';
import 'package:taxi_booking/core/services/socket/socket_service.dart';
import 'package:taxi_booking/core/utilitis/helper.dart';
import 'package:taxi_booking/core/utilitis/user_api_end_points.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/controller/marker_icon.dart';
import 'package:taxi_booking/role/user/featured/booking_map/model/create_ride_response.dart';
import 'package:taxi_booking/role/user/featured/booking_map/model/driver_live_location_update.dart';
import '../model/driver_info_model.dart';

class PricingModel {
  final String title;
  final String subtitle;
  final double startFare;
  final double perKm;
  final double perMin;
  final double minFare;
  final String? extra;

  PricingModel({
    required this.title,
    required this.subtitle,
    required this.startFare,
    required this.perKm,
    required this.perMin,
    required this.minFare,
    this.extra,
  });
}

enum RideBookingStatus {
  initial,
  rideCreating,
  searchingDriver,
  driverOnTheWay,
  rideStarted,
  rideInProgress,
  rideCompleted,
  rideCancelled,
  paymentProcessing,
  paymentCompleted,
  paymentFailed,
  rideFailed,
  rideEnded,
}

class BookingMapState {
  final bool isLoading;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  final LatLng? pickupLatLng;
  final LatLng? dropLatLng;
  final LatLng? currentLocation;
  final LatLng? driverLatLng;

  final RideBookingStatus status;
  final double routeDistanceKm;
  final double tripDurationMin;
  final double surgeMultiplier;
  final String rideId;
  final DriverInfo? acceptedDriverInfo;

  final PricingModel? selectedPriceModel;

  const BookingMapState({
    this.isLoading = false,
    this.markers = const {},
    this.polylines = const {},
    this.pickupLatLng,
    this.dropLatLng,
    this.currentLocation,
    this.driverLatLng,
    this.status = RideBookingStatus.initial,
    this.routeDistanceKm = 0,
    this.tripDurationMin = 0,
    this.surgeMultiplier = 1,
    this.rideId = '',
    this.acceptedDriverInfo,
    this.selectedPriceModel,
  });

  BookingMapState copyWith({
    bool? isLoading,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    LatLng? pickupLatLng,
    LatLng? dropLatLng,
    LatLng? currentLocation,
    LatLng? driverLatLng,
    RideBookingStatus? status,
    double? routeDistanceKm,
    double? tripDurationMin,
    double? surgeMultiplier,
    String? rideId,
    DriverInfo? acceptedDriverInfo,
    PricingModel? selectedPriceModel,
  }) {
    return BookingMapState(
      isLoading: isLoading ?? this.isLoading,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      pickupLatLng: pickupLatLng ?? this.pickupLatLng,
      dropLatLng: dropLatLng ?? this.dropLatLng,
      currentLocation: currentLocation ?? this.currentLocation,
      driverLatLng: driverLatLng ?? this.driverLatLng,
      status: status ?? this.status,
      routeDistanceKm: routeDistanceKm ?? this.routeDistanceKm,
      tripDurationMin: tripDurationMin ?? this.tripDurationMin,
      surgeMultiplier: surgeMultiplier ?? this.surgeMultiplier,
      rideId: rideId ?? this.rideId,
      acceptedDriverInfo: acceptedDriverInfo ?? this.acceptedDriverInfo,
      selectedPriceModel: selectedPriceModel ?? this.selectedPriceModel,
    );
  }
}

final bookingMapControllerProvider =
    StateNotifierProvider<BookingMapController, BookingMapState>(
      (ref) => BookingMapController(
        apiService: ref.read(apiServiceProvider),
        socketService: ref.read(socketServiceProvider),
      ),
    );

class BookingMapController extends StateNotifier<BookingMapState>
    with MapMarkerIcon {
  final IApiService apiService;
  final SocketService socketService;

  BookingMapController({required this.apiService, required this.socketService})
    : super(const BookingMapState()) {
    _init();
  }

  final polylinePoints = PolylinePoints(apiKey: UserApiEndpoints.mapKey);

  Future<void> _init() async {
    await initMarkers();

    goToCurrentLocation();
    initSurgeMultiplier();
  }

  final TextEditingController dropLocationController = TextEditingController();
  final TextEditingController pickupLocationController =
      TextEditingController();

  void onLocationChanged() async {
    state.markers.removeWhere((m) => m.markerId == 'pickup');

    if (state.pickupLatLng != null && pickupIcon != null) {
      state.markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: state.pickupLatLng!,
          icon: pickupIcon!,

          infoWindow: InfoWindow(
            title: 'Pickup Location',
            snippet: pickupLocationController.text,
          ),
        ),
      );
    }

    state.markers.removeWhere((m) => m.markerId == 'drop');

    if (state.dropLatLng != null) {
      state.markers.add(
        Marker(
          markerId: const MarkerId('drop'),
          position: state.dropLatLng!,

          infoWindow: InfoWindow(
            title: 'Drop Location',
            snippet: dropLocationController.text,
          ),
        ),
      );
    }

    if (state.pickupLatLng != null && state.dropLatLng != null) {
      state.polylines.clear();

      final result = await polylinePoints.getRouteBetweenCoordinatesV2(
        request: RoutesApiRequest(
          origin: PointLatLng(
            state.pickupLatLng!.latitude,
            state.pickupLatLng!.longitude,
          ),
          destination: PointLatLng(
            state.dropLatLng!.latitude,
            state.dropLatLng!.longitude,
          ),
          travelMode: TravelMode.driving,
        ),
      );

      if (result.primaryRoute != null &&
          result.primaryRoute!.polylinePoints != null) {
        final routePoints = result.primaryRoute!.polylinePoints!
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();

        state.polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: routePoints,
          ),
        );
        state = state.copyWith(
          routeDistanceKm:
              result.primaryRoute!.distanceKm ??
              calculatePolylineDistance(routePoints),
        );

        state = state.copyWith(
          tripDurationMin: ((result.primaryRoute!.duration ?? 0) / 60),
        );
        if (kDebugMode) {
          print(result.primaryRoute!.duration.toString());
          print(state.tripDurationMin.toString());
        }

        fitCameraBounds(routePoints);
      }
    }
  }

  Future<void> _onDriverLocationChanged() async {
    state.markers.removeWhere((m) => m.markerId.value == 'driver');

    if (state.driverLatLng != null) {
      state.markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: state.driverLatLng!,
          icon:
              taxiIcon!, // Use the same icon as for the taxi or any other custom one
          infoWindow: InfoWindow(
            title: 'Driver Location',
            snippet: 'Driver is on the way',
          ),
        ),
      );
    }

    if (state.driverLatLng != null && state.pickupLatLng != null) {
      state.polylines.clear(); // Clear any existing polyline

      final result = await polylinePoints.getRouteBetweenCoordinatesV2(
        request: RoutesApiRequest(
          origin: PointLatLng(
            state.driverLatLng!.latitude,
            state.driverLatLng!.longitude,
          ),
          destination: PointLatLng(
            state.pickupLatLng!.latitude,
            state.pickupLatLng!.longitude,
          ),
          travelMode: TravelMode.driving,
        ),
      );

      if (result.primaryRoute != null &&
          result.primaryRoute!.polylinePoints != null) {
        final routePoints = result.primaryRoute!.polylinePoints!
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();

        state.polylines.add(
          Polyline(
            polylineId: const PolylineId('driverRoute'),
            color: Colors.red, // You can make this different to distinguish it
            width: 5,
            points: routePoints,
          ),
        );

        state = state.copyWith(
          routeDistanceKm:
              result.primaryRoute!.distanceKm ??
              calculatePolylineDistance(routePoints),
        );

        state = state.copyWith(
          tripDurationMin: (result.primaryRoute!.duration ?? 0) / 60,
        );

        fitCameraBounds(routePoints);
      }
    }
  }

  void onSearchTap() {
    state = state.copyWith(status: RideBookingStatus.rideCreating);
  }

  void onCancelDestination() {
    state = state.copyWith(status: RideBookingStatus.initial);
  }

  void onRideCancel() {
    state = state.copyWith(status: RideBookingStatus.initial);
  }

  void selectedPriceModel({required PricingModel selectedPriceModel}) {
    state = state.copyWith(selectedPriceModel: selectedPriceModel);
  }

  void updatePickUpLatLng({required LatLng latlng}) {
    state = state.copyWith(pickupLatLng: latlng);
  }

  void updateDropLatLng({required LatLng latlng}) {
    state = state.copyWith(dropLatLng: latlng);
  }



  void goToCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;
    final position = await Geolocator.getCurrentPosition();

    state = state.copyWith(
      currentLocation: LatLng(position.latitude, position.longitude),
    );

    if (mapController != null && state.currentLocation != null) {
      cameraMove(state.currentLocation!);

      if (currentLocationIcon != null) {
        state.markers.removeWhere(
          (marker) => marker.markerId == 'current_location',
        );
        state.markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: state.currentLocation!,
            icon: currentLocationIcon!,
            infoWindow: const InfoWindow(
              title: 'Your Location',
              snippet: 'You are here',
            ),
          ),
        );
      }
    }
  }

  List<LocationSuggestion> getPopularLocations() {
    return [
      LocationSuggestion(
        name: "Amsterdam Centraal",
        address: "Stationsplein, Amsterdam",
        position: const LatLng(52.3791, 4.9003),
      ),
    ];
  }

  // Price Calculation

  //=========================================
  //
  //========Api calls goining here===========
  //
  //=========================================

  //=========================================
  //
  //======== Create Ride Api post ===========
  //
  //=========================================

  void updateSurgeMultiplier() {
    socketService.emit(SocketEvents.liveCountUpdate, {
      "location": {
        "latitude": state.pickupLatLng!.latitude,
        "longitude": state.pickupLatLng!.longitude,
      },
    });
  }

  void initSurgeMultiplier() {
    socketService.on(SocketEvents.liveCountUpdate, (data) {
      final calculatedSurge =
          (data['rideRequestCount'] ?? 0) / (data['availableDriverCount'] ?? 1);

      state = state.copyWith(
        surgeMultiplier: (calculatedSurge > 1) ? calculatedSurge : 1,
      );
    });
  }

  Future<void> createRide({
    required num distanceFare,
    required num timeFare,
    required num totalFare,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await apiService.post(UserApiEndpoints.createRide, {
        "pickupLocation": {
          "coordinates": [
            state.pickupLatLng!.longitude, // longitude
            state.pickupLatLng!.latitude, // latitude
          ],
          "address": pickupLocationController.text.trim(),
          "type": "Point",
        },
        "dropOffLocation": {
          "coordinates": [
            state.dropLatLng!.longitude, // longitude
            state.dropLatLng!.latitude, // latitude
          ],
          "address": dropLocationController.text.trim(),
          "type": "Point",
        },

        //   category: 'TaxiTil' | 'Comfort' | 'Premium' | 'XL' | 'Pet'
        "category": state.selectedPriceModel!.title,
        "fare": {
          "baseFare": state.selectedPriceModel!.startFare,
          "distanceFare": distanceFare,
          "timeFare": timeFare,
          "surgeMultiplier": 1,
          "totalFare": totalFare,
        },
      });
      final rideResponse = CreateRideResponse.fromJson(response);

      AppLogger.i("Ride created with ID: ${rideResponse.data.id}");
      AppLogger.i("Passenger ID: ${rideResponse.data.passengerId}");

      state = state.copyWith(rideId: rideResponse.data.id);

      socketService.emit(SocketEvents.rideRequest, {
        "rideId": rideResponse.data.id,
      });
      state = state.copyWith(status: RideBookingStatus.searchingDriver);

      socketService.on(SocketEvents.rideAccepted, (data) {
        state = state.copyWith(
          acceptedDriverInfo: RideAcceptResponse.fromJson(data).driverInfo,
        );

        if (state.acceptedDriverInfo != null) {
          state = state.copyWith(
            driverLatLng: LatLng(
              state.acceptedDriverInfo!.location!.coordinates!.last,
              state.acceptedDriverInfo!.location!.coordinates!.first,
            ),
          );
          socketService.on(SocketEvents.driverCurrentLocation, (data) {
            final response = DriverCurrentLocationResponse.fromJson(data);
            state = state.copyWith(
              driverLatLng: LatLng(
                response.driverCurrentLocation.latitude,
                response.driverCurrentLocation.longitude,
              ),
            );
            _onDriverLocationChanged();
          });
          _onDriverLocationChanged();
          state = state.copyWith(status: RideBookingStatus.driverOnTheWay);
        }
      });
    } catch (e) {
      throw Exception(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
