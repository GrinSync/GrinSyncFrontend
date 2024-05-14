import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_student_orgs.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/org_models.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrgDetailsPage extends StatefulWidget {
  final Org org; // Organization to display details of
  final VoidCallback
      refreshParent; // Callback function to refresh the parent page

  @override
  _OrgDetailsPageState createState() => _OrgDetailsPageState();

  // constructor
  const OrgDetailsPage(
      {super.key, required this.org, required this.refreshParent});
}

class _OrgDetailsPageState extends State<OrgDetailsPage> {
  late bool _isFollowing; // Local variable to store the org follow status
  List<User> leaders = []; // List of student leaders in the organization
  List<Event> events = []; // List of events created by the organization
  late Future _leadersFuture; // Future for loading student leaders
  late Future _eventsFuture; // Future for loading events

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.org.isFollowed;
    _leadersFuture = initializeLeaders();
    _eventsFuture = initializeEvents();
  }

  /// Function to initialize the student leaders in the organization
  initializeLeaders() async {
    for (int id in widget.org.studentLeaders) {
      User? leader = await getUserByID(id);

      if (leader != null) {
        setState(() {
          leaders.add(leader);
        });
      }
    }
  }

  /// Function to initialize the events created by the organization
  initializeEvents() async {
    for (int id in widget.org.orgEvents) {
      Event? event = await getEventByID(id);

      if (event != null) {
        setState(() {
          events.add(event);
        });
      }
    }
  }

  /// Function to refresh the events list by
  refreshEvents() {
    setState(() {
      events.clear();
      _eventsFuture = initializeEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Org Title
              Text(
                widget.org.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Helvetica',
                ),
              ),

              // Org Email
              Text(
                widget.org.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 10),

              // Student Leaders
              const Text(
                'Leaders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Student Leader Cards
              FutureBuilder(
                  future: _leadersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (leaders.isEmpty) {
                      return const Text('No student leaders found');
                    }
                    return SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: leaders.length,
                        itemBuilder: (context, index) {
                          return OrgLeaderCard(leader: leaders[index]);
                        },
                      ),
                    );
                  }),

              const SizedBox(height: 10),
              // Description
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  child: Text(
                    widget.org.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // Events Section
              const Divider(
                height: 20,
                color: Colors.black,
              ),
              Text(
                'Events Created by ${widget.org.name}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              // Event Card list
              Expanded(
                child: FutureBuilder(
                    future: _eventsFuture,
                    builder: (context, Snapshot) {
                      if (Snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (events.isEmpty) {
                        return const Center(
                            child: Text(
                                'No events are created by this organization yet'));
                      }
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return isLoggedIn() // return different event cards based on user's login status
                              ? EventCardFavoritable(
                                  event: events[index],
                                  refreshParent: refreshEvents)
                              : EventCardPlain(
                                  event: events[index],
                                  refreshParent: refreshEvents);
                        },
                      );
                    }),
              ),

              const SizedBox(height: 16),

              // Follow/Unfollow Button
              if (isLoggedIn())
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 172, 28),
                        foregroundColor: Colors.black),
                    onPressed: () async {
                      // Send a request to the server to toggle the follow status
                      await toggleFollowedOrg(widget.org.id);

                      setState(() {
                        _isFollowing =
                            !_isFollowing; // Toggle the local variable
                        widget.org.isFollowed =
                            !widget.org.isFollowed; // Update the org object
                      });

                      Fluttertoast.showToast(
                          msg: _isFollowing
                              ? 'Followed successfully'
                              : 'Unfollowed successfully',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[800],
                          textColor: Colors.white,
                          fontSize: 16.0);

                      // Refresh the parent page
                      widget.refreshParent();
                    },
                    child: Text(_isFollowing ? 'Unfollow' : 'Follow'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stateless widget for displaying student leader names
class OrgLeaderCard extends StatelessWidget {
  final User leader;
  const OrgLeaderCard({
    super.key,
    required this.leader,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: InkWell(
          child: Card(
            color: Colors.blue[100],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_box, size: 50),
                  Text(leader.firstName),
                  Text(leader.lastName),
                ],
              ),
            ),
          ),
          onTap: () {
            //TODO: Implement navigation to UserDetailsPages
          }),
    );
  }
}
