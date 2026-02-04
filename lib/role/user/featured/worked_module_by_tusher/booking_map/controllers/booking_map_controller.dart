// booking_map_controller.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/services/socket/socket_events.dart';
import 'package:taxi_booking/core/services/socket/socket_service.dart';
import 'package:taxi_booking/core/utilitis/enum/payment_status_enums.dart';
import 'package:taxi_booking/core/utilitis/enum/use_enums.dart';
import 'package:taxi_booking/core/utilitis/helper.dart';
import 'package:taxi_booking/core/utilitis/user_api_end_points.dart';
import 'package:taxi_booking/core/utilitis/mixin/map_mixin.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/controllers/booking_map_state.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/model/create_ride_response.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/model/driver_live_location_update.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/model/pricing_model.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/model/tips_model.dart';
import '../model/driver_info_model.dart';

final bookingMapControllerProvider =
    StateNotifierProvider.autoDispose<BookingMapController, BookingMapState>((
      ref,
    ) {
      ref.keepAlive();
      return BookingMapController(
        apiService: ref.read(apiServiceProvider),
        socketService: ref.read(socketServiceProvider),
      );
    });

class BookingMapController extends StateNotifier<BookingMapState>
    with MapMixin {
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

  Future<void> onPicupPickoffLocationChanged() async {
    // ----- MARKERS -----
    final updatedMarkers = Set<Marker>.from(state.markers);

    updatedMarkers.removeWhere((m) => m.markerId.value == 'pickup');
    if (state.pickupLatLng != null && pickupIcon != null) {
      updatedMarkers.add(
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

    // Remove old drop marker
    updatedMarkers.removeWhere((m) => m.markerId.value == 'drop');

    // Add drop marker
    if (state.dropLatLng != null) {
      updatedMarkers.add(
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

    // Update markers in state
    state = state.copyWith(markers: updatedMarkers);

    // ----- POLYLINES -----
    if (state.pickupLatLng != null && state.dropLatLng != null) {
      final updatedPolylines = <Polyline>{};

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

      if (result.primaryRoute?.polylinePoints != null) {
        final routePoints = result.primaryRoute!.polylinePoints!
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();

        updatedPolylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: routePoints,
          ),
        );

        state = state.copyWith(
          polylines: updatedPolylines,
          routeDistanceKm:
              result.primaryRoute!.distanceKm ??
              calculatePolylineDistance(routePoints),
          tripDurationMin: ((result.primaryRoute!.duration ?? 0) / 60),
        );

        if (kDebugMode) {
          print(result.primaryRoute!.duration);
          print(state.tripDurationMin);
        }

        fitCameraBounds(routePoints);
      }
    }
  }

  Future<void> onDriverLocationChanged() async {
    // ----- MARKERS -----
    final updatedMarkers = Set<Marker>.from(state.markers);

    // Remove old driver marker
    updatedMarkers.removeWhere((m) => m.markerId.value == 'driver');

    // Add updated driver marker
    if (state.driverLatLng != null && taxiIcon != null) {
      updatedMarkers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: state.driverLatLng!,
          icon: taxiIcon!,
          infoWindow: const InfoWindow(
            title: 'Driver Location',
            snippet: 'Driver is on the way',
          ),
        ),
      );
    }

    // Update markers in state
    state = state.copyWith(markers: updatedMarkers);

    // ----- POLYLINES -----
    if (state.driverLatLng != null && state.pickupLatLng != null) {
      final updatedPolylines = <Polyline>{};

      final result = await polylinePoints.getRouteBetweenCoordinatesV2(
        request: RoutesApiRequest(
          origin: PointLatLng(
            state.driverLatLng!.latitude,
            state.driverLatLng!.longitude,
          ),
          destination: (state.status == RideBookingStatus.rideStarted)
              ? PointLatLng(
                  state.dropLatLng!.latitude,
                  state.dropLatLng!.longitude,
                )
              : PointLatLng(
                  state.pickupLatLng!.latitude,
                  state.pickupLatLng!.longitude,
                ),
          travelMode: TravelMode.driving,
        ),
      );

      if (result.primaryRoute?.polylinePoints != null) {
        final routePoints = result.primaryRoute!.polylinePoints!
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();

        updatedPolylines.add(
          Polyline(
            polylineId: const PolylineId('driverRoute'),
            color: Colors.red,
            width: 5,
            points: routePoints,
          ),
        );

        state = state.copyWith(
          polylines: updatedPolylines,
          routeDistanceKm:
              result.primaryRoute!.distanceKm ??
              calculatePolylineDistance(routePoints),
          tripDurationMin: (result.primaryRoute!.duration ?? 0) / 60,
        );
      }
    }
  }

  void onSearchTap() {
    state = state.copyWith(status: RideBookingStatus.rideCreating);
  }

  void onCancelDestination() {
    state = state.copyWith(status: RideBookingStatus.initial);
  }

  Future<bool> onRideCancel() async {
    try {
      await socketService.emit(SocketEvents.rideCancelled, {
        "rideId": state.rideId,
      });
      state = state.copyWith(status: RideBookingStatus.initial);
      return true;
    } catch (e) {
      CustomToast.showToast(message: e.toString());
      return false;
    }
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
    final position = await getCurrentLocation();
    if (position == null) return;

    state = state.copyWith(
      currentLocation: LatLng(position.latitude, position.longitude),
    );

    if (mapController != null && state.currentLocation != null) {
      cameraMove(state.currentLocation!);

      if (currentLocationIcon != null) {
        state.markers.removeWhere(
          (marker) => marker.markerId.value == 'current_location',
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

      state = state.copyWith(
        rideId: rideResponse.data.id,
        status: RideBookingStatus.paymentAuthoriging,
        checkoutUrl: rideResponse.data.checkoutUrl,
      );
      AppLogger.i("Ride created with ID: ${rideResponse.data.id}");
    } catch (e) {
      state = state.copyWith(status: RideBookingStatus.initial);
      CustomToast.showToast(message: e.toString(), isError: true);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void rideEnd() {
    state = state.copyWith(status: RideBookingStatus.rideEnded);
  }

  void clearUnreadMessage() {
    state = state.copyWith(haveUnreadMessage: false);
  }

  Future<void> rideEmit(PaymentResult? result) async {
    try {
      if (result == PaymentResult.success) {
        state = state.copyWith(isLoading: true);
        await socketService.emit(SocketEvents.rideRequest, {
          "rideId": state.rideId,
        });

        state = state.copyWith(status: RideBookingStatus.searchingDriver);

        socketService.on(SocketEvents.rideAccepted, (data) {
          final driverInfo = RideAcceptResponse.fromJson(data).driverInfo;

          socketService.on(SocketEvents.driverCurrentLocation, (data) {
            AppLogger.i(data.toString());
            final response = DriverCurrentLocationResponse.fromJson(data);
            state = state.copyWith(
              driverLatLng: LatLng(
                response.driverCurrentLocation.latitude,
                response.driverCurrentLocation.longitude,
              ),
            );
            onDriverLocationChanged();
          });

          socketService.on(SocketEvents.newMessage, (data) {
            state = state.copyWith(haveUnreadMessage: true);
          });

          socketService.on(SocketEvents.driverArrived, (data) {
            Set<Marker> updatedMarkers = Set<Marker>.from(state.markers);

            updatedMarkers.removeWhere((m) => m.markerId.value == 'pickup');
            state = state.copyWith(
              markers: updatedMarkers,
              status: RideBookingStatus.driverArived,
            );
          });
          socketService.on(SocketEvents.updateDriverLocationAfterRideStart, (
            data,
          ) {
            AppLogger.i(data.toString());

            final response = DriverCurrentLocationResponse.fromJson(data);
            state = state.copyWith(
              driverLatLng: LatLng(
                response.driverCurrentLocation.latitude,
                response.driverCurrentLocation.longitude,
              ),
            );
            onDriverLocationChanged();
          });

          socketService.on(SocketEvents.rideStarted, (data) {
            state = state.copyWith(status: RideBookingStatus.rideStarted);
            onDriverLocationChanged();
          });

          socketService.on(SocketEvents.unreadMessage, (data) {});

          socketService.on(SocketEvents.driverArrivedDropLocation, (data) {
            Set<Marker> updatedMarkers = Set<Marker>.from(state.markers);
            updatedMarkers.removeWhere((m) => m.markerId.value == 'drop');
            state = state.copyWith(
              markers: updatedMarkers,
              status: RideBookingStatus.destinationReached,
            );
          });

          // socketService.on(SocketEvents.rideEnded, (data) {
          //   state = state.copyWith(status: RideBookingStatus.giveReview);
          // });

          if (driverInfo != null) {
            state = state.copyWith(
              acceptedDriverInfo: driverInfo,
              driverLatLng: LatLng(
                driverInfo.location!.coordinates!.last,
                driverInfo.location!.coordinates!.first,
              ),
            );

            onDriverLocationChanged();
            state = state.copyWith(status: RideBookingStatus.driverOnTheWay);
          }
        });
      } else {
        CustomToast.showToast(message: "Payment Authorization Faield");
        state = state.copyWith(status: RideBookingStatus.initial);
      }
    } catch (e) {
      CustomToast.showToast(message: e.toString(), isError: true);
      state = state.copyWith(status: RideBookingStatus.initial);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> paymentConfirm() async {
    final response = await apiService.post(
      UserApiEndpoints.paymentConfirmed(state.rideId),
      {},
    );

    if (response['success'] == true) {
      state = state.copyWith(status: RideBookingStatus.giveReview);
    } else {
      CustomToast.showToast(message: "Payment Confirmed Failed,Try again");
    }
  }

  Future<void> giveReview({
    required num ratting,
    required String review,
  }) async {
    AppLogger.i("ratting: $ratting\n Review: $review");
    final response = await apiService.post(
      UserApiEndpoints.giveReview(state.rideId),
      {"rating": ratting, "note": review},
    );

    if (response['statusCode'] == 201) {
      state = state.copyWith(status: RideBookingStatus.tipProcessing);
    } else {
      CustomToast.showToast(message: "Feedback Faield,Try again");
    }
  }

  Future<void> payTips({required num tipAmount}) async {
    final response = await apiService.post(
      UserApiEndpoints.payTips(state.rideId),
      {"tipAmount": tipAmount},
    );

    if (response['statusCode'] == 201) {
      state = state.copyWith(
        tipCheckoutUrl: TipsResponse.fromJson(response).data.checkoutUrl,
      );
    } else {
      CustomToast.showToast(
        message: response['message'] ?? "Field to Tip Compleate, Try again",
      );
    }
  }
}
