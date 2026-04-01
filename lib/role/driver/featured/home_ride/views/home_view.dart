// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/routes/driver_app_routes.dart';
import 'package:taxi_booking/core/utilitis/enum/driver_enums.dart';
import 'package:taxi_booking/core/utilitis/image_utils.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/app_images/app_images.dart';
import 'package:taxi_booking/resource/common_widget/custom_network_image.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/role/common/featured/setting/controller/profile_controller.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/controller/home_ride_controller.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/widget/on_going_ride.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/widget/on_the_way_sheet.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/widget/payment_recived_view.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/widget/request_bottom_sheet.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/widget/ride_canceled_sheet.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/widget/ride_compleate_sheet.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/widget/trip_details_bottom_sheet.dart';

class DriverHomeView extends ConsumerStatefulWidget {
  const DriverHomeView({super.key});

  @override
  ConsumerState<DriverHomeView> createState() => _DriverHomeViewState();
}

class _DriverHomeViewState extends ConsumerState<DriverHomeView> {
  ValueNotifier<bool> switchingOnlineOffline = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileControllerProvider.notifier).getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(homeRideControllerProvider.notifier);

    final state = ref.watch(homeRideControllerProvider);

    final profileState = ref.watch(profileControllerProvider);

    ref.listen(homeRideControllerProvider, (previous, next) {
      if (next.status == DriverStatus.rideEnd) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const PaymentRecivedView(),
        );
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          /// ---------------- MAP ----------------
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: (mapController) {
                controller.mapControllerSet(mapController);
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(23.8103, 90.4125),
                zoom: 13.0,
              ),

              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              markers: state.markers,
              polylines: state.polylines,
            ),
          ),

          /// ---------------- HEADER (ONLINE / OFFLINE TOGGLE) ----------------
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                profileState.when(
                  data: (data) {
                    return CustomNetworkImage(
                      key: ValueKey(
                        data?.data.user.identityUploads?.selfie ?? "N/A",
                      ),
                      imageUrl: getFullImagePath(
                        data?.data.user.image ??
                            data?.data.user.identityUploads?.selfie ??
                            "N/A",
                      ),
                      height: 60,
                      width: 60,
                    );
                  },
                  error: (error, stackTrace) {
                    return CustomNetworkImage(
                      key: ValueKey("N/A"),
                      imageUrl: getFullImagePath("N/A"),
                      height: 60,
                      width: 60,
                      borderRadius: BorderRadius.circular(16),
                    );
                  },
                  loading: () {
                    return CustomNetworkImage(
                      key: ValueKey("N/A"),
                      imageUrl: getFullImagePath("N/A"),
                      height: 60,
                      width: 60,
                      borderRadius: BorderRadius.circular(16),
                    );
                  },
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    spacing: 16,
                    children: [
                      CustomText(
                        title: state.status != DriverStatus.offline
                            ? 'Online'
                            : 'Offline',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),

                      ValueListenableBuilder(
                        valueListenable: switchingOnlineOffline,
                        builder: (context, value, child) {
                          if (value) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Switch(
                            value: state.status != DriverStatus.offline,

                            activeThumbColor: AppColors.btnColor,

                            onChanged: (value) {
                              if (value) {
                                switchingOnlineOffline.value = true;
                                ref.read(socketServiceProvider).connect();
                                controller.driverOnline();
                                switchingOnlineOffline.value = false;
                              } else {
                                switchingOnlineOffline.value = true;
                                ref.read(socketServiceProvider).disconnect();
                                controller.driverOffline();
                                switchingOnlineOffline.value = false;
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                InkWell(
                  onTap: () {
                    context.push(
                      DriverAppRoutes.myVehicals,
                      extra: {"isForAssign": false},
                    );
                  },

                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(AppImages.realEstateAgent, scale: 4),
                  ),
                ),
              ],
            ),
          ),

          /// ---------------- REQUEST LIST SHEET ----------------
          if (state.status == DriverStatus.online &&
              state.rideRequest.isNotEmpty)
            Positioned(bottom: 0, left: 0, right: 0, child: RequestListSheet()),

          /// ---------------- ON THE WAY SHEET ----------------
          if (state.status == DriverStatus.onGoingToPick ||
              state.status == DriverStatus.reachedPickupLocation)
            Positioned(bottom: 0, left: 0, right: 0, child: OnTheWaySheet()),

          /// ---------------- ONGOING RIDE SHEET ----------------
          if (state.status == DriverStatus.rideStartrd)
            Positioned(bottom: 0, left: 0, right: 0, child: OngoingRideSheet()),

          /// ---------------- END RIDE SHEET ----------------
          if (state.status == DriverStatus.reachedDestinationLocation)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: WaitingForPaymentConfirmSheet(),
            ),
          if (state.status == DriverStatus.paymentRecived)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RideCompleateSheet(),
            ),
          if (state.status == DriverStatus.rideCanceled)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RideCanceledSheet(),
            ),
        ],
      ),
    );
  }
}
