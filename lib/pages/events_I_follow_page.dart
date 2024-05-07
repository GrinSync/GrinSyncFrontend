import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test_app/api/notifications.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventsIFollowPage extends StatefulWidget {
  EventsIFollowPage({super.key});

  @override
  State<EventsIFollowPage> createState() => _EventsIFollowPageState();
}

class _EventsIFollowPageState extends State<EventsIFollowPage> {
  List<Event> events = [];
  late Future _loadEventsFuture;
  late bool notificationsEnabled;

  // Get events followed by the user from the backend
  Future<void> loadEvents() async {
    events = await getLikedEvents(); // function in get_events.dart
  }

    @override
  void initState() {
    _loadEventsFuture = loadEvents();
    notificationsEnabled = getNotificationsSetting();
    super.initState();
  }

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
          'Events I Follow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          Switch(
            activeColor: Colors.white,
            value: notificationsEnabled, 
            onChanged: (value) async {
              await setNotificationsSetting(value);
              setState(() {
                notificationsEnabled = value;
              });
              Fluttertoast.showToast(
                msg: value
                    ? 'Notifications for favorited events enabled'
                    : 'Notifications for favorited events disabled',
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
            // if the connection is waiting, show a loading indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    const Text(
                      'Preparing events for you...',
                    ),
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
                        _loadEventsFuture = loadEvents();
                        setState(() {});
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
              // if the connection is done, show the events
            } else {
              // if there are no events, show a message
              if (events.isEmpty) {
                return const Center(
                  child: Text("You are not following any events yet."),
                );
                // if there are events, show the events
              } else {
                return Container(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: ListView.builder(
                    itemCount: events.length + 1,
                    itemBuilder: (context, index) {
                      if (index == events.length) {
                        return Column(
                          children: [
                            Divider(color: Colors.grey[400]),
                            Text('--End of Your Saved Events--',
                                style: TextStyle(color: Colors.grey[600])),
                            Text('Event Count: ${events.length}',
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        );
                      } else {
                        return Slidable(
                          key: ValueKey(events[index].id),
                          child: EventCardPlain(
                              event: events[index],
                              refreshParent: refresh,),
                          endActionPane: ActionPane(
                            motion: DrawerMotion(),
                            dismissible: DismissiblePane(
                              onDismissed: () {
                                unlikeEvent(events[index].id);
                                setState(() {
                                  events.removeAt(index);
                                });
                                //refresh();
                              },
                              ),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  // Remove the event from the user's liked events
                                  unlikeEvent(events[index].id);
                                  events.removeAt(index);
                                  refresh();
                                },
                                label: 'Unsave',
                                backgroundColor: Colors.red,
                              ),
                            ],
                          ),
                        ); // EventCardFavoritable is a custom widget that displays an event with a favorite button
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
