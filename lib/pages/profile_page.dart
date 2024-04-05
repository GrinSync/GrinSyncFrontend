import 'package:flutter/material.dart';
import 'package:flutter_test_app/constants.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/pages/guest_profile_page.dart';
import 'package:flutter_test_app/pages/user_profile_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User? _user;
  late bool _guestmode;

  // check if the user is logged in
  // if the user is logged in, set _guestmode to false, and set the user to the current user
  // if the user is not logged in, set _guestmode to true, and set the user to null
  Future<void> checkLoginStatus() async {
    var box = await Hive.openBox(tokenBox);
    var token = box.get('token');
    box.close();
    if (token == null) {
      _guestmode = true;
    } else {
      _user = await getUser(token);
      if (_user == null) {
        _guestmode = true;
      } else {
        _guestmode = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              const Text('Loading Profile...'),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Error loading profile'),
              TextButton(
                onPressed: () {
                  setState(() {
                    checkLoginStatus();
                  });
                },
                child: const Text('Try again'),
              ),
            ],
          );
        } else {
          if (_guestmode) {
            return GuestProfilePage();
          } else {
            return UserProfilePage(user: _user);
          }
        }
      },
    );
  }
}
