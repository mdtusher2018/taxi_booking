// booking_map_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:taxi_booking/core/routes/user_app_routes.dart';
import 'package:taxi_booking/core/utilitis/enum/payment_status_enums.dart';
import 'package:taxi_booking/core/utilitis/enum/use_enums.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/sheet/ride_end_sheet.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/views/pay_tip_webview.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/widget/give_review_driver_sheet.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/sheet/searching_driver_sheet.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/views/payment_authorized_webview_page.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/widget/driver_arrived.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/sheet/on_the_destination_way_sheet.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/widget/ride_compleate_card.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/widget/tips_view_sheet.dart';
import '../../../../../../resource/common_widget/custom_network_image.dart';
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
  Widget build(BuildContext context) {
    final controller = ref.read(bookingMapControllerProvider.notifier);
    final state = ref.watch(bookingMapControllerProvider);

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
            right: MediaQuery.sizeOf(context).width / 3.1,
            left: MediaQuery.sizeOf(context).width / 3.1,
            child: Center(child: CountPriceWidget()),
          ),

          Positioned(
            top: 50,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: CustomNetworkImage(
                imageUrl: 'https://i.pravatar.cc/150?img=1',
                height: 60,
                width: 60,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),

          if (state.status == RideBookingStatus.initial)
            const Positioned(top: 50, right: 16, child: SearchBarWidget()),

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
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: ArrivingSheet(
                onCancel: () async {
                  final result = await ref
                      .read(bookingMapControllerProvider.notifier)
                      .onRideCancel();
                  if (result && mounted) {
                    //ref.invalidate(bookingMapControllerProvider);
                    context.go(UserAppRoutes.rootView);
                  }
                },
              ),
            ),
          if (state.status == RideBookingStatus.driverArived)
            Positioned(
              bottom: 100, // Position from the bottom of the screen
              left: 16,
              right: 16,
              child: DriverArrivedCard(
                onCancel: () async {
                  final result = await ref
                      .read(bookingMapControllerProvider.notifier)
                      .onRideCancel();
                  if (result && mounted) {
                    //ref.invalidate(bookingMapControllerProvider);
                    context.go(UserAppRoutes.rootView);
                  }
                },
              ),
            ),
          if (state.status == RideBookingStatus.rideStarted)
            Positioned(
              bottom: 100, // Position from the bottom of the screen
              left: 16,
              right: 16,
              child: OnYourWaySheet(
                onCancel: () async {
                  final result = await ref
                      .read(bookingMapControllerProvider.notifier)
                      .onRideCancel();
                  if (result && mounted) {
                    //ref.invalidate(bookingMapControllerProvider);
                    context.go(UserAppRoutes.rootView);
                  }
                },
              ),
            ),
          if (state.status == RideBookingStatus.destinationReached)
            Positioned(
              bottom: 100, // Position from the bottom of the screen
              left: 16,
              right: 16,
              child: RideCompleatedCard(
                onCancel: () async {
                  final result = await ref
                      .read(bookingMapControllerProvider.notifier)
                      .onRideCancel();
                  if (result && mounted) {
                    //ref.invalidate(bookingMapControllerProvider);
                    context.go(UserAppRoutes.rootView);
                  }
                },
              ),
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
