import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/role/common/chat/repository/chat_repository.dart';

part 'repository.g.dart';

@riverpod
ChatRepository chatRepository(Ref ref) {
  final socketService = ref.read(socketServiceProvider);
  final apiService = ref.read(apiServiceProvider);
  return ChatRepository(socketService: socketService, apiService: apiService);
}
