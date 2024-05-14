import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test_app/api/launch_url.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/pages/connect_org_page.dart';
import 'package:flutter_test_app/pages/create_org_page.dart';
import 'package:flutter_test_app/pages/events_I_created_page.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/pages/events_I_like_page.dart';
import 'package:flutter_test_app/pages/orgs_I_follow_page.dart';
import 'package:flutter_test_app/pages/orgs_I_lead_page.dart';
import 'package:flutter_test_app/pages/tag_preference_page.dart';

class UserProfilePage extends StatelessWidget {
  final User? user = USER
      .value; // Get the User object from the USER ValueNotifier in global.dart to display the user's information

  UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
              // TextButton(
              //   child: const Text('Edit Profile', style: TextStyle(fontSize: 20)),
              //   onPressed: () {
              //     // TODO: implement edit profile page
              //   },
              // ),
              // Tag Preferences button
              TextButton(
                child: const Text('Tag Preferences',
                    style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const TagPreferencePage()),
                  );
                },
              ),

              Divider(
                color: Colors.grey[500],
                indent: 5,
                endIndent: 5,
              ),

              // Events I Created button
              TextButton(
                child: const Text('Events I Created',
                    style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const EventsICreatedPage()));
                },
              ),
              // Events I Follow button
              TextButton(
                child: const Text('Events I Follow',
                    style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const EventsILikePage()));
                },
              ),

              Divider(
                color: Colors.grey[500],
                indent: 5,
                endIndent: 5,
              ),

              // Users/Orgs I Follow button
              TextButton(
                child: const Text('Student Organizations I Follow',
                    style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const OrgsIFollowPage()));
                },
              ),
              // Settings button
              // TextButton(
              //   child: const Text('Settings', style: TextStyle(fontSize: 20)),
              //   onPressed: () {
              //     // TODO: implement setting page and functionality
              //   },
              // ),

              // My affiliated Student Orgs button
              TextButton(
                  child: const Text('Student Organizations I Lead',
                      style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const MyOrgsPage()));
                  }),

              // Create a Student Org button
              TextButton(
                  child: const Text('Create a Student Organization',
                      style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const CreateOrgPage()));
                  }),

              // Connect to a Student Org button
              TextButton(
                  child: const Text('Connect to a Student Organization',
                      style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const ConnectOrgPage()));
                  }),

              Divider(
                color: Colors.grey[500],
                indent: 5,
                endIndent: 5,
              ),

              // Feedback button that links to a Google Form
              TextButton(
                  child: const Text('Feedback (Google Form)',
                      style: TextStyle(fontSize: 20)),
                  onPressed: () async {
                    await urlLauncher(Uri.parse(
                        'https://docs.google.com/forms/d/e/1FAIpQLSeg71_cqskaCDyWsqf-wn2TjHlVRWKBJeVkGjHMJLQYp5CHBw/viewform?usp=sf_link'));
                  }),

              // Connect to a Student Org button
              // TextButton(
              //   child: const Text('Connect to a Student Org',
              //       style: TextStyle(fontSize: 20)),
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       CupertinoPageRoute(
              //           builder: (context) => const ConnectOrgPage()),
              //     );
              //   },
              // ),

              const Expanded(child: SizedBox()),
              // Logout button
              ElevatedButton(
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
                child: const Text('Logout', style: TextStyle(fontSize: 20)),
              ),
            ]),
      ),
    );
  }
}
