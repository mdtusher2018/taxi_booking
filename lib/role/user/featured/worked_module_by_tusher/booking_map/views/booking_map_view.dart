// booking_map_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/core/utilitis/enum/payment_status_enums.dart';
import 'package:taxi_booking/core/utilitis/enum/use_enums.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/sheet/searching_driver_sheet.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/views/payment_authorized_webview_page.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/widget/driver_arrived.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/widget/on_the_destination_way.dart';
import '../../../../../../resource/common_widget/custom_network_image.dart';
import '../controllers/booking_map_controller.dart';
import '../sheet/destination_picker_sheet.dart';
import '../widget/search_widget.dart';
import '../widget/arriving_card.dart';

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
      if (previous?.checkoutUrl == null && next.checkoutUrl != null) {
        AppLogger.i("Routing");
        final paymentResult = await Navigator.push<PaymentResult>(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentWebViewPage(checkoutUrl: next.checkoutUrl!),
          ),
        );

        ref.read(bookingMapControllerProvider.notifier).rideEmit(paymentResult);
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
              child: ArrivingCard(
                onCancel: () {
                  controller.onRideCancel();
                },
              ),
            ),
          if (state.status == RideBookingStatus.driverArived)
            Positioned(
              bottom: 100, // Position from the bottom of the screen
              left: 16,
              right: 16,
              child: DriverArrivedCard(
                onCancel: () {
                  controller
                      .onRideCancel(); // Call the function to cancel the ride
                },
              ),
            ),
          if (state.status == RideBookingStatus.rideStarted)
            Positioned(
              bottom: 100, // Position from the bottom of the screen
              left: 16,
              right: 16,
              child: OnYourWayCard(
                onCancel: () {
                  controller
                      .onRideCancel(); // Call the function to cancel the ride
                },
              ),
            ),
        ],
      ),
    );
  }
}
