class CommonApiEndPoints {
  static String mapKey =
      "AIzaSyAQk0BDUcdmln3zCV4CbPDn7UF2Y1PjD7Q"; //from client
  // "AIzaSyBuSZJklSc1j0D4kqhkJcmyArcZbWujbXQ";

  static const String baseUrl = 'http://10.10.10.5:5000/api/v1/';
  static const String baseImageUrl = 'http://10.10.10.5:5000';
  static const String baseSocketUrl = 'http://10.10.10.5:6000';

  // my local server
  // static const String baseUrl = 'http://10.10.10.21:5000/api/v1/';
  // static const String baseSocketUrl = 'http://10.10.10.21:6000';
  // static const String baseImageUrl = 'http://10.10.10.21:5000';

  //chat
  static String previousMessage(String reciverId) =>
      "messages/previous-messages/$reciverId";

  //notifications
  static String notification(int page) =>
      "notification/my-notifications?page=$page";
}
