import 'package:flutter/material.dart';
import 'package:flutter_test_app/pages/guest_event_creation_page.dart';
import 'package:flutter_test_app/pages/user_event_creation_page.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/models/user_models.dart';

// Create a page that does not have a state since it does not need to be modified
// This page isn't actually seen by users. It just exists behind the scenes
// and redirects to the proper page that users will see depednding on whether they
// are logged in or not
class CreatePage extends StatelessWidget {
  const CreatePage({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    // Using valueListenableBuilder so the page rebuilds every time USER changes
    return ValueListenableBuilder<User?>(
      valueListenable: USER,
      builder: (context, user, _) {
        // If the user is not logged in, go to the Guest Event Creation page
        if (USER.value == null) {
          return GuestEventCreationPage();
        } 
        // Otherwise, the user is logged in, so they can see the User Event Creation page
        else {
          return const UserEventCreationPage();
        }
      }
    );
  }
}
