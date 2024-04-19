import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/pages/guest_profile_page.dart';
import 'package:flutter_test_app/pages/user_profile_page.dart';
import 'package:flutter_test_app/global.dart';

class ProfilePage extends StatelessWidget {

  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<User?>(
      valueListenable: USER,
      builder: (context, user, _) {
        if (user == null) {
          return GuestProfilePage();
        } else {
          return UserProfilePage();
        }
      },
    );
  }
}