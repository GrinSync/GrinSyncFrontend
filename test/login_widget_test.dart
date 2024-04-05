import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/pages/login_page.dart';

void main() {
  testWidgets('Test the Login Page populated correctly',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const LoginPage());

    // We can use this test widget to test different aspects of our page
    // We do this below by checking if different fields populated correctly

    // Check the number of text fields that appeared on the page
    var numTextFields = find.byType(TextField);

    // Check the number of buttons that appeared on the page
    var numButtons = find.byType(ElevatedButton);

    // Test that the Title populated
    expect(find.text('GrinSync Login'), findsOneWidget);

    // Test that both Text Fields populated
    expect(numTextFields, findsNWidgets(2));

    // Test that the Login Button populated
    expect(numButtons, findsNWidgets(1));
  });
}
