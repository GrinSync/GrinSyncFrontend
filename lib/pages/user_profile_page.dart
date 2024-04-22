import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/pages/events_I_created_page.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/pages/events_I_follow_page.dart';

class UserProfilePage extends StatelessWidget {
  final User? user = USER.value;

  UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // display info
            const SizedBox(height: 8),
            Text('${user?.firstName} ${user?.lastName}',
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Helvetica')),
            Text(' ${user?.email}',
                style: TextStyle(fontSize: 15, color: Colors.grey[600])),
            //Text('Email: ${user?.email}'),

            // display options
            const Divider(
              color: Colors.black,
            ),
            TextButton(
              child: const Text('Edit Profile', style: TextStyle(fontSize: 20)),
              onPressed: () {
                // TODO: implement edit profile page
              },
            ),
            // const Divider(color: Colors.grey,),
            TextButton(
              child: const Text('Events I Created',
                  style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => EventsICreatedPage()));
              },
            ),
            TextButton(
              child:
                  const Text('Events I Follow', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => EventsIFollowPage()));
              },
            ),
            TextButton(
              child: const Text('Users/Orgs I Follow',
                  style: TextStyle(fontSize: 20)),
              onPressed: () {
                // TODO: implement users/orgs I follow page
              },
            ),
            TextButton(
              child: const Text('Settings', style: TextStyle(fontSize: 20)),
              onPressed: () {
                // TODO: implement setting page and functionality
              },
            ),
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
              onPressed: () async {
                await logout();
              },
            ),
          ]),
    ));
  }
}
