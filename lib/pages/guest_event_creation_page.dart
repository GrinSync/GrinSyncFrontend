// Stateless widget for Guest Event Creation page

import 'package:flutter/material.dart';

class GuestEventCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to GrinSync!', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text('Please log in or register to create an event by going to the Profile page.'),
          ],
        ),
      ),
    );
  }
}
