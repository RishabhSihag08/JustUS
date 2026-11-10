import 'package:flutter_test/flutter_test.dart';
import 'package:justus/domain/models/compass_credentials.dart';

void main() {
  group('CompassCredentials Model Tests', () {
    test('creates and parses from JSON correctly with custom values', () {
      final json = {
        'id': 'user-123',
        'role': 'user_1',
        'compass_heading': 155.5,
        'pin': '9876',
      };

      final creds = CompassCredentials.fromJson(json);

      expect(creds.userId, 'user-123');
      expect(creds.role, 'user_1');
      expect(creds.heading, 155.5);
      expect(creds.pin, '9876');
    });

    test('falls back to default heading and PIN if missing in JSON', () {
      final json1 = {
        'role': 'user_1',
      };
      final creds1 = CompassCredentials.fromJson(json1);
      expect(creds1.heading, 120.0);
      expect(creds1.pin, '1234');

      final json2 = {
        'role': 'user_2',
      };
      final creds2 = CompassCredentials.fromJson(json2);
      expect(creds2.heading, 260.0);
      expect(creds2.pin, '5678');
    });

    test('serializes to JSON correctly', () {
      const creds = CompassCredentials(
        userId: 'uid-456',
        role: 'user_2',
        heading: 275.0,
        pin: '4321',
      );

      final json = creds.toJson();
      expect(json['user_id'], 'uid-456');
      expect(json['role'], 'user_2');
      expect(json['compass_heading'], 275.0);
      expect(json['pin'], '4321');
    });
  });

  group('Device Account Binding Permission Logic Tests', () {
    bool isAngleAllowed({required String? boundRole, required String targetRole}) {
      if (boundRole == null) return true;
      final normalizedBound = (boundRole == 'user1' || boundRole == 'user_1') ? 'user_1' : 'user_2';
      final normalizedTarget = (targetRole == 'user1' || targetRole == 'user_1') ? 'user_1' : 'user_2';
      return normalizedBound == normalizedTarget;
    }

    test('when unbound, both User 1 and User 2 are allowed to unlock', () {
      expect(isAngleAllowed(boundRole: null, targetRole: 'user_1'), isTrue);
      expect(isAngleAllowed(boundRole: null, targetRole: 'user_2'), isTrue);
    });

    test('when bound to user_1, only User 1 is allowed, User 2 is rejected', () {
      expect(isAngleAllowed(boundRole: 'user_1', targetRole: 'user_1'), isTrue);
      expect(isAngleAllowed(boundRole: 'user_1', targetRole: 'user_2'), isFalse);
    });

    test('when bound to user_2, only User 2 is allowed, User 1 is rejected', () {
      expect(isAngleAllowed(boundRole: 'user_2', targetRole: 'user_1'), isFalse);
      expect(isAngleAllowed(boundRole: 'user_2', targetRole: 'user_2'), isTrue);
    });
  });
}
