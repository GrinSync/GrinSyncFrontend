import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/pages/registration_page.dart';

void main() {
  testWidgets('Test the Registration Page', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const RegistrationPage());

    // We can use this test widget to test different aspects of our page
    // We do this below by checking if different fields populated correctly

    // Check the number of text fields that appeared on the test page
    var numTextFields = find.byType(TextField);

    // Check the number of buttons that appeared on the page
    var numButtons = find.byType(ElevatedButton);

    // Test that the Title populated
    expect(find.text('Create an Account'), findsOneWidget);

    // Test that all 5 Text Fields populated
    expect(numTextFields, findsNWidgets(5));

    // Test that the Register Button populated
    expect(numButtons, findsNWidgets(1));
  });
}
