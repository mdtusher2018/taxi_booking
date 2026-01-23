import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/role/common/featured/chat/repository/chat_repository.dart';
import 'package:taxi_booking/role/common/featured/notifications/notifications_repositoty.dart';
import 'package:taxi_booking/role/common/featured/ride_history/ride_history_repository.dart';
import 'package:taxi_booking/role/common/featured/setting/repository/profile_repository.dart';
import 'package:taxi_booking/role/common/featured/setting/repository/static_content_repository.dart';

part 'repository.g.dart';

@riverpod
ChatRepository chatRepository(Ref ref) {
  final socketService = ref.read(socketServiceProvider);
  final apiService = ref.read(apiServiceProvider);
  return ChatRepository(socketService: socketService, apiService: apiService);
}

@riverpod
NotificationsRepositoty notificationRepository(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  return NotificationsRepositoty(apiService);
}

@riverpod
RideHistoryRepository rideHistoryRepository(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  return RideHistoryRepository(apiService);
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProfileRepository(apiService);
}

@riverpod
StaticContentRepository staticContentRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return StaticContentRepository(apiService);
}
