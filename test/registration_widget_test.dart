import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  Box box;

  /// Sets up tests environment.
  // Creates a temporary directory,
  // initializes Hive with that directory's path,
  // opens a box named within Hive,
  // and then clears any existing data in that box.
  setUp(() async {
    final temp = await Directory.systemTemp.createTemp();
    Hive.init(temp.path);
    box = await Hive.openBox('test-box');
    await box.clear();
  });

  testWidgets('Test the Registration page populated correctly',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MyApp());

    // Tap on the profile icon once on the home screen.
    await tester.tap(find.byIcon(Icons.person));

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // Tap on the Register button on the Profile page.
    await tester.tap(find.widgetWithText(TextButton, 'Register'));

    // Rebuild the widget after the state has changed.
    await tester.pumpAndSettle();

    // We can use this test widget to test different aspects of our page.
    // We do this below by checking if different fields populated correctly.

    // Check the number of buttons that appeared on the page.
    var numButtons = find.byType(ElevatedButton);

    // Check the number of text fields that appeared on the page.
    var numTextFields = find.byType(TextField);

    // Checkthe nunmber of fill-in bubbles that appeared on the page.
    var numBubbles = find.byType(ListTile);

    // Test that the Register button populated.
    expect(numButtons, findsNWidgets(1));

    // Test that all Text Fields populated (5 fields needed for registration).
    expect(numTextFields, findsNWidgets(5));

    // Test that all bubbles populated.
    expect(numBubbles, findsNWidgets(3));
  });
}
