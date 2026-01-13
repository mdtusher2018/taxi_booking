import 'package:taxi_booking/core/utilitis/common_api_endpoints.dart';

class UserApiEndpoints {
  // static const String MAP_KEY = 'AIzaSyAYU95zhhNeRjmDdr2AckdfQxz2zm9HHNQ';

  static String mapKey = ApiEndPoints.mapKey;
  static const String baseUrl = ApiEndPoints.baseUrl;
  static const String baseImageUrl = ApiEndPoints.baseImageUrl;
  static const String baseSocketUrl = ApiEndPoints.baseSocketUrl;

  static const String login = "auth/login";

  static const String signup = "users/register";

  static var refreshToken = "auth/refresh-token";

  //======================
  //
  //======== Ride ========
  //
  //======================

  static var createRide = "rides/create-ride";
}
