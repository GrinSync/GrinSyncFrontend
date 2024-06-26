import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grinsync/models/event_models.dart';
import 'package:grinsync/api/get_events.dart';
import 'package:grinsync/pages/edit_event_page.dart';

class EventsICreatedPage extends StatefulWidget {
  const EventsICreatedPage({super.key});

  @override
  State<EventsICreatedPage> createState() => _EventsICreatedPageState();
}

class _EventsICreatedPageState extends State<EventsICreatedPage> {
  List<Event> events = []; // list of events created by the user
  late Future _loadEventsFuture; // future for loading events

  /// Get events created by the user from the backend
  Future<void> loadEvents() async {
    events = await getMyEvents(); // function in get_events.dart
  }

  @override
  void initState() {
    _loadEventsFuture = loadEvents();
    super.initState();
  }

  /// Function to refresh the page by loading the events again
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
          'Events I Created',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      // Use a FutureBuilder to wait for the events to load
      body: FutureBuilder(
          future: _loadEventsFuture,
          builder: (context, snapshot) {
            // if the connection is waiting, show a loading indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
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
                  child: Text("You haven't created any events yet."),
                );
                // if there are events, show the events
              } else {
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
                            Text('--End of Your Events Created--',
                                style: TextStyle(color: Colors.grey[600])),
                            Text('Event Count: ${events.length}',
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        );
                      } else {
                        return Slidable(
                          key: ValueKey(events[index]
                              .id), // key for the slidable to enable dismiss
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            dismissible: DismissiblePane(
                              onDismissed: () async {
                                //delete the event and get the message
                                String deleteMsg =
                                    await deleteEvent(events[index].id);

                                // show a snackbar with the message sent from the backend
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(deleteMsg),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                // remove the event from the local list
                                setState(() {
                                  events.removeAt(index);
                                });
                              },
                            ),
                            children: [
                              // Edit and Delete actions for the slidable
                              SlidableAction(
                                onPressed: (context) {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => EventEditPage(
                                                event: events[index],
                                                refreshParent: refresh,
                                              )));
                                },
                                label: 'Edit',
                                icon: Icons.edit,
                                backgroundColor: Colors.blue,
                              ),
                              SlidableAction(
                                onPressed: (context) async {
                                  String deleteMsg =
                                      await deleteEvent(events[index].id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(deleteMsg),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                  setState(() {
                                    events.removeAt(index);
                                  });
                                },
                                label: 'Delete',
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                              ),
                            ],
                          ),
                          child: EventCardPlain(
                            event: events[index],
                            refreshParent: refresh,
                          ),
                        ); // EventCardPlain is an event card Widget in get_events.dart
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
