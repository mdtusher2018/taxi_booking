import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';

String getFullImagePath(String imagePath) {
  if (imagePath.isEmpty) {
    return "https://www.ncenet.com/wp-content/uploads/2020/04/no-image-png-2.png";
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
