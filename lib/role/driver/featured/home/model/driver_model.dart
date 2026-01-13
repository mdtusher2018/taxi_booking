class DriverModel {
  final String id;
  final String name;
  final String profileImage;
  bool isOnline;

  DriverModel({
    required this.id,
    required this.name,
    required this.profileImage,
    this.isOnline = false,
  });
}