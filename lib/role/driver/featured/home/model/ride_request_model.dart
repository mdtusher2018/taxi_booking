import 'package:taxi_booking/role/driver/featured/home/model/pessanger_model.dart';

class RideRequestModel {
  final String id;
  final PassengerModel passenger;
  final String pickup;
  final String dropoff;
  final String distance;
  final String fare;
  final double rent;
  final double vat;
  final double discount;
  String status; // pending, accepted, arrived, in_progress, finished

  RideRequestModel({
    required this.id,
    required this.passenger,
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.fare,
    required this.rent,
    required this.vat,
    required this.discount,
    this.status = 'pending',
  });
}
