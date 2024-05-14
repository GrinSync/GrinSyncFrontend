import 'package:flutter/material.dart';
import 'package:grinsync/api/get_events.dart';
import 'package:grinsync/api/user_authorization.dart';
import 'package:grinsync/models/event_models.dart';

/// Class to store search keyword, which is passed from the search results page
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
  String k = ''; // String to hold passed keyword
  late List<Event> events;

  /// Function to get events that match the search string criteria
  Future<void> loadEvents() async {
    allEvents.value = await getSearchedEvents(k);
  }

  /// Initialize page state and keyword
  @override
  void initState() {
    k = widget.todo; // Set string to hold keyword from search page
    super.initState();
  }

  /// Build the page widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Results',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: loadEvents(), // Get events that match the specified keyword
          builder: (context, snapshot) {
            // if the connection is waiting, show a loading indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      'Preparing search results for you...',
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
              // Display list of all events
              return ValueListenableBuilder(
                  valueListenable: allEvents,
                  builder: (context, eventList, child) {
                    return Scaffold(
                      body: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: RefreshIndicator(
                          onRefresh:
                              loadEvents, // Reload events when page refreshes
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
                                return isLoggedIn()
                                    // If the user is logged in they can like events
                                    ? EventCardFavoritable(
                                        event: eventList[index],
                                        refreshParent: () => {})
                                    // If the user is not logged in they cannot like events
                                    : EventCardPlain(
                                        event: eventList[index],
                                        refreshParent: () => {},
                                      );
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
