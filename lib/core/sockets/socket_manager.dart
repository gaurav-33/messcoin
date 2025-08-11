import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../storage/auth_box_manager.dart';

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  static Completer<SocketManager>? _completer;

  factory SocketManager() => _instance;
  SocketManager._internal();

  IO.Socket? _socket;
  bool _connected = false;

  RxBool isLive = false.obs;
  RxInt retryCount = 0.obs;
  RxString errorMessage = ''.obs;

  final int maxRetries = 5;
  final Duration retryDelay = Duration(seconds: 2);

  VoidCallback? onConnectionRestored;
  Function? onConnect;

  Future<SocketManager> init({Function? onConnect}) async {
    // Only create a new completer if not present or already completed
    if (_completer == null || _completer!.isCompleted) {
      _completer = Completer<SocketManager>();
      this.onConnect = onConnect;
      await _connectWithRetry();
    }
    return _completer!.future;
  }

  Future<void> _connectWithRetry() async {
    retryCount.value = 0;
    errorMessage.value = '';
    // Dispose the previous socket/listeners before retrying!
    _disposeSocket();
    while (retryCount.value < maxRetries) {
      try {
        final token = await AuthBoxManager.getToken();
        final String baseUrl = dotenv.env['SOCKET_URL'] ?? '';
        _socket = IO.io(
          baseUrl,
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .enableReconnection()
              .setExtraHeaders({'Authorization': 'Bearer $token'})
              .build(),
        );
        _bindListeners();

        final connCompleter = Completer<void>();
        bool mainCompleted = false; // only complete _completer once

        void onConnect(_) {
          _connected = true;
          isLive.value = true;
          errorMessage.value = '';
          if (_completer != null &&
              !_completer!.isCompleted &&
              !mainCompleted) {
            _completer!.complete(_instance);
            mainCompleted = true;
          }
          connCompleter.complete();
          debugPrint('🟢 Socket connected: ${_socket?.id}');
          _removeConnectionListeners(); // prevent double
        }

        void onConnectError(data) {
          if (_completer != null &&
              !_completer!.isCompleted &&
              !mainCompleted) {
            _completer!.completeError('ConnectError: $data');
            mainCompleted = true;
          }
          connCompleter.completeError('ConnectError: $data');
          debugPrint('⚠️ Connect error: $data');
          _removeConnectionListeners();
        }

        // Use once only for connection attempt events
        _socket?.once('connect', onConnect);
        _socket?.once('connect_error', onConnectError);

        _socket?.connect();
        await connCompleter.future;
        break; // connected!
      } catch (e) {
        retryCount.value++;
        errorMessage.value =
            'Socket connection failed (attempt ${retryCount.value}): $e';
        _disposeSocket();
        if (retryCount.value >= maxRetries) {
          if (_completer != null && !_completer!.isCompleted) {
            _completer!.completeError('Max retries reached');
          }
          throw Exception(
              'Failed to connect to socket after $maxRetries attempts.');
        }
        await Future.delayed(retryDelay);
      }
    }
  }

  void _disposeSocket() {
    if (_socket != null) {
      _socket!.off(''); // Remove all listeners/events
      _socket?.dispose();
      _socket = null;
    }
  }

  void _removeConnectionListeners() {
    // Useful if socket.io could fire both connect_error and connect in edge cases
    _socket?.off('connect');
    _socket?.off('connect_error');
  }

  void _bindListeners() {
    _socket?.onDisconnect((_) {
      _connected = false;
      isLive.value = false;
      debugPrint('🔴 Socket disconnected.');
    });

    _socket?.onReconnect((_) {
      _connected = true;
      isLive.value = true;
      debugPrint('🔄 Socket reconnected.');
      onConnectionRestored?.call();
    });

    _socket?.on('reconnecting', (attempt) {
      isLive.value = false;
      retryCount.value = attempt;
      debugPrint('🔄 Reconnecting attempt: $attempt');
    });

    _socket?.on('reconnect_error', (data) {
      debugPrint('❗️ Reconnect error: $data');
      errorMessage.value = 'Reconnection error: $data';
    });

    _socket?.on('reconnect_failed', (data) {
      debugPrint('❌ Reconnection failed: $data.');
      errorMessage.value = 'Reconnection failed';
      isLive.value = false;
    });

    _socket?.onError((data) {
      debugPrint('❌ Socket error: $data');
      errorMessage.value = data.toString();
    });
  }

  void subscribe(String event, Function(dynamic data) callback) {
    if (_socket != null) {
      debugPrint("Subscribed to $event");
      _socket!.on(event, callback);
    } else {
      debugPrint('Socket not initialized. Cannot subscribe to $event');
    }
  }

  void unsubscribe(String event) {
    _socket?.off(event);
  }

  bool get isConnected => _connected;

  void dispose() {
    _disposeSocket();
    _connected = false;
    _completer = null; // reset for next attempt
    isLive.value = false;
    retryCount.value = 0;
    errorMessage.value = '';
  }
}
