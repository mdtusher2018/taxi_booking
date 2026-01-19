import 'package:taxi_booking/core/services/network/api_client.dart';
import 'package:taxi_booking/core/services/network/api_service.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/services/snackbar/i_snackbar_service.dart';
import 'package:taxi_booking/core/services/snackbar/snackbar_service.dart';
import 'package:taxi_booking/core/services/socket/socket_service.dart';
import 'package:taxi_booking/core/services/storage/i_local_storage_service.dart';
import 'package:taxi_booking/core/services/storage/local_storage_service.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
import 'package:taxi_booking/core/routes/driver_app_pages.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'service.g.dart';

@Riverpod(keepAlive: true)
ILocalStorageService localStorageService(Ref ref) {
  return LocalStorageService();
}

@Riverpod(keepAlive: true)
ISnackBarService snackbarService(Ref ref) {
  return SnackBarService();
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final navigatorKey = ref
      .watch(driverAppRouterProvider)
      .routerDelegate
      .navigatorKey;
  return ApiClient(
    baseUrl: DriverApiEndpoints.baseUrl,
    localStorage: ref.watch(localStorageServiceProvider),
    navigatorKey: navigatorKey,
  );
}

@Riverpod(keepAlive: true)
IApiService apiService(Ref ref) {
  return ApiService(
    ref.watch(apiClientProvider),
    baseUrl: DriverApiEndpoints.baseUrl,
  );
}

@Riverpod(keepAlive: true)
SocketService socketService(Ref ref) {
  return SocketService();
}
