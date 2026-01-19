import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/services/notification/notification_service.dart';
import 'package:taxi_booking/core/services/snackbar/snackbar_service.dart';
import 'package:taxi_booking/firebase_options.dart';
import 'package:taxi_booking/core/routes/driver_app_pages.dart';
import 'package:taxi_booking/core/routes/user_app_pages.dart';

enum AppRole { driver, user }

Future<void> appinitalized() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);

    debugPrint('Caught FlutterError: ${details.exception}');
    debugPrint('Stack trace:');
    debugPrint(details.stack.toString());
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
}

void main() async {
  appinitalized();
  runApp(const ProviderScope(child: MyApp(role: AppRole.driver)));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.role});
  final AppRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snackBarService = ref.read(snackbarServiceProvider);
    final router = role == AppRole.driver
        ? ref.watch(driverAppRouterProvider)
        : ref.watch(userAppRouterProvider);
    return MaterialApp.router(
      scaffoldMessengerKey: (snackBarService as SnackBarService).messengerKey,

      title: 'Template App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router,
    );
  }
}
