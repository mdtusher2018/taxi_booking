import 'package:taxi_booking/core/utilitis/common_api_endpoints.dart';

class DriverApiEndpoints {
  // static const String MAP_KEY = 'AIzaSyAYU95zhhNeRjmDdr2AckdfQxz2zm9HHNQ';

  static String mapKey = CommonApiEndPoints.mapKey;
  static const String baseUrl = CommonApiEndPoints.baseUrl;
  static const String baseImageUrl = CommonApiEndPoints.baseImageUrl;
  static const String baseSocketUrl = CommonApiEndPoints.baseSocketUrl;

  static const String login = "auth/login";

  static const String signupWithCar = "with-car-drivers/signup";
  static const String signupWithoutCar =
      "without-car/create-without-car-driver";

  static var refreshToken = "auth/refresh-token";

  //vihicals
  static var addVehicale = "vehicles/create-vehicle";

  static String myVehicales(int page) =>
      "vehicles/my-vehicles?limit=10&page=$page";

  static String allVehicales(int page) =>
      "vehicles/all-vehicles?limit=10&page=$page";
  static String vehicaleDetails(String id) => "vehicles/details/$id";

  static String deleteVehicale(String vehicalId) {
    return "vehicles/delete-vehicle/$vehicalId";
  }

  //Drivers
  static String myDrivers(int page) =>
      "with-car-drivers/my-assigned-drivers?page=$page&limit=10";

  static String removeDriver(String driverId) {
    return "with-car-drivers/remove-driver/$driverId";
  }

  static String assignDriver(String vehicalId) {
    return "with-car-drivers/assign-vehicle/$vehicalId";
  }

  //Home Ride
  static String driverOnline = "with-car-drivers/update-current-location";

  static String walletSummary = "with-car-drivers/calculate-wallet";
  static String revenueChart = "with-car-drivers/full-year-revenue-reports";

  //chat
  static String previousMessage(String reciverId) =>
      "messages/previous-messages/$reciverId";
}
