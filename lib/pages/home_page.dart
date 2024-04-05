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
            // if there are no events, show a message
            if (allEvents.isEmpty) {
              return Scaffold(
                body: Container(
                  padding: EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    onRefresh: loadEvents,
                    child: Center(
                      child: ListView(
                        children: [const Text('No events to show here')],
                      ),
                    ),
                  ),
                ),
              );
              // if there are events, show the events
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
                          return Card(
                            child: ListTile(
                              title: Text(
                                  allEvents[index].title ?? 'Null title',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800)),
                              subtitle: Text(
                                  '${allEvents[index].start ?? 'Null start date'} \n ${allEvents[index].end ?? 'Null end date'}',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[600])),
                              isThreeLine: true,
                              // trailing: Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary), // favorite button to favorite an event
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventDetailsPage(
                                        event: allEvents[index]),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              );
            }
          }
        });
  }
}


// List<Event> getSampleEvents() {
//   List<Event> allEvents = <Event>[];
//   allEvents.add(Event(
//     title: '60s Harris',
//     // location: 'Harris Center',
//     description:
//         'Random event description Random event description Random event description Random event description Random event description',
//     start: '04/06/2024 22:00',
//     end: '04/07/2024 1:00',
//     studentsOnly: true,
//     tags: "",
//   ));
//   allEvents.add(Event(
//     title: 'CSC 324 Study Session',
//     // location: 'Noyce 3815',
//     description: 'We will be preparing for the upcoming presentation',
//     start: '04/10/2024 19:00',
//     end: '04/10/2024 21:00',
//     studentsOnly: true,
//     tags: "",
//   ));
//   allEvents.add(Event(
//     title: 'Ten Ten Party',
//     // location: '1010 High St',
//     description: 'You know what it is',
//     start: '10/10/2024 22:00',
//     end: '10/11/2024 4:00',
//     studentsOnly: true,
//     tags: "",
//   ));
//   return allEvents;
// }


