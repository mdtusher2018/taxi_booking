import 'dart:io';

import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/add_vehical_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/vehical_repository.dart';

part 'add_vehical_controller.g.dart';

@riverpod
class AddVehicalController extends _$AddVehicalController {
  late VehicalRepository repo;

  @override
  FutureOr<AddVehicleResponse?> build() {
    repo = ref.watch(vehicalRepositoryProvider);
    return null;
  }

  Future<void> addVehical({
    required String vehicleMake,
    required String model,
    required int year,
    required String color,
    required String registrationNumber,
    required int numberOfSeats,

    // Documents
    required File registrationDocument,
    required File technicalInspectionCertificate,
    required File insuranceDocument,

    // Images
    required File frontImage,
    required File rearImage,
    required File interiorImage,
  }) async {
    state = AsyncLoading();
    final response = await repo.addVehical(
      vehicleMake: vehicleMake,
      model: model,
      year: year,
      color: color,
      registrationNumber: registrationNumber,
      numberOfSeats: numberOfSeats,
      registrationDocument: registrationDocument,
      technicalInspectionCertificate: technicalInspectionCertificate,
      insuranceDocument: insuranceDocument,
      frontImage: frontImage,
      rearImage: rearImage,
      interiorImage: interiorImage,
    );
    if (response is FailureResult) {
      final error = (response as FailureResult).error as Failure;
      state = AsyncError(
        error.message,
        error.stackTrace ?? StackTrace.fromString("No StackTrace Found"),
      );
    } else if (response is Success) {
      state = AsyncData((response as Success).data as AddVehicleResponse);
    }
  }
}
