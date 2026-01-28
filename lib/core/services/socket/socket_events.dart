class SocketEvents {
  SocketEvents._();
  // =========================
  // CORE SOCKET EVENTS
  // =========================
  static const String connect = 'connect';
  static const String disconnect = 'disconnect';
  static const String error = 'io-error';

  // =========================
  // RIDE EVENTS
  // =========================
  static const String rideRequest = 'ride-request';
  static const String rideAccepted = 'ride-accepted';
  static const String rideStarted = 'ride-started';
  static const String rideEnded = 'ride-ended';
  static const String rideCancelled = 'ride-cancelled';

  // =========================
  // DRIVER EVENTS
  // =========================
  static const String driverArrived = 'driver-arrived';
  static const String driverCurrentLocation = 'driver-current-location';
  static const String updateDriverLocation = 'update-driver-location';
  static const String updateDriverLocationAfterRideStart =
      'ride-start-after-driver-location';
  static const String driverArrivedDropLocation =
      'driver-arrived-dropoff-location';

  // =========================
  // CHAT / MESSAGE EVENTS
  // =========================

  static const String unreadMessage = 'unread-message';
  static const String newMessage = 'new-message';
  static const String sendMessage = 'send-message';

  //get chat by reciver id
  static const String getChatByReciverId = 'message';
  static const String receiverDetails = 'receiver-details';
  static const String previousMessage = 'previous-message';

  //get all chat list work as get api
  static const String myChatListEmit = 'my-chat-list';
  static String myChatListListen(String userId) {
    return 'chat-list::$userId';
  }

  // =========================
  // LIVE / ANALYTICS EVENTS
  // =========================
  static const String liveCountUpdate = 'live-count-update';
}
