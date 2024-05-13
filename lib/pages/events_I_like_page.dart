import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test_app/api/notifications.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventsILikePage extends StatefulWidget {
  const EventsILikePage({super.key});

  @override
  State<EventsILikePage> createState() => _EventsILikePageState();
}

class _EventsILikePageState extends State<EventsILikePage> {
  /// List of all events liked by the current user
  List<Event> events = [];
  late Future _loadEventsFuture;

  /// Whether notifications are enabled
  late bool notificationsEnabled;

  // Get events followed by the user from the server
  Future<void> loadEvents() async {
    events = await getLikedEvents();
  }

  // On page initialization, load the list of events the current user likes
  @override
  void initState() {
    _loadEventsFuture = loadEvents();
    notificationsEnabled = getNotificationsSetting();
    super.initState();
  }

  /// Reloads the list of events as the user refreshes the page
  refresh() {
    setState(() {
      _loadEventsFuture = loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events I Like',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        // A switch button to enable notifications
        actions: [
          Switch(
              activeColor: Colors.white,
              value: notificationsEnabled,
              // Update the notifications setting as the user switches mode
              onChanged: (value) async {
                await setNotificationsSetting(value);
                setState(() {
                  notificationsEnabled = value;
                });
                Fluttertoast.showToast(
                  msg: value
                      ? 'Notifications for liked events enabled'
                      : 'Notifications for liked events disabled',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey[800],
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }),
        ],
      ),
      // Use a FutureBuilder to wait for the events to load
      body: FutureBuilder(
          future: _loadEventsFuture,
          builder: (context, snapshot) {
            // If the connection is waiting, show a loading indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      'Preparing events for you...',
                    ),
                  ],
                ),
              );
            }
            // If there is an error, show an error message and a button to try again
            else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error loading events'),
                    TextButton(
                      onPressed: () {
                        _loadEventsFuture = loadEvents();
                        setState(() {});
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }
            // If the connection is done, show the events
            else {
              // If there are no events, show a message
              if (events.isEmpty) {
                return const Center(
                  child: Text("You have not liked any events yet."),
                );
              }
              // Otherwise, show the events
              else {
                return Container(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: ListView.builder(
                    itemCount: events.length + 1,
                    itemBuilder: (context, index) {
                      if (index == events.length) {
                        return Column(
                          children: [
                            Divider(color: Colors.grey[400]),
                            Text('--End of Your Liked Events--',
                                style: TextStyle(color: Colors.grey[600])),
                            Text('Event Count: ${events.length}',
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        );
                      } else {
                        return Slidable(
                          key: ValueKey(events[index].id),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            dismissible: DismissiblePane(
                              // Unlike an event and reset the state of the page
                              // if user dismisses the pane after sliding the card to the left
                              onDismissed: () {
                                unlikeEvent(events[index].id);
                                setState(() {
                                  events.removeAt(index);
                                });
                                // refresh();
                              },
                            ),
                            children: [
                              SlidableAction(
                                // Unlike an event and reset the state of the page
                                // if user slides the card all the way to the left
                                onPressed: (context) {
                                  unlikeEvent(events[index].id);
                                  events.removeAt(index);
                                  refresh();
                                },
                                label: 'Unlike',
                                backgroundColor: Colors.red,
                              ),
                            ],
                          ),
                          child: EventCardPlain(
                            event: events[index],
                            refreshParent: refresh,
                          ),
                        );
                      }
                    },
                  ),
                );
              }
            }
          }),
    );
  }
}
