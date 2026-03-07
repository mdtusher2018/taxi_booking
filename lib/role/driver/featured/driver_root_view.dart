import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/services/socket/socket_config.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
import 'package:taxi_booking/core/utilitis/helper.dart';
import 'package:taxi_booking/role/common/featured/chat/views/chat_list_view.dart';
import 'package:taxi_booking/role/common/featured/notifications/notifications_view.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/controller/home_ride_controller.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/views/home_view.dart';
import 'package:taxi_booking/role/common/featured/ride_history/ride_history_view.dart';
import 'package:taxi_booking/role/common/featured/setting/views/setting_view.dart';

class DriverRootView extends ConsumerStatefulWidget {
  DriverRootView({super.key});

  @override
  ConsumerState<DriverRootView> createState() => _DriverDashboardViewState();
}

class _DriverDashboardViewState extends ConsumerState<DriverRootView> {
  int selectedIndex = 2;

  final List<IconData> icons = [
    Icons.notifications_none,
    Icons.access_time,
    Icons.local_taxi, // center icon
    Icons.chat_bubble_outline,
    Icons.settings,
  ];

  void changeTab(int index) {
    selectedIndex = index;
    setState(() {});
  }

  List<Widget> screens = [
    NotificationView(),
    RideHistoryView(),
    DriverHomeView(),
    ChatListView(),
    SettingView(),
  ];

  @override
  void initState() {
    super.initState();
    connectSocketCall();
  }

  void connectSocketCall() async {
    final token = await getAccessToken(ref.read(localStorageServiceProvider));

    if (token == null || token.isEmpty) {
      print("Token is missing or invalid");
      return;
    }

    final socketService = ref.read(socketServiceProvider);
    socketService.init(
      SocketConfig(url: DriverApiEndpoints.baseSocketUrl, token: token),
    );
    socketService.connect();
    ref.read(homeRideControllerProvider.notifier).listenRideDetails();
    ref.read(homeRideControllerProvider.notifier).emitRideDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          confirmAppClose(didPop, result, context);
        },

        child: screens[selectedIndex],
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // CustomPaint(
              //   size: Size(MediaQuery.of(context).size.width, 80),
              //   painter: BNBCustomPainter(),
              // ),
              Container(
                height: 100,

                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 1)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(icons.length, (index) {
                    if (index == 2) {
                      return const SizedBox(
                        width: 60,
                      ); // leave space for center
                    }
                    return IconButton(
                      icon: Icon(
                        icons[index],
                        color: selectedIndex == index
                            ? Colors.amber
                            : Colors.grey,
                        size: 28,
                      ),
                      onPressed: () {
                        changeTab(index);
                      },
                    );
                  }),
                ),
              ),
              Positioned(
                bottom: 30,
                child: GestureDetector(
                  onTap: () {
                    changeTab(2);
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_taxi,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
