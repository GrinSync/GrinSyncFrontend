import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/api/launch_url.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/api/tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';

// HomePage shows user a list of events

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future _loadEventsFuture; // Future to load events
  List<Event> upcomingEvents = []; // A list of upcoming events as a ValueNotifier
  List<String> availableTags = getAllTags(); // get all tags from the global variable
  List<String> selectedTags = isLoggedIn()? getPreferredTags():getAllTags(); // get the preferred tags from the global variable only if logged in
  bool stduentOnly = false; // show only studentOnly events
  bool intersectionFilter = false; // show events that have all selected tags

  @override
  void initState() {
    super.initState();
    _loadEventsFuture = loadEvents();
  }

  Future<void> loadEvents() async {
    upcomingEvents = await getUpcomingEvents(selectedTags, stduentOnly, intersectionFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => StatefulBuilder(
                builder: (context, setState) => SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 5.0, 
                            runSpacing: 5.0,
                            children: availableTags.map((tag) {
                              return FilterChip(
                                backgroundColor: Colors.white,
                                checkmarkColor: Theme.of(context).colorScheme.primary,
                                label: Text(tag),
                                selected: selectedTags.contains(tag),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedTags.add(tag);
                                      // print(selectedTags);
                                    } else {
                                      selectedTags.remove(tag);
                                      // print(selectedTags);
                                    }
                                  });
                                },
                                );
                            }).toList(),
                            ),
                            // show the studentOnly checkbox only if the user is logged in and is a student
                            if (isLoggedIn() && USER.value?.type == "STU") // show the studentOnly filter only if the user is logged in and is a student
                              CheckboxListTile(
                                title: Text('Show students only events'),
                                value: stduentOnly,
                                onChanged: (value) {
                                  setState(() {
                                    stduentOnly = value!;
                                  });
                                },
                              ),
                              // show the intersection filter
                            CheckboxListTile(
                              title: Text('Only show events with all tags selected'),
                              value: intersectionFilter, 
                              onChanged: (value) {
                                setState(() {
                                  intersectionFilter = value!;
                                });
                              },
                              ),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  ),
                                  child: Text('Revert to default tags'),
                                  onPressed: () {
                                    if (isLoggedIn()) {
                                      setState(() {
                                        selectedTags = getPreferredTags();
                                      });
                                    } else {
                                      setState(() {
                                        // if the user is not logged in, set the preferred tags to all tags
                                        selectedTags = getAllTags();
                                      });
                                    }
                                    
                                  },
                                  ),
                                SizedBox(width: 10.0),  
                              // button to deselect all tags
                          ElevatedButton(
                            child: Text('Deselect all tags'),
                            style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  ),
                            onPressed: () {
                              setState(() {
                                selectedTags = [];
                              });
                            },
                            ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white),
                                child: Text('Apply Filters'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _loadEventsFuture = loadEvents();
                                  });
                                },
                              ),
                          //SizedBox(height: 25.0),
                        ],
                        ),
                    )
                    ),
                )
                )
              ),
            )
        ]
      ), 
      // Original home page starting from here (tag menu added above)
      body: FutureBuilder(
          future: _loadEventsFuture,
          builder: (context, snapshot) {
            // if the connection is waiting, show a loading indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    const Text('Preparing events for you...'),
                  ],
                ),
              );
              // if there is an error, show an error message and a button to try again
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error loading events'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _loadEventsFuture = loadEvents();
                        });
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
              // if the connection is done, show the events
            } else {
              return Container(
                      padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                      child: RefreshIndicator(
                        onRefresh: loadEvents,
                        child: ListView.builder(
                          itemCount: upcomingEvents.length + 1,
                          itemBuilder: (context, index) {
                            if (index == upcomingEvents.length) {
                              return Column(
                                children: [
                                  Divider(color: Colors.grey[400]),
                                  Text('--End of All Events--',
                                      style: TextStyle(color: Colors.grey[600])),
                                  Text('Event Count: ${upcomingEvents.length}',
                                      style: TextStyle(color: Colors.grey[600])),
                                ],
                              );
                            } else {
                              Widget eventCard = isLoggedIn() // return different event cards based on user's login status
                                  ? EventCardFavoritable(event: upcomingEvents[index], refreshParent: () => {})
                                  : EventCardPlain(event: upcomingEvents[index], refreshParent: () => {});
                              return Slidable(
                                child: eventCard,
                                endActionPane: ActionPane(
                                  motion: DrawerMotion(),
                                  children: [
                                    // A SlidableAction can have an icon and/or a label.
                                    SlidableAction(
                                      onPressed: (context) async {
                                        if (upcomingEvents[index].contactEmail != null) {
                                          await MailUtils.contactHost(upcomingEvents[index].contactEmail, upcomingEvents[index].title);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Host email not provided',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.grey[800],
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      },
                                      backgroundColor: Color.fromARGB(255, 255, 172, 28),
                                      foregroundColor: Colors.black,
                                      icon: Icons.email_outlined,
                                      label: 'Contact',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        Share.share(
                                            'Check out this event: ${upcomingEvents[index].title} at ${upcomingEvents[index].location} on ${timeFormat(upcomingEvents[index].start)}!');
                                      },
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.black,
                                      icon: Icons.share,
                                      label: 'Share',
                                    ),
                                  ],
                                ),
                                );
                            }
                          },
                        ),
                      ),
                    );
            }
          }),
    );
  }
}
