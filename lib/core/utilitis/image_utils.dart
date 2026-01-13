import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';

String getFullImagePath(String imagePath) {
  if (imagePath.isEmpty) {
    return "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg";
  }
  if (imagePath.contains("public")) {
    imagePath = imagePath.replaceFirst("public", "");
  }

  if (imagePath.startsWith('http')) {
    return imagePath;
  }
  if (imagePath.startsWith('/')) {
    return '${DriverApiEndpoints.baseImageUrl}$imagePath';
  }
  return '${DriverApiEndpoints.baseImageUrl}/$imagePath';
}
