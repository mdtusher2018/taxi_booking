import 'package:taxi_booking/core/utilitis/common_api_endpoints.dart';

class DriverApiEndpoints {
  // static const String MAP_KEY = 'AIzaSyAYU95zhhNeRjmDdr2AckdfQxz2zm9HHNQ';

  static String mapKey = CommonApiEndPoints.mapKey;
  static const String baseUrl = CommonApiEndPoints.baseUrl;
  static const String baseImageUrl = CommonApiEndPoints.baseImageUrl;
  static const String baseSocketUrl = CommonApiEndPoints.baseSocketUrl;

  // static const String baseUrl = 'http://10.10.10.5:5000/api/v1/';
  // static const String baseImageUrl = 'http://10.10.10.5:5000';

  static const String login = "auth/login";

  static const String signupWithCar = "with-car-drivers/signup";
  static const String signupWithoutCar =
      "without-car/create-without-car-driver";

  static var refreshToken = "auth/refresh-token";

  //vihicals
  static var addVehicale = "vehicles/create-vehicle";

  static String myVehicales(int page) =>
      "vehicles/all-vehicles?limit=10&page=$page";
  static String vehicaleDetails(String id) => "vehicles/details/$id";

  //Drivers
  static String myDrivers(int page) =>
      "with-car-drivers/all-with-car-drivers?page=$page&limit=10";

  static String deleteVehicale(String vehicalId) {
    return "vehicles/delete-vehicle/$vehicalId";
  }

  //Home Ride
  static String driverOnline = "with-car-drivers/update-current-location";

  //chat
  static String previousMessage(String reciverId) =>
      "messages/previous-messages/$reciverId";
}
