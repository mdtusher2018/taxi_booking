import 'dart:async';
import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/services/socket/socket_events.dart';
import 'package:taxi_booking/core/services/socket/socket_service.dart';
import 'package:taxi_booking/core/services/storage/i_local_storage_service.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
import 'package:taxi_booking/role/common/featured/chat/model/message_response_model.dart';
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

  Stream<ChatMessage> listenMessageBadge({required String receiverId}) {
    final StreamController<ChatMessage> controller =
        StreamController<ChatMessage>();
    socketService.on(SocketEvents.unreadMessage, (data) {
      if (data != null) {
        final message = ChatMessage.fromJson(data);
        controller.add(message);
      }
    });
    return controller.stream;
  }

  void stopListenToRideRequest() {
    socketService.off(SocketEvents.rideRequest);
  }

  void rideAccept({required String rideId}) async {
    await socketService.emit(SocketEvents.rideAccepted, {
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

  Stream<bool> reachedPickupLocation() {
    final StreamController<bool> controller = StreamController<bool>();
    socketService.on(SocketEvents.driverArrived, (data) {
      if (data != null) {
        controller.add(true);
        socketService.off(SocketEvents.driverArrived);
      }
    });
    return controller.stream;
  }

  void updateDriverLocationAfterRideStart({
    required double latitude,
    required double longitude,
    required String rideId,
    required String passengerId,
    required double averageSpeedKmPH,
  }) {
    socketService.emit(SocketEvents.updateDriverLocationAfterRideStart, {
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
    required Function(dynamic response)? onSuccess,
  }) async {
    await socketService.emit(SocketEvents.rideStarted, {
      "latitude": latitude,
      "longitude": longitude,
      "rideId": rideId,
      "averageSpeedKmPH": averageSpeedKmPH,
    });
  }

  void endRide({
    required String rideId,
    required Function(dynamic response)? onSuccess,
  }) async {
    await socketService.emit(SocketEvents.rideEnded, {"rideId": rideId});
  }
}
