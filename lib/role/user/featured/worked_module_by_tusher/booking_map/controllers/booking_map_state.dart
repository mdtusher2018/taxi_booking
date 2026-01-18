import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_booking/core/utilitis/enum/use_enums.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/model/pricing_model.dart';
import '../model/driver_info_model.dart';

class BookingMapState {
  final bool isLoading;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  final LatLng? pickupLatLng;
  final LatLng? dropLatLng;
  final LatLng? currentLocation;
  final LatLng? driverLatLng;

  final RideBookingStatus status;
  final double routeDistanceKm;
  final double tripDurationMin;
  final double surgeMultiplier;
  final String rideId;
  final DriverInfo? acceptedDriverInfo;

  final PricingModel? selectedPriceModel;

  const BookingMapState({
    this.isLoading = false,
    this.markers = const {},
    this.polylines = const {},
    this.pickupLatLng,
    this.dropLatLng,
    this.currentLocation,
    this.driverLatLng,
    this.status = RideBookingStatus.initial,
    this.routeDistanceKm = 0,
    this.tripDurationMin = 0,
    this.surgeMultiplier = 1,
    this.rideId = '',
    this.acceptedDriverInfo,
    this.selectedPriceModel,
  });

  BookingMapState copyWith({
    bool? isLoading,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    LatLng? pickupLatLng,
    LatLng? dropLatLng,
    LatLng? currentLocation,
    LatLng? driverLatLng,
    RideBookingStatus? status,
    double? routeDistanceKm,
    double? tripDurationMin,
    double? surgeMultiplier,
    String? rideId,
    DriverInfo? acceptedDriverInfo,
    PricingModel? selectedPriceModel,
  }) {
    return BookingMapState(
      isLoading: isLoading ?? this.isLoading,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      pickupLatLng: pickupLatLng ?? this.pickupLatLng,
      dropLatLng: dropLatLng ?? this.dropLatLng,
      currentLocation: currentLocation ?? this.currentLocation,
      driverLatLng: driverLatLng ?? this.driverLatLng,
      status: status ?? this.status,
      routeDistanceKm: routeDistanceKm ?? this.routeDistanceKm,
      tripDurationMin: tripDurationMin ?? this.tripDurationMin,
      surgeMultiplier: surgeMultiplier ?? this.surgeMultiplier,
      rideId: rideId ?? this.rideId,
      acceptedDriverInfo: acceptedDriverInfo ?? this.acceptedDriverInfo,
      selectedPriceModel: selectedPriceModel ?? this.selectedPriceModel,
    );
  }
}
