import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/api/launch_url.dart';
import 'package:flutter_test_app/api/save_event_to_calendar.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/api/tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// HomePage shows user a list of upcoming events
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future _loadEventsFuture; // Future to load events
  List<Event> upcomingEvents =
      []; // A list of upcoming events as a ValueNotifier
  List<String> availableTags =
      getAllTags(); // get all tags from the global variable
  List<String> selectedTags = isLoggedIn()
      ? getPreferredTags()
      : getAllTags(); // get the preferred tags from the global variable only if logged in
  bool stduentOnly = false; // show only studentOnly events
  bool intersectionFilter = false; // show events that have all selected tags

  @override
  void initState() {
    super.initState();
    _loadEventsFuture = loadEvents(); // load events
  }

  /// This function is used to load the upcoming events based on the selected tags, 'studentOnly', and 'intersectionFilter' setting.
  Future<void> loadEvents() async {
    upcomingEvents =
        await getUpcomingEvents(selectedTags, stduentOnly, intersectionFilter);
  }

  /// This function is used to refresh the events list by calling loadEvents() and setting the state.
  refresh() {
    setState(() {
      _loadEventsFuture = loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Upcoming Events',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          actions: [
            // filter menu
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => StatefulBuilder(
                      builder: (context, setState) => SafeArea(
                            child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  // make the filter menu scrollable
                                  child: Column(
                                    // filter menu content
                                    children: [
                                      Wrap(
                                        // wrap the tags in a row
                                        spacing: 5.0,
                                        runSpacing: 5.0,
                                        children: availableTags.map((tag) {
                                          return FilterChip(
                                            // create a filter chip for each tag
                                            backgroundColor: Colors.white,
                                            checkmarkColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            label: Text(tag),
                                            selected:
                                                selectedTags.contains(tag),
                                            onSelected: (selected) {
                                              setState(() {
                                                if (selected) {
                                                  selectedTags.add(
                                                      tag); // add the tag to the selected tags list
                                                } else {
                                                  selectedTags.remove(
                                                      tag); // remove the tag from the selected tags list
                                                }
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      // show the studentOnly checkbox only if the user is logged in and is a student
                                      if (isLoggedIn() &&
                                          USER.value?.type == "STU")
                                        CheckboxListTile(
                                          title:
                                              Text('Show students only events'),
                                          value: stduentOnly,
                                          onChanged: (value) {
                                            setState(() {
                                              stduentOnly = value!;
                                            });
                                          },
                                        ),
                                      // show the intersection filter
                                      CheckboxListTile(
                                        title: Text(
                                            'Only show events with all tags selected'),
                                        value: intersectionFilter,
                                        onChanged: (value) {
                                          setState(() {
                                            intersectionFilter = value!;
                                          });
                                        },
                                      ),
                                      // tag menu buttons
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // button to revert to default tags
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                            ),
                                            child:
                                                Text('Revert to default tags'),
                                            onPressed: () {
                                              if (isLoggedIn()) {
                                                setState(() {
                                                  // if the user is logged in, set the preferred tags to the user's preferred tags
                                                  selectedTags =
                                                      getPreferredTags();
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
                                                // clear the selected tags list
                                                selectedTags = [];
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      // apply filters button
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            foregroundColor: Colors.white),
                                        child: Text('Apply Filters'),
                                        // close the filter menu and apply the filters
                                        onPressed: () {
                                          Navigator.pop(context);
                                          refresh();
                                        },
                                      ),
                                      //SizedBox(height: 25.0),
                                    ],
                                  ),
                                )),
                          ))),
            )
          ]),
      // Original home page (event list) starting from here (tag menu added above)
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
                        refresh();
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            } else {
              // if the connection is done, show the events
              return Container(
                padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    refresh();
                  },
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
                        // create an event card for each event
                        // define the event card based on the user's login status
                        Widget eventCard =
                            isLoggedIn() // return different event cards based on user's login status
                                ? EventCardFavoritable(
                                    event: upcomingEvents[index],
                                    refreshParent: () => {})
                                : EventCardPlain(
                                    event: upcomingEvents[index],
                                    refreshParent: () => {});
                        return Slidable(
                          // make the event card slidable
                          child: eventCard,
                          endActionPane: ActionPane(
                            motion: DrawerMotion(),
                            children: [
                              // slidable action to contact the host
                              SlidableAction(
                                onPressed: (context) async {
                                  if (upcomingEvents[index].contactEmail !=
                                      null) {
                                    // jump to the email app with the host's email pre-filled
                                    await MailUtils.contactHost(
                                        upcomingEvents[index].contactEmail,
                                        upcomingEvents[index].title);
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
                                backgroundColor:
                                    Color.fromARGB(255, 255, 172, 28),
                                foregroundColor: Colors.black,
                                icon: Icons.email_outlined,
                                label: 'Contact',
                              ),
                              // slidable action to save the event to calendar
                              SlidableAction(
                                onPressed: (context) async {
                                  await saveEventToCalendar(
                                      context, upcomingEvents[index]);
                                },
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.black,
                                icon: Icons.today_outlined,
                                label: 'Save',
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
