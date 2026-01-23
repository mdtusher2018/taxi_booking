import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/common_app_pages.dart';
import 'package:taxi_booking/role/common/featured/chat/views/message_view.dart';
import 'package:taxi_booking/role/common/featured/setting/model/profile_response.dart';
import 'package:taxi_booking/role/common/featured/setting/views/edit_profile_view.dart';
import 'package:taxi_booking/role/common/featured/setting/views/privacy_policy.dart';
import 'package:taxi_booking/role/common/featured/setting/views/setting_view.dart';

final commonAppRoutes = [
  GoRoute(
    path: CommonAppRoutes.messagingView,
    builder: (context, state) {
      final reciverId = state.extra as Map<String, dynamic>;
      return MessageView(
        reciverId: reciverId['id'],
        isDriverToDriverConversation: reciverId['isDriverToDriverConversation'],
      );
    },
  ),
  GoRoute(
    path: CommonAppRoutes.settingView,
    builder: (context, state) => SettingView(),
  ),
  GoRoute(
    path: CommonAppRoutes.profileView,
    builder: (context, state) {
      final extra = state.extra as ProfileData;
      return ProfileView(data: extra);
    },
  ),
  GoRoute(
    path: CommonAppRoutes.privacyView,
    builder: (context, state) {
      return PrivacyPolicyView();
    },
  ),
];
