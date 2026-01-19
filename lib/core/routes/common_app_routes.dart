import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/common_app_pages.dart';
import 'package:taxi_booking/role/common/chat/views/message_view.dart';

final commonAppRoutes = [
  GoRoute(
    path: CommonAppRoutes.messagingView,
    builder: (context, state) {
      final reciverId = state.extra as Map<String, dynamic>;
      return MessageView(reciverId: reciverId['id']);
    },
  ),
];
