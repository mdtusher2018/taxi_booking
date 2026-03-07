import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_booking/core/utilitis/enum/use_enums.dart';
import 'package:taxi_booking/role/common/featured/ride_details/ride_details_response.dart';
import 'package:taxi_booking/role/user/featured/booking_map/controllers/booking_map_state.dart';
import 'package:taxi_booking/role/user/featured/booking_map/model/driver_info_model.dart';

extension RideDetailsBookingMapExtension on RideDetailsResponse {
  BookingMapState toBookingMapState(BookingMapState current) {
    final ride = data;
    if (ride == null) return current;

    // Pickup & Drop LatLng (handle null coordinates)
    LatLng? pickup;
    if (ride.pickupLocation?.coordinates != null &&
        ride.pickupLocation!.coordinates!.length >= 2) {
      pickup = LatLng(
        ride.pickupLocation!.coordinates![1],
        ride.pickupLocation!.coordinates![0],
      );
    }

    LatLng? drop;
    if (ride.dropOffLocation?.coordinates != null &&
        ride.dropOffLocation!.coordinates!.length >= 2) {
      drop = LatLng(
        ride.dropOffLocation!.coordinates![1],
        ride.dropOffLocation!.coordinates![0],
      );
    }

    final markers = <Marker>{
      if (pickup != null)
        Marker(markerId: const MarkerId('pickup'), position: pickup),
      if (drop != null)
        Marker(markerId: const MarkerId('drop'), position: drop),
    };

    DriverInfo? driverInfo;
    if (ride.driver != null) {
      driverInfo = DriverInfo(
        driverId: ride.driver?.id,
        name: ride.driver?.role ?? "",
        phone: ride.driver?.user?.phone ?? "",
        email: ride.driver?.user?.email ?? "",
        image: null,
        vehicle: ride.vehicle != null
            ? Vehicle(
                name: ride.driver?.user?.name ?? "",
                model: ride.vehicle?.model,

                photo: ride.vehicle?.photos?.front,
              )
            : null,
        rating: null,
      );
    }

    // Map ride status to BookingMapStatus
    RideBookingStatus mapStatus(String? status) {
      switch (status) {
        case "CREATED":
          return RideBookingStatus.searchingDriver;
        case "ACCEPTED":
          return RideBookingStatus.driverOnTheWay;
        case "STARTED":
          return RideBookingStatus.rideStarted;
        case "COMPLETED":
          return RideBookingStatus.rideEnded;
        case "CANCELLED":
          return RideBookingStatus.rideCancelled;
        default:
          return RideBookingStatus.initial;
      }
    }

    return current.copyWith(
      rideId: ride.id ?? "",
      pickupLatLng: pickup ?? current.pickupLatLng,
      dropLatLng: drop ?? current.dropLatLng,
      driverLatLng: driverInfo?.location != null
          ? LatLng(
              driverInfo?.location!.coordinates?.first ?? 0,
              driverInfo?.location!.coordinates?.last ?? 0,
            )
          : current.driverLatLng,
      markers: markers.isNotEmpty ? markers : current.markers,
      acceptedDriverInfo: driverInfo ?? current.acceptedDriverInfo,
      status: mapStatus(ride.status),
      routeDistanceKm: ride.estimatedDistanceKm ?? current.routeDistanceKm,
      tripDurationMin: ride.estimatedDurationMin ?? current.tripDurationMin,
      surgeMultiplier:
          ride.fare?.surgeMultiplier?.toDouble() ?? current.surgeMultiplier,
    );
  }
}
