class PassengerModel {
  final String name;
  final String profileImage;
  final double rating;

  PassengerModel({
    required this.name,
    required this.profileImage,
    this.rating = 5.0,
  });
}