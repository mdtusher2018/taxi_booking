import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/core/base/base_notifier.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/utilitis/common_api_endpoints.dart';
import 'package:taxi_booking/role/common/featured/ride_details/ride_details_response.dart';

final rideDetailsControllerProvider = Provider<RideDetailsController>(
  (ref) => RideDetailsController(
    apiService: ref.read(apiServiceProvider),
    snackBarService: ref.read(snackbarServiceProvider),
  ),
);

class RideDetailsController extends BaseNotifier {
  final IApiService apiService;
  RideDetailsController({
    required super.snackBarService,
    required this.apiService,
  }) : super(null);

  Future<RideDetailsResponse?> getRideDetails(String rideId) async {
    return await safeCall<RideDetailsResponse>(
      task: () async {
        final res = await apiService.get(
          CommonApiEndPoints.rideDetails(rideId),
        );
        return RideDetailsResponse.fromJson(res);
      },
    );
  }
}
