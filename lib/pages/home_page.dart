import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/models/event_models.dart';

// HomePage shows user a list of events

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Event> allEvents;
  late Future<void> _loadEventsFuture;

  Future<void> loadEvents() async {
    allEvents = await getUpcomingEvents();
  }

  @override
  void initState() {
    super.initState();
    _loadEventsFuture = loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadEventsFuture,
        builder: (context, snapshot) {
          // if the connection is waiting, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                const Text('Preparing events for you...'),
              ],
            );
            // if there is an error, show an error message and a button to try again
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Error loading events'),
                TextButton(
                  onPressed: () {
                    setState(() {
                      loadEvents();
                    });
                  },
                  child: const Text('Try again'),
                ),
              ],
            );
            // if the connection is done, show the events
            } else {
              return Scaffold(
                body: Container(
                  padding: EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    onRefresh: loadEvents,
                    child: ListView.builder(
                      itemCount: allEvents.length + 1,
                      itemBuilder: (context, index) {
                        if (index == allEvents.length) {
                          return Column(
                            children: [
                              Divider(color: Colors.grey[400]),
                              Text('--End of All Events--',
                                  style: TextStyle(color: Colors.grey[600])),
                              Text('Event Count: ${allEvents.length}',
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          );
                        } else {
                          return EventCardtoDetails(event: allEvents[index]);
                        }
                      },
                    ),
                  ),
                ),
              );
            }
          }
);
  }
}

