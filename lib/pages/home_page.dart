import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/global.dart';

// HomePage shows user a list of events

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier upcomingEvents = ValueNotifier<List<Event>?>(null); // A list of upcoming events as a ValueNotifier
  List<String> tagList = PREFERREDTAGS; // get the preferred tags from the global variable

  Future<void> loadEvents() async {
    upcomingEvents.value = await getUpcomingEvents(tagList);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadEvents(),
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
            return ValueListenableBuilder(
                valueListenable: upcomingEvents, // Listens to the upcomingEvents ValueNotifier to rebuild the page when the events are (re)loaded
                builder: (context, eventList, child) {
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    child: RefreshIndicator(
                      onRefresh: loadEvents,
                      child: ListView.builder(
                        itemCount: eventList!.length + 1,
                        itemBuilder: (context, index) {
                          if (index == eventList.length) {
                            return Column(
                              children: [
                                Divider(color: Colors.grey[400]),
                                Text('--End of All Events--',
                                    style: TextStyle(color: Colors.grey[600])),
                                Text('Event Count: ${eventList.length}',
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            );
                          } else {
                            return isLoggedIn() // return different event cards based on user's login status
                                ? EventCardFavoritable(event: eventList[index])
                                : EventCardPlain(event: eventList[index]);
                          }
                        },
                      ),
                    ),
                  );
                });
          }
        });
  }
}
