import 'package:taxi_booking/core/utilitis/enum/driver_enums.dart';
import 'package:taxi_booking/role/common/featured/ride_details/ride_details_response.dart';
import 'package:taxi_booking/role/driver/featured/home_ride/model/ride_request_response.dart';

extension RideDetailsMapper on RideDetailsResponse {
  RideRequestResponse toRideRequest() {
    final ride = data;

    if (ride == null) {
      throw Exception("Ride data is null");
    }

    return RideRequestResponse(
      referenceId: ride.id ?? '',
      rideInfo: RideInfo(
        id: ride.id ?? '',
        fare: Fare(
          baseFare: ride.fare?.baseFare ?? 0,
          distanceFare: ride.fare?.distanceFare ?? 0,
          timeFare: ride.fare?.timeFare ?? 0,
          surgeMultiplier: ride.fare?.surgeMultiplier ?? 1,
          totalFare: ride.fare?.totalFare ?? 0,
        ),
        estimatedDistanceKm: ride.estimatedDistanceKm ?? 0,
        estimatedDurationMin: ride.estimatedDurationMin ?? 0,
        pickupLocation: Location(
          type: ride.pickupLocation?.type ?? '',
          coordinates: ride.pickupLocation?.coordinates ?? [],
          address: ride.pickupLocation?.address ?? '',
        ),
        dropOffLocation: Location(
          type: ride.dropOffLocation?.type ?? '',
          coordinates: ride.dropOffLocation?.coordinates ?? [],
          address: ride.dropOffLocation?.address ?? '',
        ),
      ),
      passengerInfo: PassengerInfo(
        id: ride.passenger?.id ?? '',
        name: ride.passenger?.user?.fullname ?? '',
        phone: ride.passenger?.phone ?? '',
        image: ride.passenger?.user?.image ?? '',
      ),
    );
  }
}

DriverStatus mapApiStatusToDriverStatus(String? apiStatus) {
  switch (apiStatus) {
    case 'CREATED':
    case 'SEARCHING':
    case 'REQUESTED':
      return DriverStatus.online;
    case 'ACCEPTED':
      return DriverStatus.onGoingToPick;
    case 'DRIVER_ARRIVED':
      return DriverStatus.reachedPickupLocation;
    case 'STARTED':
    case 'ONEWAY':
      return DriverStatus.rideStartrd;
    case 'DRIVER_ARRIVED_DROPOFF':
      return DriverStatus.reachedDestinationLocation;
    case 'COMPLETED':
      return DriverStatus.rideEnd;
    case 'CANCELLED':
    case 'FAILED':
      return DriverStatus.rideCanceled;
    default:
      return DriverStatus.offline; // fallback
  }
}




