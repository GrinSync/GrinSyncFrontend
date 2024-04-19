import 'package:flutter/material.dart';
import 'package:flutter_test_app/pages/guest_event_creation_page.dart';
import 'package:flutter_test_app/pages/user_event_creation_page.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/models/user_models.dart';

class CreatePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // using valueListenableBuilder so the page rebuilds every time USER changes
    return ValueListenableBuilder<User?>(
        valueListenable: USER,
        builder: (context, user, _) {
          if (USER.value == null) {
            return GuestEventCreationPage();
          } else {
            return const EventCreationPage();
          }
        });
  }
}
