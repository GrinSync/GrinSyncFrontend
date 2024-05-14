import 'package:flutter/material.dart';
import 'package:grinsync/models/user_models.dart';
import 'package:grinsync/pages/guest_profile_page.dart';
import 'package:grinsync/pages/user_profile_page.dart';
import 'package:grinsync/global.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<User?>(
      valueListenable:
          USER, // Listens to the USER ValueNotifier in global.dart to rebuild the page when the user logs in or logs out
      builder: (context, user, _) {
        if (user == null) {
          // If the user is not logged in, show the GuestProfilePage, show the UserProfilePage otherwise
          return const GuestProfilePage();
        } else {
          return UserProfilePage();
        }
      },
    );
  }
}
