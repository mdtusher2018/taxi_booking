import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/common_app_routes.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver_root_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/home_ride/views/home_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/splash/driver_splash_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/authentication_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/document_upload_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/driving_license_and_business_info_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/email_verification_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/transport_selection_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver/view/my_drivers.dart';
import 'package:taxi_booking/core/routes/driver_app_routes.dart';

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
        path: DriverAppRoutes.dashboardView,
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
          final phoneNumber = extra?['phoneNumber'];
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
        path: DriverAppRoutes.dashboardView,
        builder: (context, state) => DriverRootView(),
      ),
      // GoRoute(
      //   path: DriverAppRoutes.notificationView,
      //   builder: (context, state) => const NotificationView(),
      // ),
      // GoRoute(
      //   path: DriverAppRoutes.chatView,
      //   builder: (context, state) => const ChatListView(),
      // ),
      // GoRoute(
      //   path: DriverAppRoutes.walletView,
      //   builder: (context, state) => WalletView(),
      // ),
      // GoRoute(
      //   path: DriverAppRoutes.rideHistoryView,
      //   builder: (context, state) => RideHistoryView(),
      // ),
      // GoRoute(
      //   path: DriverAppRoutes.customerSupportView,
      //   builder: (context, state) => const CustomerSupportView(),
      // ),

      // GoRoute(
      //   path: DriverAppRoutes.paymentView,
      //   builder: (context, state) => const PaymentView(),
      // ),
      // GoRoute(
      //   path: DriverAppRoutes.callView,
      //   builder: (context, state) => const CallView(),
      // ),
      // GoRoute(
      //   path: DriverAppRoutes.addTaxiDashboardView,
      //   builder: (context, state) => const AddTaxiDashboardView(),
      // ),
    ],
  );
});
