import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/models/revenue_report_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/models/wallet_by_driver_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/models/wallet_summary_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/wallet_repository.dart';

part 'wallet_controller.g.dart';

class WalletState {
  final bool loadingSummary;
  final bool loadingChart;
  final bool loadingByDriverId;

  final DriverWalletByIdResponse? driverWalletByIdData;
  final WalletSummaryResponse? summary;
  final RevenueReportResponse? chart;

  final String? summaryError;
  final String? chartError;
  final String? driverWalletByIdError;

  const WalletState({
    this.loadingByDriverId = false,
    this.loadingSummary = false,
    this.loadingChart = false,
    this.driverWalletByIdData,
    this.summary,
    this.chart,
    this.summaryError,
    this.chartError,
    this.driverWalletByIdError,
  });

  WalletState copyWith({
    bool? loadingSummary,
    bool? loadingChart,
    bool? loadingByDriverId,
    WalletSummaryResponse? summary,
    RevenueReportResponse? chart,
    DriverWalletByIdResponse? driverWalletByIdData,
    String? summaryError,
    String? chartError,
    String? driverWalletByIdError,
  }) {
    return WalletState(
      loadingByDriverId: loadingByDriverId ?? this.loadingByDriverId,
      loadingSummary: loadingSummary ?? this.loadingSummary,
      loadingChart: loadingChart ?? this.loadingChart,
      driverWalletByIdData: driverWalletByIdData ?? this.driverWalletByIdData,
      summary: summary ?? this.summary,
      chart: chart ?? this.chart,
      summaryError: summaryError,
      chartError: chartError,
      driverWalletByIdError: driverWalletByIdError,
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

  Future<void> driverWalletByIdData({required String driverId}) async {
    state = state.copyWith(
      loadingByDriverId: true,
      driverWalletByIdError: null,
    );

    final result = await repo.fetchDriverWalletById(id: driverId);

    if (result is FailureResult) {
      final error = ((result as FailureResult).error as Failure);
      state = state.copyWith(
        loadingByDriverId: false,
        driverWalletByIdError: error.message,
      );
    }

    state = state.copyWith(
      loadingByDriverId: false,
      driverWalletByIdData:
          ((result as Success).data as DriverWalletByIdResponse),
    );
  }
}
