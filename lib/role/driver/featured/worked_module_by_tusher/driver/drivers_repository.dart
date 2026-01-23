import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver/models/my_drivers_response.dart';

class DriversRepository extends Repository {
  IApiService apiService;
  DriversRepository(this.apiService);
  Future<Result<MyDriversResponse, Failure>> fetchMyDrivers({
    required int page,
  }) async {
    return asyncGuard(() async {
      final response = await apiService.get(DriverApiEndpoints.myDrivers(page));
      return MyDriversResponse.fromJson(response);
    });
  }

  Future<Result<bool, Failure>> assignDrver({
    required String vehicalId,
    required String driverId,
  }) async {
    return asyncGuard(() async {
      await apiService.patch(DriverApiEndpoints.assignDriver(vehicalId), {
        "driverId": driverId,
      });
      return true;
    });
  }

  Future<Result<bool, Failure>> removeDrver({required String driverId}) async {
    return asyncGuard(() async {
      await apiService.delete(DriverApiEndpoints.removeDriver(driverId));
      return true;
    });
  }
}
