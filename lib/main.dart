import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/security/secure_storage_service.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: 'assets/.env');
  } catch (e) {
    debugPrint('dotenv note: $e');
  }

  // Initialize Firebase
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase init note: $e');
  }

  // Initialize Supabase
  try {
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    if (supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty) {
      await Supabase.initialize(
        url: supabaseUrl,
        publishableKey: supabaseKey,
      );
    }
  } catch (e) {
    debugPrint('Supabase init note: $e');
  }

  // Screen security temporarily disabled for development & debugging
  // try {
  //   await FlutterWindowManagerPlus.addFlags(FlutterWindowManagerPlus.FLAG_SECURE);
  // } catch (e) {
  //   debugPrint('WindowManager note: $e');
  // }

  // Initialize secure storage
  try {
    await SecureStorageService.initialize();
  } catch (e) {
    debugPrint('SecureStorageService note: $e');
  }

  // Initialize stealth decoy notification service
  try {
    final notificationService = NotificationService();
    await notificationService.initialize();
  } catch (e) {
    debugPrint('NotificationService note: $e');
  }

  runApp(
    const ProviderScope(
      child: JustUsApp(),
    ),
  );
}
