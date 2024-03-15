import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/pages/login_page.dart';
import 'package:flutter_test_app/pages/registration_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool _guestmode;

  @override
  void initState() {
    _guestmode = true;  // currently default to guest mode, will be updated to check whether the user is logged in when more login functionality is added
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if the user is not logged in, display the page with the option to login or register
    if (_guestmode) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to GrinSync!'),
              const Text('You are currently in guest mode.'),
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
                    CupertinoPageRoute(builder: (context) => const RegistrationPage()),
                  );
                },
                child: const Text('Register')),
                ],
          )
        ) 
      );
    }

    // if the user is logged in, display the user's profile
    return const Scaffold(
      body: Placeholder(), // to be implemented
    );
  }
}