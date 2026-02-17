class CommonApiEndPoints {
  static String mapKey =
      "AIzaSyAQk0BDUcdmln3zCV4CbPDn7UF2Y1PjD7Q"; //from client

  static const String baseUrl = 'https://www.api.taxitil.no/api/v1/';
  static const String baseImageUrl = 'https://www.api.taxitil.no/';
  static const String baseSocketUrl = 'https://www.socket.taxitil.no/';

  // static const String baseUrl = 'http://10.10.10.5:5000/api/v1/';
  // static const String baseSocketUrl = 'http://10.10.10.5:6000';
  // static const String baseImageUrl = 'http://10.10.10.5:5000'; //21

  //chat
  static String previousMessage(String reciverId) =>
      "messages/previous-messages/$reciverId";
  static String uploadFile = "uploads/message-file";

  //notifications
  static String notification(int page) =>
      "notification/my-notifications?page=$page";

  static String rideHistory(int page) => "rides/my-rides?page=$page";

  static var getProfile = "users/my-profile";
  static var privacyPolicy = "admin/get-privacy-policy";
  static var adminInfo = "users/admin-support-info";
}
