import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/get_events.dart';

class EventsICreatedPage extends StatefulWidget {

  EventsICreatedPage({super.key});

  @override
  State<EventsICreatedPage> createState() => _EventsICreatedPageState();
}

class _EventsICreatedPageState extends State<EventsICreatedPage> {
  late List<Event> myEvents;

  Future<void> loadEvents() async {
    myEvents = await getMyEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events I Created', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: loadEvents(),
          builder: (context, snapshot) {
            // if the connection is waiting, show a loading indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      const Text('Preparing events for you...',),
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
                          loadEvents();
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
              if (myEvents.isEmpty) {
                return const Center(
                        child: Text("You haven't created any events yet."),
                );
                // if there are events, show the events
              } else {
                return Container(
                    padding: EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: myEvents.length + 1,
                        itemBuilder: (context, index) {
                          if (index == myEvents.length) {
                            return Column(
                              children: [
                                Divider(color: Colors.grey[400]),
                                Text('--End of Your Events Created--',
                                    style: TextStyle(color: Colors.grey[600])),
                                Text('Event Count: ${myEvents.length}',
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            );
                          } else {
                            return EventCardtoEdit(event: myEvents[index]);
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
