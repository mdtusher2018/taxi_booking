import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/services/socket/socket_config.dart';
import 'package:taxi_booking/core/utilitis/helper.dart';
import 'package:taxi_booking/core/utilitis/user_api_end_points.dart';
import 'package:taxi_booking/role/common/chat/views/chat_list_view.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/views/booking_map_view.dart';
import 'package:taxi_booking/role/user/featured/notification/views/notification_view.dart';
import 'package:taxi_booking/role/user/featured/ride_history/views/ride_history_view.dart';
import 'package:taxi_booking/role/user/featured/setting/views/setting_view.dart';

class UserRootView extends ConsumerStatefulWidget {
  const UserRootView({super.key});

  @override
  ConsumerState<UserRootView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<UserRootView> {
  int selectedIndex = 2;

  final List<IconData> icons = [
    Icons.notifications_none,
    Icons.access_time,
    Icons.local_taxi, // center icon
    Icons.chat_bubble_outline,
    Icons.settings,
  ];

  List<Widget> screens = [
    NotificationView(),
    RideHistoryView(),
    UserBookingMapView(),
    ChatListView(),
    UserSettingView(),
  ];

  void changeTab(int index) {
    selectedIndex = index;
  }

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
      SocketConfig(url: UserApiEndpoints.baseSocketUrl, token: token),
    );
    socketService.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey,
      body: screens[selectedIndex],
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 80),
            painter: BNBCustomPainter(),
          ),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(icons.length, (index) {
                if (index == 2) {
                  return const SizedBox(width: 60); // leave space for center
                }
                return IconButton(
                  icon: Icon(
                    icons[index],
                    color: selectedIndex == index ? Colors.amber : Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      changeTab(index); // Update selected index
                    });
                  },
                );
              }),
            ),
          ),
          Positioned(
            bottom: 30,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  changeTab(2); // Navigate to center tab (BookingMapView)
                });
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
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0, 0);

    // left side
    path.lineTo(size.width * 0.30, 0);

    // upward curve start
    path.quadraticBezierTo(size.width * 0.37, 0, size.width * 0.40, -20);

    // deep arc upward
    path.arcToPoint(
      Offset(size.width * 0.60, -20),
      radius: const Radius.circular(45),
      clockwise: true,
    );

    // right side curve end
    path.quadraticBezierTo(size.width * 0.63, 0, size.width * 0.70, 0);
    path.lineTo(size.width, 0);

    // bottom part
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Shadow paint (grey with opacity 0.3)
    Paint shadowPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(path.shift(const Offset(0, 4)), shadowPaint);

    // Main white paint
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
