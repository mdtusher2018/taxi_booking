import 'dart:async';
import 'dart:developer';
import 'package:taxi_booking/core/services/socket/socket_config.dart';
import 'package:taxi_booking/core/services/socket/socket_events.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import '../../logger/log_helper.dart';

class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  IO.Socket? _socket;
  SocketConfig? _config;

  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  bool get isConnected => _socket?.connected ?? false;

  // ------------------ Store Active Events ------------------
  final Set<String> _activeListeners = {};
  Set<String> get activeListeners => _activeListeners;

  // ------------------ INIT ------------------
  void init(SocketConfig config) {
    _config = config;
  }

  // ------------------ CONNECT ------------------
  void connect() {
    log("============== connect called ==========");
    if (_socket != null && _socket!.connected) return;
    if (_config == null) {
      throw Exception('SocketConfig not initialized');
    }

    _socket = IO.io(
      _config!.url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': _config!.token})
          .setReconnectionAttempts(10)
          .setReconnectionDelay(2000)
          .build(),
    );

    _registerCoreListeners();
    _socket!.connect();
  }

  // ------------------ CORE LISTENERS ------------------
  void _registerCoreListeners() {
    _socket!
      ..on(SocketEvents.connect, (_) {
        _connectionController.add(true);
        AppLogger.i('Socket Connected');
      })
      ..on(SocketEvents.disconnect, (_) {
        _connectionController.add(false);
        AppLogger.w('Socket Disconnected');
      })
      ..on(SocketEvents.error, (e) {
        AppLogger.e('Socket Error: $e');
        if (e is Map<String, dynamic>) {
          if (e['success'] == false) {
            CustomToast.showToast(message: e['message'] ?? "", isError: true);
          }
        }
      });
  }

  // ------------------ EMIT ------------------
  Future<dynamic> emit(String event, dynamic data) async {
    if (!isConnected) {
      CustomToast.showToast(message: "Socket not connected. Try again later.");
      return;
    }

    try {
      AppLogger.i("Emit event: $event with $data");

      final response = await _socket!.emitWithAckAsync(event, data);

      return response;
    } catch (e) {
      AppLogger.e('Socket Error: $e');
      if (e is Map<String, dynamic>) {
        CustomToast.showToast(
          message: e['message'] ?? "Unknown Error Occoured",
          isError: true,
        );
      }
    }
  }

  // ------------------ LISTEN ------------------
  void on(String event, Function(dynamic data) callback) {
    _activeListeners.add(event);

    _socket?.on(event, callback);
    AppLogger.i("Started listening to socket event: $event");
  }

  // ------------------ LISTEN Once------------------
  void listenOnce(String event, Function(dynamic data) callback) {
    _socket?.once(event, callback);
    AppLogger.i("listening once socket event: $event");
  }

  void off(String event) {
    _activeListeners.remove(event);
    AppLogger.w("🛑 Stopped listening to socket event: $event");
    _socket?.off(event);
  }

  // ------------------ SAFE DISCONNECT ------------------
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  // ------------------ CLEANUP ------------------
  void dispose() {
    disconnect();
    _connectionController.close();
  }
}
