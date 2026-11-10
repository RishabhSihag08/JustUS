import 'package:flutter_test/flutter_test.dart';
import 'package:justus/services/notification_service.dart';

void main() {
  group('Decoy Compass Notification Tests', () {
    test('generates authentic compass decoy title and body', () {
      for (int i = 0; i < 50; i++) {
        final (title, body) = DecoyNotificationHelper.getRandomDecoy();

        expect(title.isNotEmpty, isTrue);
        expect(body.isNotEmpty, isTrue);

        expect(DecoyNotificationHelper.decoyTitles.contains(title), isTrue);
        expect(DecoyNotificationHelper.decoyBodies.contains(body), isTrue);
      }
    });

    test('decoy messages maintain complete privacy (zero chat terminology leakage)', () {
      final forbiddenWords = [
        'message',
        'messages',
        'chat',
        'unread',
        'text',
        'user 1',
        'user 2',
        'partner',
        'conversation',
        'inbox',
      ];

      for (final body in DecoyNotificationHelper.decoyBodies) {
        final lower = body.toLowerCase();
        for (final forbidden in forbiddenWords) {
          expect(
            lower.contains(forbidden),
            isFalse,
            reason: 'Decoy body "$body" contains sensitive keyword "$forbidden"',
          );
        }
      }

      for (final title in DecoyNotificationHelper.decoyTitles) {
        final lower = title.toLowerCase();
        for (final forbidden in forbiddenWords) {
          expect(
            lower.contains(forbidden),
            isFalse,
            reason: 'Decoy title "$title" contains sensitive keyword "$forbidden"',
          );
        }
      }
    });

    test('notification channel and payload are configured for stealth decoy', () {
      expect(NotificationService.channelId, 'compass_alerts');
      expect(NotificationService.channelName, 'Compass Calibration');
      expect(NotificationService.channelDescription.toLowerCase().contains('compass'), isTrue);
    });
  });
}
