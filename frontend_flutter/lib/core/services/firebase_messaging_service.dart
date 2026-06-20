import 'package:firebase_messaging/firebase_messaging.dart';
import 'api_client.dart';

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final ApiClient _apiClient = ApiClient();

  Future<void> init() async {
    // Request permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      
      // Get the token each time the application loads
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _sendTokenToServer(token);
      }

      // Any time the token refreshes, store this in the database too.
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _sendTokenToServer(newToken);
      });
      
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
          // You can show a local notification or custom snackbar here
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      await _apiClient.post('/fcm-token', data: {
        'fcm_token': token
      });
      print('FCM Token sent to server: $token');
    } catch (e) {
      print('Failed to send FCM token: $e');
    }
  }
}
