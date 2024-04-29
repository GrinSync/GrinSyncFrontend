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
  testWidgets('Test that the Guest Profile page populated correctly',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MyApp());

    // Tap on the Create icon once on the home screen
    // This will show bring us to the Guest Event Creation page
    await tester.tap(find.byIcon(Icons.person));

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // We can use this test widget to test different aspects of our page
    // We do this below by checking if different fields populated correctly

    // Check the number of text fields that appeared on the page
    var numText = find.byType(Text);

    var numButton = find.byType(TextButton);

    // Test that all Text Fields populated
    // 1. 'Welcome to GrinSync!'
    // 2. 'Please log in or register to access more features.'
    // 3. 'My Profile' -- page title
    // 4. 'Home' - bottom navigation bar
    // 5. 'Search' - bottom navigation bar
    // 6. 'Create' - bottom navigation bar
    // 7. 'Calendar' - bottom navigation bar
    // 8. 'Profile' - bottom navigation bar
    // 9. 'Login' - button
    // 10. 'Register' - button
    expect(numText, findsNWidgets(10));

    expect(numButton, findsNWidgets(2));
  });
}
