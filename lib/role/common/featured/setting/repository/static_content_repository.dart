import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/utilitis/common_api_endpoints.dart';
import 'package:taxi_booking/role/common/featured/setting/model/privacy_policy_model.dart';

class StaticContentRepository extends Repository {
  IApiService apiService;
  StaticContentRepository(this.apiService);

  Future<Result<StaticContentResponse, Failure>> getPrivacyPolicy() {
    return asyncGuard(() async {
      final response = await apiService.get(CommonApiEndPoints.privacyPolicy);
      return StaticContentResponse.fromJson(response);
    });
  }

  Future<Result<StaticContentResponse, Failure>> getAboutUs() {
    return asyncGuard(() async {
      final response = await apiService.get(CommonApiEndPoints.aboutUs);
      return StaticContentResponse.fromJson(response);
    });
  }

  Future<Result<StaticContentResponse, Failure>> getTermsAndCondition() {
    return asyncGuard(() async {
      final response = await apiService.get(
        CommonApiEndPoints.termsAndCondition,
      );
      return StaticContentResponse.fromJson(response);
    });
  }
}
