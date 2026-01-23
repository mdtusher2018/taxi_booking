import 'dart:async';

import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/core/pagination/paginated_async_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/all_vehicals_response.dart';

final allVehiclesControllerProvider =
    AsyncNotifierProvider<AllVehiclesController, PaginationState<Vehicle>>(
      AllVehiclesController.new,
    );

class AllVehiclesController extends PaginatedAsyncNotifier<Vehicle> {
  @override
  Future<PaginationState<Vehicle>> build() async {
    return const PaginationState<Vehicle>();
  }

  @override
  Future<Result<List<Vehicle>, Failure>> fetchPage(int page) async {
    final repo = ref.watch(vehicalRepositoryProvider);
    final result = await repo.getAllVehicals(page: page);
    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      return FailureResult(error);
    }
    return Success(((result as Success).data as AllVehiclesResponse).data);
  }
}
