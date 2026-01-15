import 'dart:async';

import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/services/socket/socket_events.dart';
import 'package:taxi_booking/core/services/socket/socket_service.dart';
import 'package:taxi_booking/core/services/storage/i_local_storage_service.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
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
    socketService.emit(SocketEvents.rideAccepted, {
      {"accepted": false, "rideId": rideId},
    });
  }

  void updateDriverLocation({
    required double latitude,
    required double longitude,
    required String rideId,
    required double averageSpeedKmPH,
  }) {
    AppLogger.i("Updating driver location: Lat:$latitude, Lng:$longitude");
    socketService.emit(SocketEvents.rideAccepted, {
      "latitude": latitude,
      "longitude": longitude,
      "rideId": rideId,
      "averageSpeedKmPH": averageSpeedKmPH,
    });
  }
}
