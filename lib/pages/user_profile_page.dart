import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/pages/connect_org_page.dart';
import 'package:flutter_test_app/pages/events_I_created_page.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/pages/events_I_follow_page.dart';
import 'package:flutter_test_app/pages/orgs_I_lead_page.dart';
import 'package:flutter_test_app/pages/tag_preference_page.dart';

class UserProfilePage extends StatelessWidget {
  final User? user = USER
      .value; // Get the User object from the USER ValueNotifier in global.dart to display the user's information

  UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // display info
              // User's first name and last name
              Text('${user?.firstName} ${user?.lastName}',
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvetica')),
              // User's email
              Text(' ${user?.email}',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600])),
      
              // display buttons
              const Divider(
                color: Colors.black,
              ),
              // Edit Profile button
              TextButton(
                child: const Text('Edit Profile', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  // TODO: implement edit profile page
                },
              ),
              // Events I Created button
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
              // Events I Follow button
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
              // Users/Orgs I Follow button
              TextButton(
                child: const Text('Users/Orgs I Follow',
                    style: TextStyle(fontSize: 20)),
                onPressed: () {
                  // TODO: implement users/orgs I follow page
                },
              ),
              // Settings button
              // TextButton(
              //   child: const Text('Settings', style: TextStyle(fontSize: 20)),
              //   onPressed: () {
              //     // TODO: implement setting page and functionality
              //   },
              // ),
              // Tag Preferences button
              TextButton(
                child:
                    const Text('Tag Preferences', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => TagPreferencePage()),
                  );
                },
              ),
              // My affiliated Student Orgs button
              TextButton(
                child: const Text('Student Organizations I Lead',
                    style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) =>  MyOrgsPage())
                  );
                }
              ),

              // Connect to a Student Org button
              TextButton(
                child: const Text('Connect to a Student Org',
                    style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const ConnectOrgPage()),
                  );
                },
              ),
              Expanded(child: SizedBox()),
              // Logout button
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
                  await logout(); // Call the logout function from user_authorization.dart
                },
              ),
            ]),
      ),
    );
  }
}
