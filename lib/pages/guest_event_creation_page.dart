// Stateless widget for Guest Event Creation page

import 'package:flutter/material.dart';

class GuestEventCreationPage extends StatelessWidget {
  const GuestEventCreationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Welcome to GrinSync!', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Text('Please log in or register to create an event.'),
        ],
      ),
    );
  }
}
