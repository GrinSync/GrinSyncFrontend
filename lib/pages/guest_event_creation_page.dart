import 'package:flutter/material.dart';

/// Creates a stateless page for the Guest Event Creation page.
// This page cannot be changed by the user, which is OK because we just want to
// display a message here.
class GuestEventCreationPage extends StatelessWidget {
  const GuestEventCreationPage({super.key}); // This is the default constructor.

  @override
  // We build the widget here.
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Align text in the center of the page.
        // Display the text.
        children: <Widget>[
          Text('Welcome to GrinSync!', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Text('Please log in or register to create an event.'),
        ],
      ),
    );
  }
}
