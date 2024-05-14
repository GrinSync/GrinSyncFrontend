// stateless widget for guest profile page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grinsync/pages/login_page.dart';
import 'package:grinsync/pages/registration_page.dart';

class GuestProfilePage extends StatelessWidget {
  const GuestProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // This is the welcome message for the guest user
            const Text('Welcome to GrinSync!', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text('Please log in or register to access more features.'),

            // These are the buttons for the guest user to log in or register
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Login')),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const RegistrationPage()),
                  );
                },
                child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}
