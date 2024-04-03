import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/pages/login_page.dart';
import 'package:flutter_test_app/pages/registration_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User? _user;
  late bool _guestmode; // default to guest mode

  // check if the user is logged in
  // if the user is logged in, set _guestmode to false, and set the user to the current user
  // if the user is not logged in, set _guestmode to true, and set the user to null
  Future<void> checkLoginStatus () async {
    // TODO: need to get the token from somewhere
    // _user = await getUser(token)

    // *** temporary ***
    _user = User(token: '1234', username: 'TestUser', firstName: 'Brian', lastName: 'Chan');
    // *** temporary ***
    if (_user == null) {
      _guestmode = true;
    } else {
      _guestmode = false;
    }
  }
  


  @override
  void initState() {
    checkLoginStatus();
    // print(_guestmode);
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
              const Text('You are currently a guest user.'),
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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // display info
            const SizedBox(height: 8),
            Text('${_user?.username}', style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, fontFamily: 'Helvetica')),
            Text(' ${_user?.firstName} ${_user?.lastName}', style: TextStyle(fontSize: 15, color: Colors.grey[600])),
            //Text('Email: ${_user?.email}'),

            // display options
            const Divider(color: Colors.black,),
            TextButton(
              child: const Text('Edit Profile', style: TextStyle(fontSize: 20)),
              onPressed: () {
                // TODO: implement edit profile page
              },),
            // const Divider(color: Colors.grey,),
            TextButton(
              child: const Text('Events I Follow', style: TextStyle(fontSize: 20)),
              onPressed: () {
                // TODO: implement events I follow page
              },),
            TextButton(
              child: const Text('Users/Orgs I Follow', style: TextStyle(fontSize: 20)),
              onPressed: () {
                // TODO: implement users/orgs I follow page
              },),
            Expanded(child: SizedBox()), 
            ElevatedButton(
              child: const Text('Logout', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // TODO: implement logout functionality
              },
            ),
        ]),
      )
    );
  }
}

