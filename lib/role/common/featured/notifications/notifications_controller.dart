import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/pagination/paginated_async_notifier.dart';
import 'package:taxi_booking/role/common/di/repository.dart';
import 'package:taxi_booking/role/common/featured/notifications/notification_model.dart';
import 'package:taxi_booking/role/common/featured/notifications/notifications_repositoty.dart';

final myNotificationsControllerProvider =
    AsyncNotifierProvider<
      NotificationsController,
      PaginationState<NotificationItem>
    >(NotificationsController.new);

class NotificationsController extends PaginatedAsyncNotifier<NotificationItem> {
  late NotificationsRepositoty repository;

  @override
  Future<PaginationState<NotificationItem>> build() async {
    repository = ref.read(notificationRepositoryProvider);
    return PaginationState<NotificationItem>();
  }

  @override
  Future<Result<List<NotificationItem>, Failure>> fetchPage(int page) async {
    final result = await repository.fetchMyNotifications(page: page);
    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      return FailureResult(error);
    }
    return Success(((result as Success).data as NotificationsResponse).data);
  }
}
