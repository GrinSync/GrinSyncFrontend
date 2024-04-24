import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/models/event_models.dart';

// HomePage shows user a list of events
class Todo {
  final String keyword;

  const Todo(this.keyword);
}
class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, required this.todo});
  final String todo;
  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  ValueNotifier allEvents = ValueNotifier<List<Event>?>(null);
  String k = '';
  Future<void> loadEvents() async {
    allEvents.value = await getSearchedEvents(k);
  }

  @override
  void initState() {
    k = widget.todo;
    super.initState();
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
                valueListenable: allEvents,
                builder: (context, eventList, child) {
                  return Scaffold(
                    body: Container(
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
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                  Text('Event Count: ${eventList.length}',
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                ],
                              );
                            } else {
                              return EventCardFavoritable(
                                  event: eventList[index]);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                });
          }
        });
  }
}
