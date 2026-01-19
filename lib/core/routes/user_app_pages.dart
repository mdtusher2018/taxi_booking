import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/common_app_routes.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/authentication/views/authentication_view.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/views/booking_map_view.dart';
import 'package:taxi_booking/role/user/featured/setting/views/setting_view.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/splash/splash_view.dart';
import 'package:taxi_booking/core/routes/user_app_routes.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/user_root_view.dart';

final userAppRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: UserAppRoutes.splashView,
    routes: [
      ...commonAppRoutes,
      GoRoute(
        path: UserAppRoutes.splashView,
        builder: (context, state) => UserSplashView(),
      ),

      GoRoute(path: UserAppRoutes.rootView,
          builder: (context, state) => UserRootView(),
      ),
      GoRoute(
        path: UserAppRoutes.settingView,
        builder: (context, state) => const UserSettingView(),
      ),

      GoRoute(
        path: UserAppRoutes.authenticationView,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          final islogin = extra?['isLogin'] ?? false;

          return UserAuthenticationView(isLoginPage: islogin);
        },
      ),
      GoRoute(
        path: UserAppRoutes.transportSelectionView,
        builder: (context, state) => UserBookingMapView(),
      ),
    ],
  );
});
