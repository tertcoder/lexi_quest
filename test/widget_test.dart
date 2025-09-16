import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lexi_quest/app.dart';

void main() {
  testWidgets('LexiQuest app renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LexiQuestApp());

    // Verify that the app loads without error
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
