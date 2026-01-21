import 'package:flutter/material.dart';
import 'package:taxi_booking/core/routes/common_app_pages.dart';
import 'package:taxi_booking/main.dart';
import 'package:taxi_booking/resource/common_dialog/custom_dialog.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver/view/my_drivers.dart';
import 'package:taxi_booking/role/common/setting/controller/profile_controller.dart';
import 'package:taxi_booking/role/common/setting/widget/profile_details_widgets.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/view/my_vehicales_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../driver/featured/wallet/views/wallet_view.dart';
import '../widget/setting_item_card.dart';

class SettingView extends ConsumerStatefulWidget {
  const SettingView({super.key});

  @override
  ConsumerState<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends ConsumerState<SettingView> {
  bool isPromoEnabled = true;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileControllerProvider.notifier).getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Settings"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            state.when(
              loading: () {
                return ProfileHeader(
                  name: 'Loading...',
                  isVerified: false,
                  image: "N/A",
                  phone: 'loading...',
                );
              },
              data: (data) {
                if (data == null) {
                  return ProfileHeader(
                    name: 'Loading...',
                    isVerified: false,
                    image: "N/A",
                    phone: 'loading...',
                  );
                }
                return ProfileHeader(
                  name: data.data.user.fullName,
                  phone: data.data.user.phone,
                  image: data.data.user.identityUploads?.selfie ?? "",
                  isVerified: data.data.user.status == "APPROVED",
                );
              },
              error: (error, stackTrace) {
                return ProfileHeader(
                  name: 'N/A',
                  isVerified: false,
                  image: "N/A",
                  phone: 'N/A',
                );
              },
            ),

            const SizedBox(height: 24),

            SettingItemCard(
              icon: Icon(Icons.person, color: Colors.yellow.shade900),
              title: "Profile",
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                state.when(
                  loading: () {},
                  error: (error, stackTrace) {},
                  data: (data) {
                    if (data != null) {
                      context.push(
                        CommonAppRoutes.profileView,
                        extra: data.data,
                      );
                    }
                  },
                );
              },
            ),

            SettingItemCard(
              icon: Icon(Icons.credit_card, color: Colors.yellow.shade900),
              title: "Wallet",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WalletView()),
              ),
            ),

            if (ref.watch(appRole.notifier).state == AppRole.driver)
              SettingItemCard(
                icon: Icon(
                  Icons.drive_eta_outlined,
                  color: Colors.yellow.shade900,
                ),
                title: "My Vehicales",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyVehiclesView()),
                ),
              ),
            if (ref.watch(appRole.notifier).state == AppRole.driver)
              SettingItemCard(
                icon: Icon(Icons.person_4, color: Colors.yellow.shade900),
                title: "My Drivers",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MyDriversView()),
                  );
                },
              ),

            SettingItemCard(
              icon: Icon(Icons.support_agent, color: Colors.yellow.shade900),
              title: "Customer Support",
              onTap: () {
                // Open customer support page or chat
              },
            ),
            SettingItemCard(
              icon: Icon(Icons.policy, color: Colors.yellow.shade900),
              title: "Security & Privacy",
              onTap: () {
                // Open security settings
              },
            ),

            const Divider(),

            SettingItemCard(
              icon: Icon(Icons.logout_sharp, color: Colors.yellow.shade900),
              title: "Log out",
              onTap: () {
                CustomAlertDialog().customAlert(
                  context: context,
                  title: 'Want to Log out?',
                  message: 'Are you sure you want to log out?',
                  NegativebuttonText: 'Cancel',
                  PositivvebuttonText: "Log out",
                  onPositiveButtonPressed: () => Navigator.pop(context),
                  onNegativeButtonPressed: () => Navigator.pop(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
