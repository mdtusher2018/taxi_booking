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

  // =========================
  // CHAT / MESSAGE EVENTS
  // =========================
  static const String newMessage = 'new-message';

  // =========================
  // LIVE / ANALYTICS EVENTS
  // =========================
  static const String liveCountUpdate = 'live-count-update';
}
