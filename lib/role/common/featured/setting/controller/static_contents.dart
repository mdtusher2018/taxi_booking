import 'dart:async';

import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/common/di/repository.dart';
import 'package:taxi_booking/role/common/featured/setting/model/privacy_policy_model.dart';
import 'package:taxi_booking/role/common/featured/setting/repository/static_content_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'static_contents.g.dart';

@riverpod
class StaticContentsController extends _$StaticContentsController {
  late StaticContentRepository repository;
  @override
  FutureOr build() {
    repository = ref.watch(staticContentRepositoryProvider);
    return null;
  }

  Future<void> getPrivacyPolicy() async {
    state = AsyncLoading();
    final result = await repository.getPrivacyPolicy();
    if (result is Success) {
      state = AsyncData((result as Success).data as PrivacyPolicyResponse);
    } else if (result is Failure) {
      final error = (result as FailureResult).error as Failure;
      state = AsyncError(
        error.message,
        error.stackTrace ?? StackTrace.fromString("No trace found"),
      );
    }
    result;
  }
}
