import 'package:flutter/material.dart';
import 'package:grinsync/api/get_events.dart';
import 'package:grinsync/api/user_authorization.dart';
import 'package:grinsync/models/event_models.dart';
import 'package:grinsync/models/org_models.dart';
import 'package:grinsync/models/user_models.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

/// This enum is used to determine the search mode. (The commented out code is for future implementation)
enum searchMode {
  events(
    obj: Event,
    label: "Search for Events",
    icon: Icons.event,
  ), //displayWidget: EventCardFavoritable).
  users(
    obj: User,
    label: "Search for Users",
    icon: Icons.person,
  ), //displayWidget: UserCard).
  orgs(
    obj: Org,
    label: "Search for Organizations",
    icon: Icons.group,
  ); //displayWidget: OrgCard).

  const searchMode({
    required this.obj,
    required this.label,
    required this.icon,
    //required this.displayWidget,
  });

  final Type obj;
  final String label;
  final IconData icon;
  //final Type displayWidget;
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _query =
      TextEditingController(); //text box for search
  searchMode currentMode = searchMode.events; // default search mode: Events
  List<Event> eventSearchResults = []; // Event list of search results
  List<User> userSearchResults = []; // User list of search results
  List<Org> orgSearchResults = []; // Organization list of search results
  late Future _searchFuture = Future.value();

  @override
  void initState() {
    _query = TextEditingController(); //text box for search
    super.initState();
  }

  /// This function is used to search for events based on the query.
  Future<void> searchEvents() async {
    eventSearchResults = await getSearchedEvents(_query.text);
  }

  // This functionexecutes the search based on the search mode and _query.text
  void search(String _) {
    if (_query.text.isNotEmpty) {
      if (currentMode == searchMode.events) {
        setState(() {
          _searchFuture = searchEvents();
          // clear the other search results
          userSearchResults = [];
          orgSearchResults = [];
        });
      } else if (currentMode == searchMode.users) {
        // implement this after we have the user search functionality
        // clear the other search results
        eventSearchResults = [];
        orgSearchResults = [];
      } else if (currentMode == searchMode.orgs) {
        // implement this after we have the organization search functionality
        // clear the other search results
        eventSearchResults = [];
        userSearchResults = [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        // Uncomment when we have other search functionalities
        // actions:[
        //   PopupMenuButton(
        //     itemBuilder: (BuildContext context) => [
        //       const PopupMenuItem(
        //         child: Text('Search Events'),
        //         value: searchMode.events,
        //       ),
        //       const PopupMenuItem(
        //         child: Text('Search Users'),
        //         value: searchMode.users,
        //       ),
        //       const PopupMenuItem(
        //         child: Text('Search Organizations'),
        //         value: searchMode.orgs,
        //       ),
        //     ],
        //     onSelected: (searchMode value) {
        //       setState(() {
        //         currentMode = value;
        //       });
        //     },
        //   ),
        // ]
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _query,
                autocorrect: false,
                decoration: InputDecoration(
                  // implement this after we have the user search functionality
                  prefixIcon: Icon(currentMode.icon),
                  labelText: currentMode.label,
                  hintText: 'Enter a keyword',
                  border: const OutlineInputBorder(),
                  // suffixIcon: IconButton(), // implement this when we remove the search button outside the text field and added textInputButtonaction
                ),
                onSubmitted: search,
                textInputAction: TextInputAction.search,
              ),
            ),
            const SizedBox(height: 10),
            // Display search results
            Expanded(
              child: _query.text.isEmpty
                  ? const Center(
                      child: Text('Search Something...'),
                    )
                  : FutureBuilder(
                      future: _searchFuture, // Future to be resolved
                      builder: (context, snapshot) {
                        // loading state
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                          // error state
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                'An error occurred while searching. Please try again.'),
                          );
                        } else {
                          // empty search results
                          if (eventSearchResults.isEmpty) {
                            return const Center(
                              child: Text('No Results Found'),
                            );
                          }
                          // non-empty search results
                          return ListView.builder(
                            itemCount: eventSearchResults.length + 1,
                            itemBuilder: (context, index) {
                              // Display the end of search results
                              if (index == eventSearchResults.length) {
                                return Column(
                                  children: [
                                    Divider(color: Colors.grey[400]),
                                    Text('--End of Search Result--',
                                        style:
                                            TextStyle(color: Colors.grey[600])),
                                    Text(
                                        'Event Count: ${eventSearchResults.length}',
                                        style:
                                            TextStyle(color: Colors.grey[600])),
                                  ],
                                );
                              } else {
                                // Display the search results based on the search mode
                                return isLoggedIn()
                                    ? EventCardFavoritable(
                                        event: eventSearchResults[index],
                                        refreshParent: () => {},
                                      )
                                    : EventCardPlain(
                                        event: eventSearchResults[index],
                                        refreshParent: () => {},
                                      );
                              }
                            },
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
