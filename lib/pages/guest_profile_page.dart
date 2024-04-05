// stateless widget for guest profile page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/pages/login_page.dart';
import 'package:flutter_test_app/pages/registration_page.dart';

class GuestProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to GrinSync!', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text('Please log in or register to access more features.'),
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
