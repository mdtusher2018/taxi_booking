import 'package:flutter/material.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/routes/common_app_pages.dart';
import 'package:taxi_booking/core/routes/driver_app_routes.dart';
import 'package:taxi_booking/core/routes/user_app_routes.dart';
import 'package:taxi_booking/main.dart';
import 'package:taxi_booking/resource/common_dialog/custom_dialog.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/role/common/featured/setting/model/profile_response.dart';
import 'package:taxi_booking/role/driver/featured/driver/view/my_drivers.dart';
import 'package:taxi_booking/role/common/featured/setting/controller/profile_controller.dart';
import 'package:taxi_booking/role/common/featured/setting/widget/profile_details_widgets.dart';
import 'package:taxi_booking/role/driver/featured/vehicals/view/all_vehicales_view.dart';
import 'package:taxi_booking/role/driver/featured/vehicals/view/my_vehicales_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/role/driver/featured/vehicals/view/vehicale_details_view.dart';
import 'package:taxi_booking/role/driver/featured/wallet/views/wallet_with_car_driver_view.dart';
import '../../../../driver/featured/wallet/views/wallet_without_car_driver_view.dart';
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
      appBar: CustomAppBar(title: "Settings", leading: SizedBox()),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(profileControllerProvider.notifier).getProfile();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
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
                  return ProfileHeader(
                    name: data?.data.user.fullName ?? "Unnamed User",
                    phone: data?.data.user.phone ?? "No Phone Number",
                    image:
                        data?.data.user.image ??
                        data?.data.user.identityUploads?.selfie ??
                        "N/A",
                    isVerified: data?.data.user.status == "APPROVED",
                  );
                },
                error: (error, stackTrace) {
                  if (error.toString().contains("blocked")) {
                    return ProfileHeader(
                      name: 'N/A',
                      isVerified: false,

                      image: "N/A",
                      phone: 'N/A',
                    );
                  }
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
              if (ref.watch(appRole.notifier).state == AppRole.driver)
                SettingItemCard(
                  icon: Icon(Icons.credit_card, color: Colors.yellow.shade900),
                  title: "Wallet",
                  onTap: () {
                    if (state is AsyncData) {
                      final data =
                          (state as AsyncData).value as ProfileResponse;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => (data.data.role == "WithCar")
                              ? WalletWithCarDriverView(
                                  name: data.data.user.fullName,
                                )
                              : WalletWithoutCarDriverView(
                                  id: data.data.user.id,
                                  name: data.data.user.fullName,
                                ),
                        ),
                      );
                    }
                  },
                ),

              state.when(
                loading: () {
                  return SizedBox.shrink();
                },
                data: (data) {
                  if (data == null) {
                    return SizedBox.shrink();
                  }

                  if (ref.watch(appRole.notifier).state == AppRole.driver &&
                      data.data.role == "WithCar") {
                    return SettingItemCard(
                      icon: Icon(
                        Icons.drive_eta_outlined,
                        color: Colors.yellow.shade900,
                      ),
                      title: "My Vehicales",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyVehiclesView(isForAssign: false),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
                error: (error, stackTrace) {
                  return SizedBox.shrink();
                },
              ),
              state.when(
                loading: () {
                  return SizedBox.shrink();
                },
                data: (data) {
                  if (data == null) {
                    return SizedBox.shrink();
                  }

                  if (ref.watch(appRole.notifier).state == AppRole.driver &&
                      data.data.user.activeVehicleId != null) {
                    return SettingItemCard(
                      icon: Icon(
                        Icons.drive_eta_outlined,
                        color: Colors.yellow.shade900,
                      ),
                      title: "My Active Vehicale",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VehicleDetailsView(
                            vehicaleId: data.data.user.activeVehicleId!,
                            isMyVehicale: true,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
                error: (error, stackTrace) {
                  return SizedBox.shrink();
                },
              ),

              if (ref.watch(appRole.notifier).state == AppRole.driver)
                SettingItemCard(
                  icon: Icon(
                    Icons.drive_eta_outlined,
                    color: Colors.yellow.shade900,
                  ),
                  title: "All Vehicales",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AllVehiclesView()),
                  ),
                ),

              state.when(
                loading: () {
                  return SizedBox.shrink();
                },
                data: (data) {
                  if (data == null) {
                    return SizedBox.shrink();
                  }

                  if (ref.watch(appRole.notifier).state == AppRole.driver &&
                      data.data.role == "WithCar") {
                    return SettingItemCard(
                      icon: Icon(Icons.person_4, color: Colors.yellow.shade900),
                      title: "My Drivers",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MyDriversView()),
                        );
                      },
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
                error: (error, stackTrace) {
                  return SizedBox.shrink();
                },
              ),

              state.when(
                loading: () {
                  return SizedBox.shrink();
                },
                data: (data) {
                  if (data == null) {
                    return SizedBox.shrink();
                  }

                  if (data.adminInfo?.adminId != null) {
                    return SettingItemCard(
                      icon: Icon(
                        Icons.support_agent,
                        color: Colors.yellow.shade900,
                      ),
                      title: "Customer Support",
                      onTap: () {
                        context.push(
                          CommonAppRoutes.messagingView,
                          extra: {
                            'id': data.adminInfo!.adminId,
                            'oldChatting': true,
                          },
                        );
                      },
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
                error: (error, stackTrace) {
                  return SizedBox.shrink();
                },
              ),

              SettingItemCard(
                icon: Icon(Icons.policy, color: Colors.yellow.shade900),
                title: "Privacy",
                onTap: () {
                  context.push(CommonAppRoutes.privacyView);
                },
              ),
              SettingItemCard(
                icon: Icon(Icons.policy, color: Colors.yellow.shade900),
                title: "About Us",
                onTap: () {
                  context.push(CommonAppRoutes.aboutUsView);
                },
              ),
              SettingItemCard(
                icon: Icon(Icons.policy, color: Colors.yellow.shade900),
                title: "Terms & Service",
                onTap: () {
                  context.push(CommonAppRoutes.termsAndConditionView);
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
                    onPositiveButtonPressed: () async {
                      await ref.read(localStorageServiceProvider).clearAll();
                      if (mounted) {
                        if (ref.read(appRole.notifier).state ==
                            AppRole.driver) {
                          context.go(
                            DriverAppRoutes.authenticationView,
                            extra: {"isLogin": true},
                          );
                        } else {
                          context.go(
                            UserAppRoutes.authenticationView,
                            extra: {"isLogin": true},
                          );
                        }
                      }
                    },
                    onNegativeButtonPressed: () => Navigator.pop(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
