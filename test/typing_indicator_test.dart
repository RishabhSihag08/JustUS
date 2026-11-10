import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justus/features/chat/widgets/typing_indicator.dart';

void main() {
  group('TypingIndicator Widget Tests', () {
    testWidgets('renders bubble, 3 dots, and typing text when visible',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TypingIndicator(
              isVisible: true,
              partnerName: 'Alex',
              isRecording: false,
              isDark: true,
            ),
          ),
        ),
      );

      // Fast-forward initial animation
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Alex is typing...'), findsOneWidget);

      // Verify 3 dots exist inside the bubble
      // In TypingIndicator, the bubble row has 3 dot containers
      final dotFinder = find.byType(Transform);
      expect(dotFinder, findsAtLeastNWidgets(3));
    });

    testWidgets('displays recording audio text when isRecording is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TypingIndicator(
              isVisible: true,
              partnerName: 'Sam',
              isRecording: true,
              isDark: true,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Sam is recording audio...'), findsOneWidget);
    });

    testWidgets('animates and loops dots over time',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TypingIndicator(
              isVisible: true,
              partnerName: 'Jordan',
              isRecording: false,
              isDark: false,
            ),
          ),
        ),
      );

      // Pump frames across the 2400ms cycle
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 1200));
      await tester.pump(const Duration(milliseconds: 1800));
      await tester.pump(const Duration(milliseconds: 2400));

      // Should still be rendering properly without crashing
      expect(find.text('Jordan is typing...'), findsOneWidget);
    });
  });
}
