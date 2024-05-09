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

  testWidgets('Test that the Home page populated correctly',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MyApp());

    // Tap on the search icon once on the home screen.
    await tester.tap(find.byIcon(Icons.home));

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // We can now use this test widget to test different aspects of our page.
    // We do this below by checking if different fields populated correctly.

    // Test that the title populated.
    expect(find.text('Upcoming Events'), findsNWidgets(1));

    // Test that the home button populated.
    expect(find.text('Home'), findsNWidgets(1));

    // Check the number of text fields that appeared on the Search page.
    var filterButton = find.byIcon(Icons.filter_list);
    // Test that the filter button populated.
    expect(filterButton, findsNWidgets(1));
  });
}
