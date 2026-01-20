import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/utilitis/common_api_endpoints.dart';
import 'package:taxi_booking/role/common/notifications/notification_model.dart';

class NotificationsRepositoty extends Repository {
  IApiService apiService;
  NotificationsRepositoty(this.apiService);
  Future<Result<NotificationsResponse, Failure>> fetchMyNotifications({
    required int page,
  }) async {
    return asyncGuard(() async {
      final response = await apiService.get(
        CommonApiEndPoints.notification(page),
      );
      return NotificationsResponse.fromJson(response);
    });
  }
}
