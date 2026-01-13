// Transaction Model
class TransectionModel {
  final String dateTime;
  final String amount;
  final String pickup;
  final String dropoff;
  final String imageUrl;
  final double rating;

  TransectionModel({
    required this.dateTime,
    required this.amount,
    required this.pickup,
    required this.dropoff,
    required this.imageUrl,
    required this.rating,
  });
}
