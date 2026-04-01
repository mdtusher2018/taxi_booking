// booking_map_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_booking/core/routes/common_app_pages.dart';

import 'package:taxi_booking/core/utilitis/enum/payment_status_enums.dart';
import 'package:taxi_booking/core/utilitis/enum/use_enums.dart';
import 'package:taxi_booking/core/utilitis/image_utils.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/common/featured/setting/controller/profile_controller.dart';
import 'package:taxi_booking/role/user/featured/booking_map/sheet/ride_end_sheet.dart';
import 'package:taxi_booking/role/user/featured/booking_map/views/cancel_booking_view.dart';
import 'package:taxi_booking/role/user/featured/booking_map/views/pay_tip_webview.dart';
import 'package:taxi_booking/role/user/featured/booking_map/widget/give_review_driver_sheet.dart';
import 'package:taxi_booking/role/user/featured/booking_map/sheet/searching_driver_sheet.dart';
import 'package:taxi_booking/role/user/featured/booking_map/views/payment_authorized_webview_page.dart';
import 'package:taxi_booking/role/user/featured/booking_map/widget/driver_arrived.dart';
import 'package:taxi_booking/role/user/featured/booking_map/sheet/on_the_destination_way_sheet.dart';
import 'package:taxi_booking/role/user/featured/booking_map/widget/ride_compleate_card.dart';
import 'package:taxi_booking/role/user/featured/booking_map/widget/tips_view_sheet.dart';
import '../../../../../resource/common_widget/custom_network_image.dart';
import '../controllers/booking_map_controller.dart';
import '../sheet/destination_picker_sheet.dart';
import '../widget/search_widget.dart';
import '../sheet/arriving_sheet.dart';

class UserBookingMapView extends ConsumerStatefulWidget {
  const UserBookingMapView({super.key});

  @override
  ConsumerState<UserBookingMapView> createState() => _BookingMapViewState();
}

