import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/role/user/featured/booking_map/controllers/booking_map_controller.dart';

double distanceFare({
  required PricingModel pricing,
  required double distanceKm,
}) {
  return distanceKm * pricing.perKm;
}

double timeFare({required PricingModel pricing, required double durationMin}) {
  return (durationMin * pricing.perMin);
}

double totalFare({
  required PricingModel pricing,
  required double distanceKm,
  required double durationMin,
  required double surgeMultiplier,
}) {
  AppLogger.d(surgeMultiplier.toString());

  // 1️⃣ Base fare calculation
  final double baseFare =
      pricing.startFare +
      distanceFare(distanceKm: distanceKm, pricing: pricing) +
      timeFare(durationMin: durationMin, pricing: pricing);

  // 2️⃣ Apply surge pricing
  final double surgedFare = baseFare * surgeMultiplier;

  // 3️⃣ Enforce minimum fare
  return surgedFare < pricing.minFare ? pricing.minFare : surgedFare;
}
