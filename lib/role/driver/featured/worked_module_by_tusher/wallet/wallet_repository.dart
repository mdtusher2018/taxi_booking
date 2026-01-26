import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/models/revenue_report_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/wallet/models/wallet_summary_response.dart';

class WalletRepository extends Repository {
  final IApiService apiService;
  WalletRepository({required this.apiService});

  Future<Result<WalletSummaryResponse, Failure>> fetchWalletSummary() async {
    return await asyncGuard(() async {
      final response = await apiService.get(DriverApiEndpoints.walletSummary);
      return WalletSummaryResponse.fromJson(response);
    });
  }

  Future<Result<RevenueReportResponse, Failure>> fetchRevenueChart() async {
    return await asyncGuard(() async {
      final response = await apiService.get(DriverApiEndpoints.revenueChart);
      return RevenueReportResponse.fromJson(response);
    });
  }
}
