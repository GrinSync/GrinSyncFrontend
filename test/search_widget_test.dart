import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  Box box;
      setUp(() async {
      final temp = await Directory.systemTemp.createTemp();
      Hive.init(temp.path);
      box = await Hive.openBox('test-box');
      await box.clear();
    });
  testWidgets('Test the search page populated correctly',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MyApp());

    // Tap on the search icon once on the home screen
    await tester.tap(find.byIcon(Icons.search));

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // We can use this test widget to test different aspects of our page
    // We do this below by checking if different fields populated correctly

    // Check the number of text fields that appeared on the page
    var numTextFields = find.byType(TextField);

    // Test that both Text Fields populated
    expect(numTextFields, findsNWidgets(1));

    // Test that the Title and Search button populated
    expect(find.text('Search'), findsNWidgets(2));
  });
}
