import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/models/org_models.dart';
import 'package:flutter_test_app/models/user_models.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

enum searchMode {
  events(obj: Event, label: "Search for Events", icon: Icons.event,), //displayWidget: EventCardFavoritable),
  users(obj: User, label: "Search for Users", icon: Icons.person,), //displayWidget: UserCard),
  orgs(obj: Org, label: "Search for Organizations", icon: Icons.group,); //displayWidget: OrgCard),;

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
  searchMode currentMode = searchMode.events; //default search mode
  List<Event> eventSearchResults = [];
  List<User> userSearchResults = [];
  List<Org> orgSearchResults = [];
  late Future _searchFuture = Future.value();



  @override
  void initState() {
    _query = TextEditingController();
    super.initState();
  }

  Future<void> searchEvents() async {
    eventSearchResults = await getSearchedEvents(_query.text);
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
        // Remove the comment when we have the user search functionality
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _query,
                    autocorrect: false,
                    decoration: InputDecoration(
                      // implement this after we have the user search functionality
                      prefixIcon: Icon(currentMode.icon),
                      labelText: currentMode.label,
                      hintText: 'Enter a keyword',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
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
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: _query.text.isEmpty? 
              const Center(
                child: Text('Search Something...'),
              ) 
              :FutureBuilder(
                future: _searchFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('An error occurred while searching. Please try again.'),
                    );
                  } else {
                    if (eventSearchResults.isEmpty) {
                      return const Center(
                        child: Text('No Results Found'),
                      );
                    }
                    return ListView.builder(
                          itemCount: eventSearchResults.length + 1,
                          itemBuilder: (context, index) {
                            if (index == eventSearchResults.length) {
                                return Column(
                                  children: [
                                    Divider(color: Colors.grey[400]),
                                    Text('--End of Search Result--',
                                        style:
                                            TextStyle(color: Colors.grey[600])),
                                    Text('Event Count: ${eventSearchResults.length}',
                                        style:
                                            TextStyle(color: Colors.grey[600])),
                                  ],
                                );
                              } else {
                                return isLoggedIn()
                                    ? EventCardFavoritable(
                                        event: eventSearchResults[index], refreshParent: () => {},)
                                    : EventCardPlain(event: eventSearchResults[index], refreshParent: () => {},);
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