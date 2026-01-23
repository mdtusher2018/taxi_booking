import 'dart:async';

import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/core/pagination/paginated_async_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/my_vehicals_response.dart';

final myVehiclesControllerProvider =
    AsyncNotifierProvider<MyVehiclesController, PaginationState<Vehicle>>(
      MyVehiclesController.new,
    );

class MyVehiclesController extends PaginatedAsyncNotifier<Vehicle> {
  @override
  Future<PaginationState<Vehicle>> build() async {
    return const PaginationState<Vehicle>();
  }

  @override
  Future<Result<List<Vehicle>, Failure>> fetchPage(int page) async {
    final repo = ref.watch(vehicalRepositoryProvider);
    final result = await repo.getMyVehicals(page: page);
    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      return FailureResult(error);
    }
    return Success(((result as Success).data as MyVehiclesResponse).data);
  }

  Future<void> assignDriver({
    required String vehicalId,
    required String driverId,
  }) async {
    final result = await ref
        .read(driversRepositoryProvider)
        .assignDrver(vehicalId: vehicalId, driverId: driverId);

    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      FailureResult(error);
      ref.read(snackbarServiceProvider).showError(error.message);
    } else {
      ref.read(snackbarServiceProvider).showSuccess("Assigned Sucessfully");
    }
  }
}
