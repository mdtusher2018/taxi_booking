import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/utilitis/common_api_endpoints.dart';
import 'package:taxi_booking/role/common/featured/ride_history/ride_history_model.dart';

class RideHistoryRepository extends Repository {
  IApiService apiService;
  RideHistoryRepository(this.apiService);
  Future<Result<RideHistoryResponse, Failure>> fetchRideHistory({
    required int page,
  }) async {
    return asyncGuard(() async {
      final response = await apiService.get(
        CommonApiEndPoints.rideHistory(page),
      );
      return RideHistoryResponse.fromJson(response);
    });
  }
}
