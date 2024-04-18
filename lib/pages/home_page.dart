import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/pages/event_details_page.dart';

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
                          return EventCard(event: allEvents[index]);
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


class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,

  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
            event.title ?? 'Null title',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800)),
        subtitle: Text(
            '${event.start ?? 'Null start date'}\n${event.end ?? 'Null end date'}',
            style: TextStyle(
                fontSize: 15, color: Colors.grey[600])),
        isThreeLine: true,
        // trailing: Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary), // favorite button to favorite an event
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(
                  event: event),
            ),
          );
        },
      ),
    );
  }
}
