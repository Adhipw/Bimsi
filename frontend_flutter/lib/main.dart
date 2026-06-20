import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'core/services/firebase_messaging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  try {
    await Firebase.initializeApp();
    final fcmService = FirebaseMessagingService();
    await fcmService.init();
  } catch (e) {
    print('Firebase init failed (maybe no config provided): $e');
  }

  runApp(
    const ProviderScope(
      child: BimsiApp(),
    ),
  );
}
