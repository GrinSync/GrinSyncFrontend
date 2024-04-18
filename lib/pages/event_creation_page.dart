import 'package:flutter/material.dart';
import 'package:flutter_test_app/constants.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/pages/guest_event_creation_page.dart';
import 'package:flutter_test_app/pages/user_event_creation_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_test_app/global.dart';

class CreatePage extends StatefulWidget {
  @override
  State<CreatePage> createState() => _CreateState();

}

class _CreateState extends State<CreatePage> {
  late User? _user;

  // check if the user is logged in
  // if the user is logged in, set guestmode to false, and set the user to the current user
  // if the user is not logged in, set guestmode to true, and set the user to null
  Future<void> checkLoginStatus() async {
    var box = await Hive.openBox(tokenBox);
    var token = box.get('token');
    box.close();
    if (token == null) {
      guestmode = true;
    } else {
      _user = await getUser(token);
      if (_user == null) {
        guestmode = true;
      } else {
        guestmode = false;
      }
    }
  }

  refresh() {
    setState(() {});
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
              const Text('Loading Event Creation Page...'),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Error loading event creation page'),
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
          if (guestmode) {
            return GuestEventCreationPage();
          } else {
            return const EventCreationPage();
          }
        }
      },
    );
  }
}
