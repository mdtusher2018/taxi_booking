import 'dart:io';

import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/add_vehical_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/delete_vehical_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/edit_vehical_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/my_vehicals_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/vehicale_details_response.dart';

class VehicalRepository extends Repository {
  IApiService apiService;
  VehicalRepository(this.apiService);

  Future<Result<AddVehicleResponse, Failure>> addVehical({
    required String vehicleMake,
    required String model,
    required int year,
    required String color,
    required String registrationNumber,
    required int numberOfSeats,
    required File registrationDocument,
    required File technicalInspectionCertificate,
    required File insuranceDocument,
    required File frontImage,
    required File rearImage,
    required File interiorImage,
  }) async {
    return asyncGuard(() async {
      final res = await apiService.multipart(
        DriverApiEndpoints.addVehicale,
        body: {
          "vehicleMake": vehicleMake,
          "model": model,
          "year": year,
          "color": color,
          "registrationNumber": registrationNumber,
          "numberOfSeats": numberOfSeats,
        },
        files: {
          'registrationDocument': registrationDocument,
          'technicalInspectionCertificate': technicalInspectionCertificate,
          'insuranceDocument': insuranceDocument,
          'front': frontImage,
          'rear': rearImage,
          'interior': interiorImage,
        },
      );
      return AddVehicleResponse.fromJson(res);
    });
  }

  Future<Result<EditVehicleResponse, Failure>> editVehical({
    required String vehicleMake,
    required String model,
    required int year,
    required String color,
    required String registrationNumber,
    required int numberOfSeats,
    required File registrationDocument,
    required File technicalInspectionCertificate,
    required File insuranceDocument,
    required File frontImage,
    required File rearImage,
    required File interiorImage,
  }) async {
    return asyncGuard(() async {
      final res = await apiService.multipart(
        DriverApiEndpoints.addVehicale,
        body: {
          "vehicleMake": vehicleMake,
          "model": model,
          "year": year,
          "color": color,
          "registrationNumber": registrationNumber,
          "numberOfSeats": numberOfSeats,
        },
        files: {
          'registrationDocument': registrationDocument,
          'technicalInspectionCertificate': technicalInspectionCertificate,
          'insuranceDocument': insuranceDocument,
          'front': frontImage,
          'rear': rearImage,
          'interior': interiorImage,
        },
      );
      return EditVehicleResponse.fromJson(res);
    });
  }

  Future<Result<MyVehiclesResponse, Failure>> getMyVehicals({
    required int page,
    int limit = 10,
  }) async {
    return asyncGuard(() async {
      final response = await apiService.get(
        DriverApiEndpoints.myVehicales(page),
      );
      return MyVehiclesResponse.fromJson(response);
    });
  }

  Future<Result<VehicleResponse, Failure>> vehicalDetails({
    required String vehicalId,
  }) async {
    return asyncGuard(() async {
      final response = await apiService.get(
        DriverApiEndpoints.vehicaleDetails(vehicalId),
      );
      return VehicleResponse.fromJson(response);
    });
  }

  Future<Result<DeleteVehicleResponse, Failure>> deleteVehical({
    required String vehicalId,
  }) async {
    return asyncGuard(() async {
      final response = await apiService.delete(
        DriverApiEndpoints.deleteVehicale(vehicalId),
      );
      return DeleteVehicleResponse.fromJson(response);
    });
  }
}
