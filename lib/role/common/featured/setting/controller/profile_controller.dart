import 'dart:async';

import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/common/di/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/role/common/featured/setting/model/profile_response.dart';
import 'package:taxi_booking/role/common/featured/setting/model/support_info_model.dart';
import 'package:taxi_booking/role/common/featured/setting/repository/profile_repository.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  late ProfileRepository profileRepository;
  @override
  FutureOr<ProfileResponse?> build() {
    profileRepository = ref.watch(profileRepositoryProvider);
    return null;
  }

  Future<void> getProfile() async {
    state = AsyncLoading();
    final result = await profileRepository.getProfile();
    if (result is Success) {
      final profile = (result as Success).data as ProfileResponse;

      final adminInfo = await profileRepository.getAdminInfo();
      if (adminInfo is Success) {
        profile.adminInfo = (adminInfo as Success).data as SupportInfoResponse;
      }
      state = AsyncData(profile);
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
