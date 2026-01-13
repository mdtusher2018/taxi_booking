import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/role/user/featured/authentication/views/authentication_view.dart';
import 'package:taxi_booking/role/user/featured/booking_map/views/booking_map_view.dart';
import 'package:taxi_booking/role/user/featured/dashboard/views/dashboard_view.dart';
import 'package:taxi_booking/role/user/featured/setting/views/setting_view.dart';

import 'package:taxi_booking/role/user/featured/splash/views/splash_view.dart';
import 'package:taxi_booking/role/user/routes/user_app_routes.dart';

final userAppRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: UserAppRoutes.rootView,
    routes: [
      GoRoute(
        path: UserAppRoutes.splashView,
        builder: (context, state) => UserSplashView(),
      ),

      GoRoute(
        path: UserAppRoutes.rootView,
        builder: (context, state) => UserDashboardView(),
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
