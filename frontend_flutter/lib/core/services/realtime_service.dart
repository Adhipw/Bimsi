import 'dart:async';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../helpers/storage_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/api_config.dart';

final realtimeServiceProvider = Provider((ref) => RealtimeService());

class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();
  factory RealtimeService() => _instance;
  RealtimeService._internal();

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  
  bool _isInitialized = false;
  final _eventController = StreamController<PusherEvent>.broadcast();
  Stream<PusherEvent> get eventStream => _eventController.stream;

  // Replace with your actual pusher keys or environment variables
  final String apiKey = 'local_app_key';
  final String cluster = 'ap1';

  Future<void> initPusher() async {
    if (_isInitialized) return;

    try {
      final token = await StorageHelper.getToken();
      
      await pusher.init(
        apiKey: apiKey,
        cluster: cluster,
        onEvent: onEvent,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        authEndpoint: '${ApiConfig.baseUrl}/broadcasting/auth', // Use correct base URL
        authParams: {
          'headers': {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          }
        }
      );
      
      await pusher.connect();
      _isInitialized = true;
    } catch (e) {
      print('ERROR INIT PUSHER: $e');
    }
  }

  Future<void> subscribeToChannel(String channelName, Function(PusherEvent) onEventCallback) async {
    if (!_isInitialized) await initPusher();
    
    // Store callback if needed or handle globally in `onEvent` by broadcasting via Stream/Notifier
    await pusher.subscribe(channelName: channelName);
  }

  Future<void> unsubscribe(String channelName) async {
    if (_isInitialized) {
      await pusher.unsubscribe(channelName: channelName);
    }
  }

  void onEvent(PusherEvent event) {
    print('onEvent: ${event.eventName}');
    _eventController.add(event);
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print('onSubscriptionSucceeded: $channelName data: $data');
  }

  void onSubscriptionError(String message, dynamic e) {
    print('onSubscriptionError: $message Exception: $e');
  }

  void onDecryptionFailure(String event, String reason) {
    print('onDecryptionFailure: $event reason: $reason');
  }

  void onMemberAdded(String channelName, PusherMember member) {
    print('onMemberAdded: $channelName user: $member');
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    print('onMemberRemoved: $channelName user: $member');
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print('Connection: $currentState');
  }

  void onError(String message, int? code, dynamic e) {
    print('onError: $message code: $code exception: $e');
  }
}
