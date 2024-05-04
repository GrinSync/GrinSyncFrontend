import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/get_events.dart';

class EventsICreatedPage extends StatefulWidget {
  EventsICreatedPage({super.key});

  @override
  State<EventsICreatedPage> createState() => _EventsICreatedPageState();
}

class EventList extends ChangeNotifier {
  List<Event> _events = [];

  List<Event> get events => _events;

  void setEvents(List<Event> events) {
    _events = events;
    notifyListeners();
  }

  // void toggleLikedEvent(int id) {
  //   final event = _events.firstWhere((element) => element.id == id);
  //   event.isFavorited = !event.isFavorited;
  //   notifyListeners();
  // }

  // void deleteEvent(int id) {
  //   _events.removeWhere((element) => element.id == id);
  //   notifyListeners();
  // }

}

class _EventsICreatedPageState extends State<EventsICreatedPage> {
  ValueNotifier<List<Event>?> myEventsNotifier = ValueNotifier<List<Event>?>(null); // List of events created by the user
  late Future _loadEventsFuture;
  EventList myEvents = EventList();

  // Get events created by the user from the backend
  Future<void> loadEvents() async {
    //myEventsNotifier.value = await getMyEvents(); // function in get_events.dart
    myEvents.setEvents(await getMyEvents());
  }

  @override
  void initState() {
    _loadEventsFuture = loadEvents();
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
              return Center(
                child: 
                    CircularProgressIndicator(),
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
              if (myEvents.events.isEmpty) {
                return const Center(
                  child: Text("You haven't created any events yet."),
                );
                // if there are events, show the events
              } else {
                return ValueListenableBuilder(
                  valueListenable: myEventsNotifier,
                  builder: (context, myEvents, child) {
                    return Container(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
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
                            return EventCardPlain(
                                event: myEvents[index],
                                refreshParent: refresh,); // EventCardPlain is an event card Widget in get_events.dart
                          }
                        },
                      ),
                    );
                  }
                );
              }
            }
          }),
    );
  }
}
