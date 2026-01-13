import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/setting/model/profile_response.dart';

class ProfileRepository extends Repository {
  IApiService apiService;
  ProfileRepository(this.apiService);

  Future<Result<ProfileResponse, Failure>> getProfile() {
    return asyncGuard(() async {
      final response = await apiService.get(DriverApiEndpoints.getProfile);
      return ProfileResponse.fromJson(response);
    });
  }
}
