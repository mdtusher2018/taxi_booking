import 'package:taxi_booking/core/di/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/repository/auth_repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver/drivers_repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/repository/home_ride_repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/setting/repository/profile_repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/vehical_repository.dart';

part 'repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  final localStorageService = ref.watch(localStorageServiceProvider);
  return AuthRepository(
    api: apiService,
    localStorageService: localStorageService,
  );
}

@riverpod
HomeRideRepository homerideRepository(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  final localStorageService = ref.read(localStorageServiceProvider);
  final socketService = ref.read(socketServiceProvider);
  return HomeRideRepository(
    apiService: apiService,
    localStorageService: localStorageService,
    socketService: socketService,
  );
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProfileRepository(apiService);
}

@riverpod
VehicalRepository vehicalRepository(Ref ref) {
  return VehicalRepository(ref.watch(apiServiceProvider));
}

@riverpod
DriversRepository driversRepository(Ref ref) {
  return DriversRepository(ref.watch(apiServiceProvider));
}
