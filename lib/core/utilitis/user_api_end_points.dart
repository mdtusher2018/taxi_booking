import 'package:taxi_booking/core/utilitis/common_api_endpoints.dart';

class UserApiEndpoints {
  // static const String MAP_KEY = 'AIzaSyAYU95zhhNeRjmDdr2AckdfQxz2zm9HHNQ';

  static String mapKey = CommonApiEndPoints.mapKey;
  static const String baseUrl = CommonApiEndPoints.baseUrl;
  static const String baseImageUrl = CommonApiEndPoints.baseImageUrl;
  static const String baseSocketUrl = CommonApiEndPoints.baseSocketUrl;

  static const String login = "auth/login";

  static const String signup = "users/register";

  static var refreshToken = "auth/refresh-token";

  //======================
  //
  //======== Ride ========
  //
  //======================

  static var createRide = "rides/create-ride";

  static String paymentConfirmed(String rideId) =>
      "payment/confirmed-authorization/$rideId";
  static String payTips(String rideId) => "tips/create-tips/$rideId";

  static String giveReview(String rideId) => "tips/create-feedback/$rideId";
}
