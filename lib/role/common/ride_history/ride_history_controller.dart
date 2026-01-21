import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/pagination/paginated_async_notifier.dart';
import 'package:taxi_booking/role/common/di/repository.dart';
import 'package:taxi_booking/role/common/ride_history/ride_history_model.dart';
import 'package:taxi_booking/role/common/ride_history/ride_history_repository.dart';

final rideHistoryControllerProvider =
    AsyncNotifierProvider<RideHistoryController, PaginationState<Ride>>(
      RideHistoryController.new,
    );

class RideHistoryController extends PaginatedAsyncNotifier<Ride> {
  late RideHistoryRepository repository;

  @override
  Future<PaginationState<Ride>> build() async {
    repository = ref.read(rideHistoryRepositoryProvider);
    return PaginationState<Ride>();
  }

  @override
  Future<Result<List<Ride>, Failure>> fetchPage(int page) async {
    final result = await repository.fetchRideHistory(page: page);
    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      return FailureResult(error);
    }
    return Success(((result as Success).data as RideHistoryResponse).result);
  }
}
