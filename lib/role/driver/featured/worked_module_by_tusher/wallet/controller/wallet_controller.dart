import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/models/revenue_report_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/models/wallet_summary_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/wallet_repository.dart';

part 'wallet_controller.g.dart';

class WalletState {
  final bool loadingSummary;
  final bool loadingChart;

  final WalletSummaryResponse? summary;
  final RevenueReportResponse? chart;

  final String? summaryError;
  final String? chartError;

  const WalletState({
    this.loadingSummary = false,
    this.loadingChart = false,
    this.summary,
    this.chart,
    this.summaryError,
    this.chartError,
  });

  WalletState copyWith({
    bool? loadingSummary,
    bool? loadingChart,
    WalletSummaryResponse? summary,
    RevenueReportResponse? chart,
    String? summaryError,
    String? chartError,
  }) {
    return WalletState(
      loadingSummary: loadingSummary ?? this.loadingSummary,
      loadingChart: loadingChart ?? this.loadingChart,
      summary: summary ?? this.summary,
      chart: chart ?? this.chart,
      summaryError: summaryError,
      chartError: chartError,
    );
  }
}

@riverpod
class WalletController extends _$WalletController {
  late WalletRepository repo;

  @override
  WalletState build() {
    repo = ref.read(walletRepositoryProvider);
    return const WalletState();
  }

  Future<void> fetchWalletData() async {
    fetchWalletSummary();
    fetchRevenueChart();
  }

  Future<void> fetchWalletSummary() async {
    state = state.copyWith(loadingSummary: true, summaryError: null);

    final result = await repo.fetchWalletSummary();

    if (result is FailureResult) {
      final error = ((result as FailureResult).error as Failure);
      state = state.copyWith(
        loadingSummary: false,
        summaryError: error.message,
      );
    }
    state = state.copyWith(
      loadingSummary: false,
      summary: ((result as Success).data as WalletSummaryResponse),
    );
  }

  Future<void> fetchRevenueChart() async {
    state = state.copyWith(loadingChart: true, chartError: null);

    final result = await repo.fetchRevenueChart();

    if (result is FailureResult) {
      final error = ((result as FailureResult).error as Failure);
      state = state.copyWith(loadingChart: false, chartError: error.message);
    }

    state = state.copyWith(
      loadingChart: false,
      chart: ((result as Success).data as RevenueReportResponse),
    );
  }
}
