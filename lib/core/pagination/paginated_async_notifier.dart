import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_async_notifier.freezed.dart';

@freezed
abstract class PaginationState<T> with _$PaginationState<T> {
  const factory PaginationState({
    @Default([]) List<T> items,
    @Default(1) int page,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = _PaginationState;
}

abstract class PaginatedAsyncNotifier<T>
    extends AsyncNotifier<PaginationState<T>> {
  @override
  Future<PaginationState<T>> build();

  /// Repository fetch
  Future<Result<List<T>, Failure>> fetchPage(int page);

  /// Initial load
  Future<void> load() async {
    state = const AsyncLoading();

    final result = await fetchPage(1);

    if (result is FailureResult) {
      final failure = (result as FailureResult).error as Failure;
      state = AsyncError(
        failure.message,
        failure.stackTrace ?? StackTrace.fromString("No trace found"),
      );
    } else if (result is Success) {
      final items = (result as Success).data as List<T>;
      state = AsyncData(
        PaginationState(items: items, page: 1, hasMore: items.isNotEmpty),
      );
    }
  }

  /// Load more
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final nextPage = current.page + 1;
    final result = await fetchPage(nextPage);

    if (result is FailureResult) {
      final failure = (result as FailureResult).error as Failure;
      state = AsyncError(
        failure.message,
        failure.stackTrace ?? StackTrace.fromString("No trace found"),
      );
    } else if (result is Success) {
      final items = (result as Success).data as List<T>;
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...items],
          page: nextPage,
          hasMore: items.isNotEmpty,
          isLoadingMore: false,
        ),
      );
    }
  }

  Future<void> refresh() => load();
}
