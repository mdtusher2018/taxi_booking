import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/services/socket/socket_events.dart';
import 'package:taxi_booking/core/services/socket/socket_service.dart';
import 'package:taxi_booking/core/services/storage/i_local_storage_service.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/controller/badge_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/driver_online_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/model/ride_request_response.dart';

class HomeRideRepository extends Repository {
  final IApiService apiService;
  final ILocalStorageService localStorageService;
  final SocketService socketService;

  HomeRideRepository({
    required this.apiService,
    required this.localStorageService,
    required this.socketService,
  });

  Future<Result<DriverOnlineResponse, Failure>> driverOnline({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    return asyncGuard(() async {
      final res = await apiService.patch(DriverApiEndpoints.driverOnline, {
        "coordinates": [
          longitude, // longitude
          latitude, // latitude
        ],
        "address": address,
      });
      return DriverOnlineResponse.fromJson(res);
    });
  }

  Stream<RideRequestResponse> listenToRideRequest() {
    final StreamController<RideRequestResponse> controller =
        StreamController<RideRequestResponse>();
    socketService.on(SocketEvents.rideRequest, (data) {
      if (data != null) {
        final rideRequestResponse = RideRequestResponse.fromJson(data);
        controller.add(rideRequestResponse);
      }
    });

    return controller.stream;
  }

  void listenMessageBadge({
    required String receiverId,
    required WidgetRef ref,
  }) {
    socketService.on(SocketEvents.newMessage, (data) {
      if (data != null) {
        /// Trigger badge
        ref.read(chatBadgeControllerProvider.notifier).showBadge();

        /// Optional: refresh chat data
        socketService.emit(SocketEvents.getChatByReciverId, {
          "receiverId": receiverId,
        });
      }
    });
  }

  void stopListenToRideRequest() {
    socketService.off(SocketEvents.rideRequest);
  }

  void rideAccept({required String rideId}) {
    socketService.emit(SocketEvents.rideAccepted, {
      {"accepted": true, "rideId": rideId},
    });
    socketService.off(SocketEvents.rideRequest);
  }

  void rideDecline({required String rideId}) {
    throw UnimplementedError("rideDecline is not implemented yet");
  }

  void updateDriverLocation({
    required double latitude,
    required double longitude,
    required String rideId,
    required String passengerId,
    required double averageSpeedKmPH,
  }) {
    socketService.emit(SocketEvents.updateDriverLocation, {
      "latitude": latitude,
      "longitude": longitude,
      'passengerId': passengerId,
      "rideId": rideId,
      "averageSpeedKmPH": averageSpeedKmPH,
    });
  }

  void startRide({
    required double latitude,
    required double longitude,
    required String rideId,
    required double averageSpeedKmPH,
  }) {
    socketService.emit(SocketEvents.rideStarted, {
      "latitude": latitude,
      "longitude": longitude,
      "rideId": rideId,
      "averageSpeedKmPH": averageSpeedKmPH,
    });
  }

  void endRide({required String rideId}) {
    socketService.emit(SocketEvents.rideEnded, {"rideId": rideId});
  }
}