class _BookingMapViewState extends ConsumerState<UserBookingMapView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileControllerProvider.notifier).getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(bookingMapControllerProvider.notifier);
    final state = ref.watch(bookingMapControllerProvider);
    final profileState = ref.watch(profileControllerProvider);

    ref.listen(bookingMapControllerProvider, (previous, next) async {
      if (previous?.checkoutUrl != next.checkoutUrl &&
          next.checkoutUrl != null) {
        final paymentResult = await Navigator.push<PaymentResult>(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentWebViewPage(checkoutUrl: next.checkoutUrl!),
          ),
        );

        ref.read(bookingMapControllerProvider.notifier).rideEmit(paymentResult);
      }

      if (previous?.tipCheckoutUrl != next.tipCheckoutUrl &&
          next.tipCheckoutUrl != null) {
        // final paymentResult =
        final tipresult = await Navigator.push<TipResult>(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PayTipWebViewPage(checkoutUrl: next.tipCheckoutUrl!),
          ),
        );
        if (tipresult == TipResult.success) {
          ref.read(bookingMapControllerProvider.notifier).rideEnd();
        } else {
          CustomToast.showToast(message: "Trip Provide Faild", isError: true);
        }
      }

      if (previous?.pickupLatLng != next.pickupLatLng) {
        controller.updateSurgeMultiplier();
        controller.onPicupPickoffLocationChanged();
      }
      if (previous?.dropLatLng != next.dropLatLng) {
        controller.onPicupPickoffLocationChanged();
      }
      if (previous?.driverLatLng != next.driverLatLng) {
        controller.onDriverLocationChanged();
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          (state.currentLocation == null)
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: controller.mapControllerSet,
                  initialCameraPosition: CameraPosition(
                    target: state.currentLocation!,
                    zoom: 14.0,
                  ),

                  markers: state.markers.toSet(),
                  polylines: state.polylines.toSet(),

                  // Netherlands map style (you can customize this)
                  mapType: MapType.normal,
                ),

          Positioned(
            top: 50,
            left: 32,
            child: Row(
              children: [
                profileState.when(
                  data: (data) {
                    return InkWell(
                      onTap: () {
                        if (data != null) {
                          context.push(
                            CommonAppRoutes.profileView,
                            extra: data.data,
                          );
                        } else {
                          CustomToast.showToast(
                            message: "Could not load Profile data...",
                          );
                        }
                      },
                      child: CustomNetworkImage(
                        key: ValueKey(
                          data?.data.user.image ??
                              data?.data.user.identityUploads?.selfie ??
                              "N/A",
                        ),
                        imageUrl: getFullImagePath(
                          data?.data.user.image ??
                              data?.data.user.identityUploads?.selfie ??
                              "N/A",
                        ),
                        height: 60,
                        width: 60,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return InkWell(
                      onTap: () {
                        CustomToast.showToast(
                          message: "Could not load Profile data...",
                        );
                      },
                      child: CustomNetworkImage(
                        key: ValueKey("N/A"),
                        imageUrl: getFullImagePath("N/A"),
                        height: 60,
                        width: 60,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    );
                  },
                  loading: () {
                    return InkWell(
                      onTap: () {
                        CustomToast.showToast(message: "Profile is Loading...");
                      },
                      child: CustomNetworkImage(
                        key: ValueKey("N/A"),
                        imageUrl: getFullImagePath("N/A"),
                        height: 60,
                        width: 60,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Name and phone number centered horizontally
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bgColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      title: profileState.maybeWhen(
                        data: (data) =>
                            data?.data.user.fullName ?? "Name not available",
                        orElse: () => "Loading...",
                      ),
                      style: CommonStyle.textStyleMedium(size: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      title: profileState.maybeWhen(
                        data: (data) =>
                            data?.data.user.phone ?? "Phone not available",
                        orElse: () => "Loading...",
                      ),
                      style: CommonStyle.textStyleSmall(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Helper function for placeholder avatar
          if (state.status == RideBookingStatus.initial)
            const Positioned(top: 50, right: 32, child: SearchBarWidget()),

          if (state.status == RideBookingStatus.rideCreating)
            const DestinationPickerSheet(),

          if (state.status == RideBookingStatus.initial)
            Positioned(
              bottom: 120,
              right: 16,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.mainColor,
                onPressed: controller.goToCurrentLocation,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

          if (state.status == RideBookingStatus.searchingDriver)
            SearchingDriverBottomSheet(),

          if (state.status == RideBookingStatus.driverOnTheWay)
            Positioned(bottom: 0, left: 16, right: 16, child: ArrivingSheet()),
          if (state.status == RideBookingStatus.driverArived)
            Positioned(
              bottom: 100, // Position from the bottom of the screen
              left: 16,
              right: 16,
              child: DriverArrivedCard(),
            ),
          if (state.status == RideBookingStatus.rideStarted)
            Positioned(
              bottom: 100, // Position from the bottom of the screen
              left: 16,
              right: 16,
              child: OnYourWaySheet(
                onCancel: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CancelBookingView();
                      },
                    ),
                  );
                },
              ),
            ),
          if (state.status == RideBookingStatus.destinationReached)
            Positioned(
              bottom: 100, // Position from the bottom of the screen
              left: 16,
              right: 16,
              child: RideCompleatedCard(),
            ),

          if (state.status == RideBookingStatus.giveReview)
            Positioned(
              bottom: 100, // Position from the bottom of the screen
              left: 16,
              right: 16,
              child: GiveReviewSheet(),
            ),
          if (state.status ==
              RideBookingStatus.tipProcessing) //   tipprocerssing,
            Positioned(
              bottom: 100, // Position from the bottom of the screen
              left: 16,
              right: 16,
              child: GiveTipsSheet(),
            ),
          if (state.status == RideBookingStatus.rideEnded) //   tipprocerssing,
            Positioned(
              bottom: 100, // Position from the bottom of the screen
              left: 16,
              right: 16,
              child: RideEndSheet(),
            ),
        ],
      ),
    );
  }
}
