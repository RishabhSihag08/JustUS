import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Helper providing realistic compass calibration and navigation alerts
class DecoyNotificationHelper {
  static const List<String> decoyBodies = [
    'Your compass needs to be calibrated to work.',
    'Open and check which direction you are heading.',
    'Compass sensor orientation check required.',
    'Magnetic field interference detected. Rotate phone in figure 8.',
    'Heading accuracy degraded. Tap to recalibrate.',
    'Magnetic declination adjustment recommended for true heading.',
    'Sensor orientation check recommended.',
    'Check your current heading alignment.',
  ];

  static const List<String> decoyTitles = [
    'Compass',
    'Compass Calibration',
    'Orientation Sensor',
    'Compass Heading',
  ];

  static (String title, String body) getRandomDecoy() {
    final rand = Random();
    final title = decoyTitles[rand.nextInt(decoyTitles.length)];
    final body = decoyBodies[rand.nextInt(decoyBodies.length)];
    return (title, body);
  }
}

/// Service for handling push notifications and stealth decoy local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static const String channelId = 'compass_alerts';
  static const String channelName = 'Compass Calibration';
  static const String channelDescription = 'Compass sensor and navigation calibration alerts';

  static void Function()? onNavigateToCompass;
  RealtimeChannel? _incomingMessageChannel;

  /// Initialize notification service
  Future<void> initialize() async {
    // 1. Initialize local notifications
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('Decoy notification clicked: ${response.payload}');
        // Strictly navigate to /compass, preserving complete decoy cover
        onNavigateToCompass?.call();
      },
    );

    // 2. Create Android notification channel
    final androidImplementation = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      const channel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );
      await androidImplementation.createNotificationChannel(channel);
      await androidImplementation.requestNotificationsPermission();
    }

    // 3. Request Firebase Messaging permissions
    await _requestPermissions();

    // 4. Set up FCM handlers
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('FCM opened app: ${message.data}');
      onNavigateToCompass?.call();
    });

    // 5. Check initial message if app opened via notification
    try {
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        onNavigateToCompass?.call();
      }
    } catch (_) {}
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint('Notification permission: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('Notification permission request note: $e');
    }
  }

  /// Handle incoming foreground FCM messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground FCM message: ${message.messageId}');
    showDecoyNotification();
  }

  /// Handle background FCM messages (top-level handler)
  @pragma('vm:entry-point')
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('Background FCM message: ${message.messageId}');
    await showDecoyNotification();
  }

  /// Show a stealth decoy compass notification
  static Future<void> showDecoyNotification() async {
    final (title, body) = DecoyNotificationHelper.getRandomDecoy();

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      channelShowBadge: true,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      category: AndroidNotificationCategory.message,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notificationId = Random().nextInt(100000);

    await _localNotifications.show(
      notificationId,
      title,
      body,
      details,
      payload: 'decoy_compass',
    );
  }

  /// Start listening for incoming messages on Supabase Realtime for a bound user.
  /// When a message from the partner arrives while the user is not actively on the chat screen,
  /// triggers a stealth decoy compass notification.
  void startListeningForIncomingMessages({
    required SupabaseClient supabase,
    String? boundUserId,
    required bool Function() isChatActive,
    void Function(Map<String, dynamic> record)? onMessageReceived,
  }) {
    stopListeningForIncomingMessages();

    final channelName = 'decoy-incoming-${boundUserId ?? "all"}';
    debugPrint('Starting decoy notification listener on channel: $channelName (boundUser: $boundUserId)');
    _incomingMessageChannel = supabase
        .channel(channelName)
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) async {
            try {
              final record = payload.newRecord;
              final senderId = record['sender_id'] as String?;

              // Only notify if sent by partner (not ourselves)
              final isFromPartner = boundUserId != null
                  ? (senderId != null && senderId != boundUserId)
                  : true;

              if (isFromPartner) {
                // If caller provided callback to persist to Drift, invoke it
                onMessageReceived?.call(record);

                // If user is not actively chatting on the chat screen, show decoy alert
                if (!isChatActive()) {
                  await showDecoyNotification();
                }
              }
            } catch (e) {
              debugPrint('Incoming message listener note: $e');
            }
          },
        )
        .subscribe((status, [error]) {
          debugPrint('Decoy incoming channel status: $status, error: $error');
        });
  }

  /// Stop listening for incoming messages
  void stopListeningForIncomingMessages() {
    _incomingMessageChannel?.unsubscribe();
    _incomingMessageChannel = null;
  }

  /// Get FCM token
  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (_) {
      return null;
    }
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
    } catch (_) {}
  }
}

/// Notification service provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
