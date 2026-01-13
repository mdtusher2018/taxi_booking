import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/role/driver/featured/add_taxi_dashboard/views/add_taxi_dashboard_view.dart';
import 'package:taxi_booking/role/driver/featured/call/views/call_view.dart';
import 'package:taxi_booking/role/driver/featured/chat/views/chat_view.dart';
import 'package:taxi_booking/role/driver/featured/customer_support/views/customer_support_view.dart';
import 'package:taxi_booking/role/driver/featured/dashboard/views/dashboard_view.dart';
import 'package:taxi_booking/role/driver/featured/home/views/home_view.dart';
import 'package:taxi_booking/role/driver/featured/notification/views/notification_view.dart';
import 'package:taxi_booking/role/driver/featured/payment/views/payment_view.dart';
import 'package:taxi_booking/role/driver/featured/ride_history/views/ride_history_view.dart';
import 'package:taxi_booking/role/driver/featured/splash/views/driver_splash_view.dart';
import 'package:taxi_booking/role/driver/featured/wallet/views/wallet_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/authentication_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/document_upload_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/driving_license_and_business_info_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/email_verification_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/views/transport_selection_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver/view/my_drivers.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/setting/model/profile_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/setting/views/edit_profile_view.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/setting/views/setting_view.dart';
import 'package:taxi_booking/role/driver/routes/driver_app_routes.dart';

final driverAppRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: DriverAppRoutes.splashView,
    routes: [
      GoRoute(
        path: DriverAppRoutes.splashView,
        builder: (context, state) => DriverSplashView(),
      ),

      GoRoute(
        path: DriverAppRoutes.homeView,
        builder: (context, state) => DriverHomeView(),
      ),
      GoRoute(
        path: DriverAppRoutes.settingView,
        builder: (context, state) => const DriverSettingView(),
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
        path: DriverAppRoutes.settingView,
        builder: (context, state) => DriverSettingView(),
      ),
      GoRoute(
        path: DriverAppRoutes.profileView,
        builder: (context, state) {
          final extra = state.extra as ProfileData;
          return ProfileView(data: extra);
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
        builder: (context, state) => DashboardView(),
      ),
      GoRoute(
        path: DriverAppRoutes.notificationView,
        builder: (context, state) => const NotificationView(),
      ),
      GoRoute(
        path: DriverAppRoutes.chatView,
        builder: (context, state) => const ChatView(),
      ),
      GoRoute(
        path: DriverAppRoutes.walletView,
        builder: (context, state) => WalletView(),
      ),
      GoRoute(
        path: DriverAppRoutes.rideHistoryView,
        builder: (context, state) => RideHistoryView(),
      ),
      GoRoute(
        path: DriverAppRoutes.customerSupportView,
        builder: (context, state) => const CustomerSupportView(),
      ),

      GoRoute(
        path: DriverAppRoutes.paymentView,
        builder: (context, state) => const PaymentView(),
      ),
      GoRoute(
        path: DriverAppRoutes.callView,
        builder: (context, state) => const CallView(),
      ),
      GoRoute(
        path: DriverAppRoutes.addTaxiDashboardView,
        builder: (context, state) => const AddTaxiDashboardView(),
      ),
    ],
  );
});
