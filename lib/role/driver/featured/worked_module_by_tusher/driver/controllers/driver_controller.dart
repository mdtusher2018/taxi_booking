import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/core/pagination/paginated_async_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver/models/my_drivers_response.dart';

final myDriversControllerProvider =
    AsyncNotifierProvider<MyDriversController, PaginationState<AssignedDriver>>(
      MyDriversController.new,
    );

class MyDriversController extends PaginatedAsyncNotifier<AssignedDriver> {
  @override
  Future<PaginationState<AssignedDriver>> build() async {
    return PaginationState<AssignedDriver>();
  }

  @override
  Future<Result<List<AssignedDriver>, Failure>> fetchPage(int page) async {
    final repo = ref.watch(driversRepositoryProvider);
    final result = await repo.fetchMyDrivers(page: page);
    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      return FailureResult(error);
    }
    return Success(((result as Success).data as MyDriversResponse).data.result);
  }
}
