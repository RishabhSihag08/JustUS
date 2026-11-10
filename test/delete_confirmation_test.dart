import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Delete for everyone confirmation dialog shows warning',
      (WidgetTester tester) async {
    bool deleteConfirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogCtx) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFF222529),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: const Text('Delete for everyone?'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'This message will be permanently deleted for both you and your partner.',
                            ),
                            const SizedBox(height: 12),
                            const Row(
                              children: [
                                Icon(Icons.warning_amber_rounded),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'This action cannot be undone.',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              deleteConfirmed = true;
                              Navigator.pop(dialogCtx);
                            },
                            child: const Text('Delete for everyone'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Tap button to open dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Verify dialog elements
    expect(find.text('Delete for everyone?'), findsOneWidget);
    expect(find.text('This action cannot be undone.'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete for everyone'), findsOneWidget);

    // Tap confirm
    await tester.tap(find.widgetWithText(FilledButton, 'Delete for everyone'));
    await tester.pumpAndSettle();

    expect(deleteConfirmed, isTrue);
  });
}
