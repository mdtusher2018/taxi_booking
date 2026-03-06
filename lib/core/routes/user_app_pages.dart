import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/common_app_routes.dart';
import 'package:taxi_booking/role/user/featured/authentication/views/authentication_view.dart';
import 'package:taxi_booking/role/user/featured/booking_map/views/booking_map_view.dart';

import 'package:taxi_booking/role/user/featured/splash/splash_view.dart';
import 'package:taxi_booking/core/routes/user_app_routes.dart';
import 'package:taxi_booking/role/user/featured/user_root_view.dart';

final userAppRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: UserAppRoutes.splashView,
    routes: [
      ...commonAppRoutes,
      GoRoute(
        path: UserAppRoutes.splashView,
        builder: (context, state) => UserSplashView(),
      ),

      GoRoute(
        path: UserAppRoutes.rootView,
        builder: (context, state) => UserRootView(),
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
