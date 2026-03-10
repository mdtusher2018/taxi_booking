import 'package:taxi_booking/core/base/base_notifier.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';

class StripeConnectWebviewController extends BaseNotifier {
  final IApiService apiService;
  StripeConnectWebviewController({
    required super.snackBarService,
    required this.apiService,
  }) : super(null);

  Future<String?> connectStripe() async {
    return await safeCall<String>(
      task: () async {
        final res = await apiService.patch(
          DriverApiEndpoints.stripeConnect,
          {},
        );
        return res['data']?['url'];
      },
    );
  }
}
