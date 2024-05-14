import 'package:flutter/material.dart';
import 'package:grinsync/pages/guest_event_creation_page.dart';
import 'package:grinsync/pages/user_event_creation_page.dart';
import 'package:grinsync/global.dart';
import 'package:grinsync/models/user_models.dart';

/// Creates a stateless page that decides whether to show the Guest or User Event Creation Page based on logged in status.
// This page that does not have a state since it does not need to be modified.
// This page isn't actually seen by users. It just exists behind the scenes
// and redirects to the proper page that users will see depending on whether they
// are logged in or not.
class CreatePage extends StatelessWidget {
  const CreatePage({super.key}); // This is the default constructor.

  @override
  Widget build(BuildContext context) {
    // We are using ValueListenableBuilder here so the page rebuilds every time the variable USER changes.
    // Variable USER is null when the user is not logged in.
    // Otherwise, the user is logged in.
    return ValueListenableBuilder<User?>(
        valueListenable: USER,
        builder: (context, user, _) {
          // If the user is not logged in, go to the Guest Event Creation page.
          if (USER.value == null) {
            return const GuestEventCreationPage();
          }
          // Otherwise, the user is logged in, so they can see the User Event Creation page.
          else {
            return const UserEventCreationPage();
          }
        });
  }
}
