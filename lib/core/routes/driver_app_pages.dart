import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/common_app_routes.dart';
import 'package:taxi_booking/role/driver/featured/driver_root_view.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/views/home_view.dart';
import 'package:taxi_booking/role/driver/featured/splash/driver_splash_view.dart';
import 'package:taxi_booking/role/driver/featured/authentication/views/authentication_view.dart';
import 'package:taxi_booking/role/driver/featured/authentication/views/document_upload_view.dart';
import 'package:taxi_booking/role/driver/featured/authentication/views/driving_license_and_business_info_view.dart';
import 'package:taxi_booking/role/driver/featured/authentication/views/email_verification_view.dart';
import 'package:taxi_booking/role/driver/featured/authentication/views/transport_selection_view.dart';
import 'package:taxi_booking/role/driver/featured/driver/view/my_drivers.dart';
import 'package:taxi_booking/core/routes/driver_app_routes.dart';
import 'package:taxi_booking/role/driver/featured/vehicals/view/all_vehicales_view.dart';
import 'package:taxi_booking/role/driver/featured/vehicals/view/my_vehicales_view.dart';

final driverAppRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: DriverAppRoutes.splashView,
    routes: [
      ...commonAppRoutes,
      GoRoute(
        path: DriverAppRoutes.splashView,
        builder: (context, state) => DriverSplashView(),
      ),

      GoRoute(
        path: DriverAppRoutes.driverRoot,
        builder: (context, state) => DriverRootView(),
      ),
      GoRoute(
        path: DriverAppRoutes.homeView,
        builder: (context, state) => DriverHomeView(),
      ),

      GoRoute(
        path: DriverAppRoutes.authenticationView,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          final islogin = extra?['isLogin'] ?? false;

          return DriverAuthenticationView(isLoginPage: islogin);
        },
      ),
      GoRoute(
        path: DriverAppRoutes.transportSelectionView,
        builder: (context, state) => DriverTransportSelectionView(),
      ),
      GoRoute(
        path: DriverAppRoutes.myVehicals,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isForAssign = extra?['isForAssign'] ?? false;
          return MyVehiclesView(isForAssign: isForAssign);
        },
      ),
      GoRoute(
        path: DriverAppRoutes.allVehicals,
        builder: (context, state) {
          return AllVehiclesView();
        },
      ),
      GoRoute(
        path: DriverAppRoutes.drivingLicenseAndBusinessInfoView,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          final withCar = extra?['withCar'] ?? false;
          return DrivingLicenseAndBusinessInfoView(withCar: withCar);
        },
      ),
      GoRoute(
        path: DriverAppRoutes.emailVerificationView,

        builder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          final phoneNumber = extra?['phoneNumber'] ?? "";
          return EmailVerificationView(phoneNumber: phoneNumber);
        },
      ),

      GoRoute(
        path: DriverAppRoutes.documentUploadView,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          final withCar = extra?['withCar'] ?? false;
          return DocumentUploadView(withCar: withCar);
        },
      ),

      GoRoute(
        path: DriverAppRoutes.myDriversView,
        builder: (context, state) {
          return MyDriversView();
        },
      ),

      //old
      GoRoute(
        path: DriverAppRoutes.driverRoot,
        builder: (context, state) => DriverRootView(),
      ),
    ],
  );
});
