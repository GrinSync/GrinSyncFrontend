import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/pages/user_event_creation_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  Box box;
      setUp(() async {
      final temp = await Directory.systemTemp.createTemp();
      Hive.init(temp.path);
      box = await Hive.openBox('test-box');
      await box.clear();
    });
  testWidgets('Test that the User Event Creation page populated correctly',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const UserEventCreationPage());

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // We can use this test widget to test different aspects of our page
    // We do this below by checking if different fields populated correctly

    // Check the number of text fields that appeared on the page
    var numTextFields = find.byType(TextField);

    // Check the number of checkboxes that appeared on the page
    var numCheckbox = find.byType(CheckboxListTile);

    // Check the number of buttons that appeared on the page
    var numButton = find.byType(ElevatedButton);

    // Test that all Text Fields populated
    expect(numTextFields, findsNWidgets(6));

    // Test that the Checkbox populated
    expect(numCheckbox, findsNWidgets(1));

    // Test that the button populated
    expect(numButton, findsNWidgets(2));

  });
}
